// Тестирование аналогового компаратора
.include "1200def.inc"

.cseg

.org 0
	rjmp	reset
.org ACIaddr
	rjmp	ana_comp

; Инициализация
reset:
	nop
	ldi		r16,0x04
	out		DDRB,r16
	ldi		r16,0x08
	out		ACSR,r16
	sei

; Главный цикл
main:
	nop
	rjmp	main

; Обработчик прерывания аналогового компаратора
ana_comp:
	clr		r16
	sbic	ACSR,5
	ori		r16,0x04
	out		PORTB,r16
	reti
