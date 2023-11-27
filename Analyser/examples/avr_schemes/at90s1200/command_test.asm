.include "2313def.inc"

.cseg
.org 0
	rjmp	reset
reset:
	ldi	r16,low(RAMEND)
	out	SPL,r16
	;ldi	r16,high(RAMEND)
	;out	SPH,r16
	ldi	r16,0xab
	push	r16
	push	r16
	push	r16
	push	r16
	push	r16
	pop	r17
	pop	r18
	pop	r19
	pop	r20
	pop	r21
main:
	rjmp	main
 