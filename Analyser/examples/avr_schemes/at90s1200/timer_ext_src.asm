; Тестирование таймера, тактирование от внешнего источника
.include "1200def.inc"

; Сегмент кода
.cseg
.org 0

; Таблица векторов прерываний
	rjmp	reset
.org OVF0addr
    rjmp	tim0_ovf

; Обработчик прерывания "RESET"
; Как правило, здесь выполняется инициализация программы, подготовка к работе, так сказать
reset:
	ldi		r16,0xff
	out		DDRB,r16
	ldi		r16,0x00
	out		PORTB,r16
	out		DDRD,r16
	
	ldi		r16,0xfd
    out		TCNT0,r16
	ldi		r16,0x07
	out		TCCR0,r16
	ldi		r16,0x02
	out		TIMSK,r16
	sei

; Главный цикл
main:
	rjmp	main

; Обработчик прерывания по переполнению таймера
; Здесь выполняется вывод данных в порт B на светодиоды
tim0_ovf:
	in		r16,PORTB
	inc		r16
	out		PORTB,r16
	ldi		r16,0xfd
	out		TCNT0,r16
	reti
