; Пример 3
; Управление шаговым двигателем

; Заголовочный файл для микроконтроллера ATmega8
.include "m8def.inc"

; Сегмент кода
.cseg

; Начало с 0-го адреса таблицы векторов используемых прерываний
.org 0				; Вектор прерывания сброса всегда находится в памяти программ на 0-м адресе
	rjmp		reset		; Здесь названия "reset", "tim0_ovf" взяты произвольно
.org OVF0addr			
	rjmp		tim0_ovf	; Вектор прерывания по переполнению таймера 0
.org ADCCaddr
	rjmp		adc_complete; Вектор прерывания по завершению АЦП

; Инициализация
reset:
; Установка указателя стека
	ldi		r16,low(RAMEND)
	out		SPL,r16
	ldi		r16,high(RAMEND)
	out		SPH,r16

; Использование портов - что к чему подключено
;
; Порт B
;------------
;
; Подключение шагового двигателя
;--------------------------------
; Бит PB0 (маска 0x01): m1
; Бит PB1 (маска 0x02): m2
; Бит PB2 (маска 0x04): m3
; Бит PB3 (маска 0x08): m4
;
	; Настройка порта B
	;-------------------
	ldi		r16,0x0f
	out		DDRB,r16
	ldi		r16,0x01
	out		PORTB,r16
;
; Порт C
;--------
;
; Бит PC0 (маска 0x01): temp - аналоговый температурный датчик
;
; Управление светодиодными индикаторами
;---------------------------------------
; Бит PC1 (маска 0x02): i1 - индикатор 1 (десятки градусов)
; Бит PC2 (маска 0x04): i2 - индикатор 2 (единицы градусов)
; Бит PC3 (маска 0x08): i3 - индикатор 3 (значок градуса)
; Бит PC4 (маска 0x10): i4 - индикатор 4 (значок Цельсия)
; Бит PC5 (маска 0x20): led - индикатор включения шагового двигателя
	; Настройка порта С
	ldi		r16,0x3e
	out		DDRC,r16
	clr		r16
	out		PORTC,r16
;
; Порт D
;------------
;
; Порт D задействован на управление сегментами светодиодных индикаторов
;------------
; Бит PD0 (маска 0x01): a
; Бит PD1 (маска 0x02): b
; Бит PD2 (маска 0x04): c
; Бит PD3 (маска 0x08): d
; Бит PD4 (маска 0x10): e
; Бит PD5 (маска 0x20): f
; Бит PD6 (маска 0x40): g
;
	; Настройка порта D
	;-------------------
	ldi		r16,0x7f
	out		DDRD,r16
	clr		r16
	out		PORTD,r16

	; Регистр для хранения измеренного значения температуры
	clr		r18

	; Настройка таймера 0
	;---------------------
	; Таймер 0 нужен для управления шаговым двигателем
	ldi		r16,0x01
	out		TCCR0,r16	; Коэффициент деления частоты clk/1
	clr		r16
	out		TCNT0,r16	; Очистка счётчика таймера

	; Настройка АЦП
	ldi		r16,0x40	; Выбор вывода PC0 для преобразования,
					;  выбор внешнего опорного напряжения (в схеме
					;  к выводу AREF микроконтроллера подключен
					;  источник постоянного напряжения 3В 
	out		ADMUX,r16
	ldi		r16,0xef	; Включение АЦП, включение режима непрерывного преобразования,
					;  разрешение прерывания по завершению преобразования,
					;  установка коэффициента деления системной частоты clk/2
	out		ADCSRA,r16

	; Глобальное разрешение прерываний
	sei

; Главный рабочий цикл
;----------------------
; Здесь происходит переключение светодиодных индикаторов
main:
	in		r16,PORTC
	andi		r16,0x1e
	lsl		r16
	andi		r16,0x1e
	cpi		r16,0x00
	brne		mM
	ldi		r16,0x02
mM:
	sbis		PORTC,1
	rjmp		m1
	; Индикатор 1 активен сейчас
m0:
	cbi		PORTC,1
	rcall		display
	sbi		PORTC,2
	rjmp		main
m1:
	sbis		PORTC,2
	rjmp		m2
	; Индикатор 2 активен сейчас
	cbi		PORTC,2
	rcall		display
	sbi		PORTC,3
	rjmp		main
m2:
	sbis		PORTC,3
	rjmp		m3
	; Индикатор 2 активен сейчас
	cbi		PORTC,3
	rcall		display
	sbi		PORTC,4
	rjmp		main
m3:
	sbis		PORTC,4
	rjmp		mR
	; Индикатор 3 активен сейчас
	cbi		PORTC,4
	rcall		display
	sbi		PORTC,1
	rjmp		main
mR:
; Исключительная ситуация, которой, в принципе, быть не может
; Но, на всякий случай, пусть следующие строки будут здесь, в коде
	rjmp		m0

	rjmp		main		; Возврат к началу главного рабочего цикла

; Обработчик прерывания по переполнению таймера 0
;-------------------------------------------------
; Управление шаговым двигателем
tim0_ovf:
	in		r22,PORTB
	lsl		r22
	andi		r22,0x0f
	cpi		r22,0x00
	brne		tim0_end
	ldi		r22,0x01
tim0_end:
	out		PORTB,r22
; Восстановление корректировочного значения
	clr		r22
	out		TCNT0,r22
	reti

; Обработчик прерывания по завершению АЦП
;-----------------------------------------
; Перекодирование результата АЦП в градусы по Цельсию
;  и управление запуском/остановом шагового двигателя
; При температуре более 23-х градусов шаговый двигатель включается
; При температуре меньше или равной 23-м градусам шаговый двигатель отключается
adc_complete:
	in		r30,ADCL
	clr		r19
adc_to_degree:
	subi		r30,6
	brlo		adc_motor_control
	inc		r19
	rjmp		adc_to_degree
adc_motor_control:
	cpi		r19,24
	brlo		adc_motor_turn_off
	ldi		r30,0x01
	out		TIMSK,r30
	sbi		PORTC,5
	rjmp		adc_decode
adc_motor_turn_off:
	clr		r30
	out		TIMSK,r30
	cbi		PORTC,5
adc_decode:
	rcall		bin2bcd
	reti

; Выдача в порт D данных - зажигание соответствующих цифре индикатора сегментов
display:
; Определение какой индикатор выбран для отображения
; Этот код - некоторое подобие "switch" в языке Си
	cpi		r16,0x02
	brne		display_next1
	; Десятки градусов
	mov		r17,r18
	swap		r17
	rjmp		decoder
display_next1:
	cpi		r16,0x04
	brne		display_next2
	; Единицы градусов
	mov		r17,r18
	rjmp		decoder
display_next2:
	cpi		r16,0x08
	brne		display_next3
	; Значок градуса
	ldi		r17,0x63
	rjmp		display_end
display_next3:
	;cpi		r16,0x10
	;brne		display_next4
	; Значок Цельсия
	ldi		r17,0x39
	rjmp		display_end

; Это часть функции "display"
; Отвечает за декодирование чисел для вывода на дисплей
decoder:
	andi		r17,0x0f
; Этот код тоже структурно напоминает "switch" в языке Си
	cpi		r17,0
	brne		decoder_next1
	ldi		r17,0x3f
	rjmp		display_end
decoder_next1:
	cpi		r17,1
	brne		decoder_next2
	ldi		r17,0x06
	rjmp		display_end
decoder_next2:
	cpi		r17,2
	brne		decoder_next3
	ldi		r17,0x5b
	rjmp		display_end
decoder_next3:
	cpi		r17,3
	brne		decoder_next4
	ldi		r17,0x4f
	rjmp		display_end
decoder_next4:
	cpi		r17,4
	brne		decoder_next5
	ldi		r17,0x66
	rjmp		display_end
decoder_next5:
	cpi		r17,5
	brne		decoder_next6
	ldi		r17,0x6d
	rjmp		display_end
decoder_next6:
	cpi		r17,6
	brne		decoder_next7
	ldi		r17,0x7d
	rjmp		display_end
decoder_next7:
	cpi		r17,7
	brne		decoder_next8
	rjmp		display_end
decoder_next8:
	cpi		r17,8
	brne		decoder_next9
	ldi		r17,0x7f
	rjmp		display_end
decoder_next9:
	ldi		r17,0x6f
display_end:
	out		PORTD,r17	; Вывод результата декодирования в порт D
	ret

; Преобразование двоичного числа в двоично-десятичное
bin2bcd:
	clr		r20
	; Проверка превышения значения (>99)
	cpi		r19,100
	brlo		b2b_normal
	ldi		r18,0x99
	rjmp		b2b_end
b2b_normal:
	cpi		r19,10
	brlo		b2b_1
	subi		r19,10
	inc		r20
	rjmp		b2b_normal
b2b_1:
	swap		r20
	or		r19,r20
	mov		r18,r19
b2b_end:
	ret
 





