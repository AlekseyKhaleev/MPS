; Вывод данных на индикаторы
.include "1200def.inc"

.cseg
.org 0

; Обработчик прерывания "RESET"
; Как правило, здесь выполняется инициализация программы, подготовка к работе, так сказать
reset:	
	ldi		r16,0xff
	out		DDRB,r16	; Порт для индикаторов
	out		DDRD,r16	; Порт для индикаторов

	ldi		r18,0x80	; Флаг направления
	
	ldi		r16,0x01
	out		PORTB,r16	; Начальное значение
	
	ldi		r17,0x80
	out		PORTD,r17	; Начальное значение

; Главный цикл
main:
	nop
	
	cpi		r18,0x80	; Проверка флага
	brne		case_2

	lsl		r16
	lsr		r17
	rjmp		check

case_2:
	lsl		r17
	lsr		r16

check:
	cpse		r16,r18	; Проверка завершения цикла отображения по направлению
	rjmp		ports
	
	cpi		r18,0x80
	breq		do_case_2
	ldi		r18,0x80	; Направление 1
	rjmp		ports
do_case_2:
	ldi		r18,0x01	; Направление 2

ports:
	out		PORTB,r16
	out		PORTD,r17
	rjmp		main
 
