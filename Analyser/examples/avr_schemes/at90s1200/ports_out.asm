; ����� ������ �� ����������
.include "1200def.inc"

.cseg
.org 0

; ���������� ���������� "RESET"
; ��� �������, ����� ����������� ������������� ���������, ���������� � ������, ��� �������
reset:	
	ldi		r16,0xff
	out		DDRB,r16	; ���� ��� �����������
	out		DDRD,r16	; ���� ��� �����������

	ldi		r18,0x80	; ���� �����������
	
	ldi		r16,0x01
	out		PORTB,r16	; ��������� ��������
	
	ldi		r17,0x80
	out		PORTD,r17	; ��������� ��������

; ������� ����
main:
	nop
	
	cpi		r18,0x80	; �������� �����
	brne		case_2

	lsl		r16
	lsr		r17
	rjmp		check

case_2:
	lsl		r17
	lsr		r16

check:
	cpse		r16,r18	; �������� ���������� ����� ����������� �� �����������
	rjmp		ports
	
	cpi		r18,0x80
	breq		do_case_2
	ldi		r18,0x80	; ����������� 1
	rjmp		ports
do_case_2:
	ldi		r18,0x01	; ����������� 2

ports:
	out		PORTB,r16
	out		PORTD,r17
	rjmp		main
 
