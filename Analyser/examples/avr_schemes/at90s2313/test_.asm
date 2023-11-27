.include "2313def.inc"

.cseg
.org 0

reset:
	ldi	r16,0x12
	sts	0x32,r16
	lds	r17,0x32
main:
	rjmp	main
 