; Include file with definitions for selected CPU
.include "m8def.inc"

; Code segment start
.cseg
.org 0

; Interrupt vectors table
	rjmp	reset

; Reset interrupt handler
reset:
	ldi		r16,high(RAMEND)
	out		SPH,r16
	ldi		r16,low(RAMEND)
	out		SPL,r16
	nop

; Main loop
main:
	nop
	rjmp	main
 