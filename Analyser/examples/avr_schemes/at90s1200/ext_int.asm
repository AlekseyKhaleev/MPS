; ������������ ������ �������� ����������
.include "1200def.inc"	; ��������� �� ��������������� at90s1200

.cseg
.org 0
	rjmp	reset
	rjmp	ext_int		; ������ �������� ����������

; ���������� ���������� "RESET"
; ��� �������, ����� ����������� ������������� ���������, ���������� � ������, ��� �������
reset:	
	ldi		r16,0xff	; ��������� ������
	out		DDRB,r16
	ldi		r16,0x01
	out		DDRD,r16

	ldi		r16,0x00
	out		PORTB,r16
	
	ldi		r16,0x00
	out		PORTD,r16
	
    ldi		r16,0x00	; ��������� �������� ����������: ���������� ��������� ��� ������������ ������ �������
	out		MCUCR,r16
	ldi		r16,0x40	; ���������� �������� ����������
    out		GIMSK,r16

    clr		r16
    
    sei					; ���������� ����������

; ������� ����
; ����� ���������� ������ �������� ������������� �������� ����������
main:
	nop
	rjmp	main

; ���������� �������� ����������
; ������� ����� � ���� B ������������������� �������� �������� r16
ext_int:
	inc		r16
	out		PORTB,r16
    reti
 
