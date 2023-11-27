; ������������ �������, ������������ �� �������� ���������
.include "1200def.inc"

; ������� ����
.cseg
.org 0

; ������� �������� ����������
	rjmp	reset
.org OVF0addr
    rjmp	tim0_ovf

; ���������� ���������� "RESET"
; ��� �������, ����� ����������� ������������� ���������, ���������� � ������, ��� �������
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

; ������� ����
main:
	rjmp	main

; ���������� ���������� �� ������������ �������
; ����� ����������� ����� ������ � ���� B �� ����������
tim0_ovf:
	in		r16,PORTB
	inc		r16
	out		PORTB,r16
	ldi		r16,0xfd
	out		TCNT0,r16
	reti
