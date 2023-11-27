; Чтение состояния клавиатуры и отображение на индикаторах
.include "1200def.inc"

.cseg
.org 0

; Обработчик прерывания "RESET"
; Как правило, здесь выполняется инициализация программы, подготовка к работе, так сказать
reset:
	ldi		r16,0x00
	out		DDRD,r16	; Порт для клавиатуры
	out		PORTD,r16
	out		PORTB,r16
	ldi		r17,0xff
	out		DDRB,r17	; Порт для индикаторов

; Main loop
main:
	in		r17,PIND	; Чтение состояния клавиатуры
	cp		r17,r16		; Проверка изменений
	breq	main
	mov		r16,r17
	out		PORTB,r17	; Отображение
	rjmp	main

