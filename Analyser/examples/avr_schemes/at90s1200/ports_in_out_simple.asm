; ������ ��������� ���������� � ����������� �� �����������
.include "1200def.inc"

.cseg
.org 0

; ���������� ���������� "RESET"
; ��� �������, ����� ����������� ������������� ���������, ���������� � ������, ��� �������
reset:
	ldi		r16,0x00
	out		DDRD,r16	; ���� ��� ����������
	out		PORTD,r16
	out		PORTB,r16
	ldi		r17,0xff
	out		DDRB,r17	; ���� ��� �����������

; Main loop
main:
	in		r17,PIND	; ������ ��������� ����������
	cp		r17,r16		; �������� ���������
	breq	main
	mov		r16,r17
	out		PORTB,r17	; �����������
	rjmp	main

