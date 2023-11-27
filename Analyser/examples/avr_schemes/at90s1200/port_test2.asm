; Include file with definitions for selected CPU
.include "1200def.inc"

; Code segment start
.cseg
.org 0

	ldi		r16,0x01
	out		DDRD,r16
	ldi		r16,0x00
	out		PORTD,r16

main:
	rjmp	main