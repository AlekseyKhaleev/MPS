; Пример 2
; Часы реального времени на внутреннем таймере

; Заголовочный файл для микроконтроллера AT90S2313
.include "2313def.inc"

; Сегмент данных
.dseg
h:	.byte 1	; Часы
m:	.byte 1	; Минуты
s:	.byte 1	; Секунды

; Сегмент кода
.cseg

; Начало с 0-го адреса таблицы векторов используемых прерываний
.org 0				; Вектор прерывания сброса всегда находится в памяти программ на 0-м адресе
	rjmp		reset		; Здесь названия "reset", "tim0_ovf" взяты произвольно
.org OVF1addr			
	rjmp		tim1_ovf	; Вектор прерывания по переполнению таймера 1
.org OVF0addr			
	rjmp		tim0_ovf	; Вектор прерывания по переполнению таймера 0

; Инициализация
reset:
; Установка указателя стека
	ldi		r16,low(RAMEND)
	out		SPL,r16

; Использование портов - что к чему подключено
;
; Порт B
;------------
;
; Биты (выводы), управляющие поочерёдным включением светодиодных индикаторов
;------------
; Бит PB0 (маска 0x01): i1 - индикатор 1 (десятки часов)
; Бит PB1 (маска 0x02): i2 - индикатор 2 (единицы часов)
; Бит PB2 (маска 0x04): i3 - индикатор 3 (десятки минут)
; Бит PB3 (маска 0x08): i4 - индикатор 4 (единицы минут)
; Бит PB4 (маска 0x10): i5 - индикатор 5 (десятки секунд)
; Бит PB5 (маска 0x20): i6 - индикатор 6 (единицы секунд)
;
; Биты 
;------------
; Бит PB6 (маска 0x40): k1
; Бит PB7 (маска 0x80): k2

	; Настройка порта B
	;-------------------
	ldi		r16,0x3f	; Выводы кнопок - входы, выводы индикаторов - выходы
	out		DDRB,r16
;
; Порт D
;------------
;
; Порт D целиком задействован на управление сегментами светодиодных индикаторов
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

	; Очистка переменных времени
	;----------------------------
	; Время хранится в двоично-десятичном виде
	sts		h,r16
	sts		m,r16
	sts		s,r16

	; Настройка таймера 0
	;---------------------
	; Таймер 0 нужен для организации периодического опроса (проверки)
	;  состояния кнопок - не нажаты ли.
	ldi		r16,0x02
	out		TCCR0,r16	; Коэффициент деления частоты clk/1024
	clr		r16
	out		TCNT0,r16	; Очистка счётчика таймера

	; Настройка таймера 1
	;---------------------
	; Таймер 1 нужен для счёта времени, а, точнее сказать, для формирования
	;  относительно точной задержки в 1 секунду.
	; Хотя по точности часы на таймере весьма неточные, но самые дешёвые в реализации
	ldi		r16,0x03
	out		TCCR1B,r16
	ldi		r16,0xff
	out		TCNT1H,r16
	ldi		r16,0x70
	out		TCNT1L,r16

	; Разрешение прерываний по переполнению таймеров 1 и 0
	ldi		r16,0x82	; бит 7 (маска 0x80) - для таймера 1, бит 1 (маска 0x02) - для таймера 0
	out		TIMSK,r16

	; Глобальное разрешение прерываний
	sei

; Главный рабочий цикл
;----------------------
; Здесь происходит переключение светодиодных индикаторов
main:
	in		r16,PORTB
	lsl		r16
	andi		r16,0x3f
	cpi		r16,0x00
	brne		mM
	ldi		r16,0x01
mM:
	sbis		PORTB,0
	rjmp		m1
	; Индикатор 1 активен сейчас
m0:
	cbi		PORTB,0
	rcall		display
	sbi		PORTB,1
	rjmp		main
m1:
	sbis		PORTB,1
	rjmp		m2
	; Индикатор 2 активен сейчас
	cbi		PORTB,1
	rcall		display
	sbi		PORTB,2
	rjmp		main
m2:
	sbis		PORTB,2
	rjmp		m3
	; Индикатор 2 активен сейчас
	cbi		PORTB,2
	rcall		display
	sbi		PORTB,3
	rjmp		main
m3:
	sbis		PORTB,3
	rjmp		m4
	; Индикатор 3 активен сейчас
	cbi		PORTB,3
	rcall		display
	sbi		PORTB,4
	rjmp		main
m4:
	sbis		PORTB,4
	rjmp		m5
	; Индикатор 4 активен сейчас
	cbi		PORTB,4
	rcall		display
	sbi		PORTB,5
	rjmp		main
m5:
	sbis		PORTB,5
	rjmp		mR
	; Индикатор 5 активен сейчас
	cbi		PORTB,5
	rcall		display
	sbi		PORTB,0
	rjmp		main
mR:
; Исключительная ситуация, которой, в принципе, быть не может
; Но, на всякий случай, пусть следующие строки будут здесь, в коде
	rjmp		m0

	rjmp		main		; Возврат к началу главного рабочего цикла

; Обработчик прерывания по переполнению таймера 1
;-------------------------------------------------
; Здесь происходит подсчёт времени
tim1_ovf:
; Загрузка секунд
	lds		r23,s
; Инкремент единиц секунд
	inc		r23
; Проверка не накопилось ли 10 секунд
	mov		r31,r23
	andi		r31,0x0f
	cpi		r31,0x0a
	brne		tim_s		; Не накописось
	rjmp		tim_ss	; Накопилось
tim_s:
; Сохранение секунд и выход
	sts		s,r23
	rjmp		tim_end
tim_ss:
; Инкремент десятков секунд
	andi		r23,0xf0
	ldi		r31,0x10
	add		r23,r31
; Проверка не накопилось ли 60 секунд
	cpi		r23,0x60
	brlo		tim_s		; Не накопилось
; Накопилось
; Обнуление и сохранение секунд
	clr		r23
	sts		s,r23
; Загрузка минут
	lds		r23,m
; Инкремент единиц минут
	inc		r23
; Проверка не накопилось ли 10 минут
	mov		r31,r23
	andi		r31,0x0f
	cpi		r31,0x0a
	brne		tim_m		; Не накописось
	rjmp		tim_mm	; Накопилось
tim_m:
; Сохранение минут и выход
	sts		m,r23
	rjmp		tim_end
tim_mm:
; Инкремент десятков минут
	andi		r23,0xf0
	ldi		r31,0x10
	add		r23,r31
; Проверка не накопилось ли 60 минут
	cpi		r23,0x60
	brlo		tim_m		; Не накопилось
; Накопилось
; Обнуление и сохранение минут
	clr		r23
	sts		m,r23
; Загрузка часов
	lds		r23,h
; Инкремент единиц часов
	inc		r23
; Проверка не накопилось ли 10 часов
	mov		r31,r23
	andi		r31,0x0f
	cpi		r31,0x0a
	brne		tim_h		; Не накописось
	rjmp		tim_hh	; Накопилось
tim_h:
; Сохранение минут и выход
	sts		h,r23
	rjmp		tim_end
tim_hh:
; Инкремент десятков часов
	andi		r23,0xf0
	ldi		r31,0x10
	add		r23,r31
; Проверка не накопилось ли 24 часа
	cpi		r23,0x24
	brlo		tim_h		; Не накопилось
; Накопилось
; Обнуление и сохранение часов
	clr		r23
	sts		h,r23
tim_end:
; Восстановление корректировочного значения
; Так сказать, подстройка таймера на частоту 1 Гц
	ldi		r31,0xff
	out		TCNT1H,r31
	ldi		r31,0x70
	out		TCNT1L,r31
	reti

; Обработчик прерывания по переполнению таймера 0
;-------------------------------------------------
; Здесь происходит опрос (проверка) состояния кнопок, точнее говоря, уровней
;  на их выводах (логическая 1 или логический 0)
tim0_ovf:
; Проверка нажатия кнопки 1
	sbic		PINB,6	; Проверка нажатия 1
	rjmp		key_pin6_set
; Кнопка 1 нажата
; Инкремент часов
	lds		r19,h
	inc		r19
	cpi		r19,0x24
	brne		save_h
	clr		r19
save_h:
	sts		h,r19
key_pin6_set:
; Проверка нажатия кнопки 2
	sbic		PINB,7	; Проверка нажатия 2
	rjmp		key_pin7_set
; Кнопка 2 нажата
; Инкремент минут
	lds		r19,m
	inc		r19
	cpi		r19,0x60
	brne		save_m
	clr		r19
save_m:
	sts		m,r19
key_pin7_set:
	reti

; Выдача в порт D данных - зажигание соответствующих цифре индикатора сегментов
display:
; Определение какой индикатор выбран для отображения
; Этот код - некоторое подобие "switch" в языке Си
	cpi		r16,0x01
	brne		display_next1
	; Десятки часов
	lds		r17,h
	swap		r17
	rjmp		decoder
display_next1:
	cpi		r16,0x02
	brne		display_next2
	; Единицы часов
	lds		r17,h
	rjmp		decoder
display_next2:
	cpi		r16,0x04
	brne		display_next3
	; Десятки минут
	lds		r17,m
	swap		r17
	rjmp		decoder
display_next3:
	cpi		r16,0x08
	brne		display_next4
	; Единицы минут
	lds		r17,m
	rjmp		decoder
display_next4:
	cpi		r16,0x10
	brne		display_next5
	; Десятки секунд
	lds		r17,s
	swap		r17
	rjmp		decoder
display_next5:
	; Единицы секунд
	lds		r17,s

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
 
