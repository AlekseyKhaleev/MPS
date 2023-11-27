.include "1200def.inc"

.cseg
.org 0

	rjmp	reset

reset:
	nop
	ldi	r16,0x10
	out	DDRB,r16

main:
	nop
	rjmp	main