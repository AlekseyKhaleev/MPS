// ������������ ����������� �����������
.include "1200def.inc"

.cseg

.org 0
	rjmp	reset
.org ACIaddr
	rjmp	ana_comp

; �������������
reset:
	nop
	ldi		r16,0x04
	out		DDRB,r16
	ldi		r16,0x08
	out		ACSR,r16
	sei

; ������� ����
main:
	nop
	rjmp	main

; ���������� ���������� ����������� �����������
ana_comp:
	clr		r16
	sbic	ACSR,5
	ori		r16,0x04
	out		PORTB,r16
	reti
