; ������ 3
; ���������� ������� ����������

; ������������ ���� ��� ���������������� ATmega8
.include "m8def.inc"

; ������� ����
.cseg

; ������ � 0-�� ������ ������� �������� ������������ ����������
.org 0				; ������ ���������� ������ ������ ��������� � ������ �������� �� 0-� ������
	rjmp		reset		; ����� �������� "reset", "tim0_ovf" ����� �����������
.org OVF0addr			
	rjmp		tim0_ovf	; ������ ���������� �� ������������ ������� 0
.org ADCCaddr
	rjmp		adc_complete; ������ ���������� �� ���������� ���

; �������������
reset:
; ��������� ��������� �����
	ldi		r16,low(RAMEND)
	out		SPL,r16
	ldi		r16,high(RAMEND)
	out		SPH,r16

; ������������� ������ - ��� � ���� ����������
;
; ���� B
;------------
;
; ����������� �������� ���������
;--------------------------------
; ��� PB0 (����� 0x01): m1
; ��� PB1 (����� 0x02): m2
; ��� PB2 (����� 0x04): m3
; ��� PB3 (����� 0x08): m4
;
	; ��������� ����� B
	;-------------------
	ldi		r16,0x0f
	out		DDRB,r16
	ldi		r16,0x01
	out		PORTB,r16
;
; ���� C
;--------
;
; ��� PC0 (����� 0x01): temp - ���������� ������������� ������
;
; ���������� ������������� ������������
;---------------------------------------
; ��� PC1 (����� 0x02): i1 - ��������� 1 (������� ��������)
; ��� PC2 (����� 0x04): i2 - ��������� 2 (������� ��������)
; ��� PC3 (����� 0x08): i3 - ��������� 3 (������ �������)
; ��� PC4 (����� 0x10): i4 - ��������� 4 (������ �������)
; ��� PC5 (����� 0x20): led - ��������� ��������� �������� ���������
	; ��������� ����� �
	ldi		r16,0x3e
	out		DDRC,r16
	clr		r16
	out		PORTC,r16
;
; ���� D
;------------
;
; ���� D ������������ �� ���������� ���������� ������������ �����������
;------------
; ��� PD0 (����� 0x01): a
; ��� PD1 (����� 0x02): b
; ��� PD2 (����� 0x04): c
; ��� PD3 (����� 0x08): d
; ��� PD4 (����� 0x10): e
; ��� PD5 (����� 0x20): f
; ��� PD6 (����� 0x40): g
;
	; ��������� ����� D
	;-------------------
	ldi		r16,0x7f
	out		DDRD,r16
	clr		r16
	out		PORTD,r16

	; ������� ��� �������� ����������� �������� �����������
	clr		r18

	; ��������� ������� 0
	;---------------------
	; ������ 0 ����� ��� ���������� ������� ����������
	ldi		r16,0x01
	out		TCCR0,r16	; ����������� ������� ������� clk/1
	clr		r16
	out		TCNT0,r16	; ������� �������� �������

	; ��������� ���
	ldi		r16,0x40	; ����� ������ PC0 ��� ��������������,
					;  ����� �������� �������� ���������� (� �����
					;  � ������ AREF ���������������� ���������
					;  �������� ����������� ���������� 3� 
	out		ADMUX,r16
	ldi		r16,0xef	; ��������� ���, ��������� ������ ������������ ��������������,
					;  ���������� ���������� �� ���������� ��������������,
					;  ��������� ������������ ������� ��������� ������� clk/2
	out		ADCSRA,r16

	; ���������� ���������� ����������
	sei

; ������� ������� ����
;----------------------
; ����� ���������� ������������ ������������ �����������
main:
	in		r16,PORTC
	andi		r16,0x1e
	lsl		r16
	andi		r16,0x1e
	cpi		r16,0x00
	brne		mM
	ldi		r16,0x02
mM:
	sbis		PORTC,1
	rjmp		m1
	; ��������� 1 ������� ������
m0:
	cbi		PORTC,1
	rcall		display
	sbi		PORTC,2
	rjmp		main
m1:
	sbis		PORTC,2
	rjmp		m2
	; ��������� 2 ������� ������
	cbi		PORTC,2
	rcall		display
	sbi		PORTC,3
	rjmp		main
m2:
	sbis		PORTC,3
	rjmp		m3
	; ��������� 2 ������� ������
	cbi		PORTC,3
	rcall		display
	sbi		PORTC,4
	rjmp		main
m3:
	sbis		PORTC,4
	rjmp		mR
	; ��������� 3 ������� ������
	cbi		PORTC,4
	rcall		display
	sbi		PORTC,1
	rjmp		main
mR:
; �������������� ��������, �������, � ��������, ���� �� �����
; ��, �� ������ ������, ����� ��������� ������ ����� �����, � ����
	rjmp		m0

	rjmp		main		; ������� � ������ �������� �������� �����

; ���������� ���������� �� ������������ ������� 0
;-------------------------------------------------
; ���������� ������� ����������
tim0_ovf:
	in		r22,PORTB
	lsl		r22
	andi		r22,0x0f
	cpi		r22,0x00
	brne		tim0_end
	ldi		r22,0x01
tim0_end:
	out		PORTB,r22
; �������������� ����������������� ��������
	clr		r22
	out		TCNT0,r22
	reti

; ���������� ���������� �� ���������� ���
;-----------------------------------------
; ��������������� ���������� ��� � ������� �� �������
;  � ���������� ��������/��������� �������� ���������
; ��� ����������� ����� 23-� �������� ������� ��������� ����������
; ��� ����������� ������ ��� ������ 23-� �������� ������� ��������� �����������
adc_complete:
	in		r30,ADCL
	clr		r19
adc_to_degree:
	subi		r30,6
	brlo		adc_motor_control
	inc		r19
	rjmp		adc_to_degree
adc_motor_control:
	cpi		r19,24
	brlo		adc_motor_turn_off
	ldi		r30,0x01
	out		TIMSK,r30
	sbi		PORTC,5
	rjmp		adc_decode
adc_motor_turn_off:
	clr		r30
	out		TIMSK,r30
	cbi		PORTC,5
adc_decode:
	rcall		bin2bcd
	reti

; ������ � ���� D ������ - ��������� ��������������� ����� ���������� ���������
display:
; ����������� ����� ��������� ������ ��� �����������
; ���� ��� - ��������� ������� "switch" � ����� ��
	cpi		r16,0x02
	brne		display_next1
	; ������� ��������
	mov		r17,r18
	swap		r17
	rjmp		decoder
display_next1:
	cpi		r16,0x04
	brne		display_next2
	; ������� ��������
	mov		r17,r18
	rjmp		decoder
display_next2:
	cpi		r16,0x08
	brne		display_next3
	; ������ �������
	ldi		r17,0x63
	rjmp		display_end
display_next3:
	;cpi		r16,0x10
	;brne		display_next4
	; ������ �������
	ldi		r17,0x39
	rjmp		display_end

; ��� ����� ������� "display"
; �������� �� ������������� ����� ��� ������ �� �������
decoder:
	andi		r17,0x0f
; ���� ��� ���� ���������� ���������� "switch" � ����� ��
	cpi		r17,0
	brne		decoder_next1
	ldi		r17,0x3f
	rjmp		display_end
decoder_next1:
	cpi		r17,1
	brne		decoder_next2
	ldi		r17,0x06
	rjmp		display_end
decoder_next2:
	cpi		r17,2
	brne		decoder_next3
	ldi		r17,0x5b
	rjmp		display_end
decoder_next3:
	cpi		r17,3
	brne		decoder_next4
	ldi		r17,0x4f
	rjmp		display_end
decoder_next4:
	cpi		r17,4
	brne		decoder_next5
	ldi		r17,0x66
	rjmp		display_end
decoder_next5:
	cpi		r17,5
	brne		decoder_next6
	ldi		r17,0x6d
	rjmp		display_end
decoder_next6:
	cpi		r17,6
	brne		decoder_next7
	ldi		r17,0x7d
	rjmp		display_end
decoder_next7:
	cpi		r17,7
	brne		decoder_next8
	rjmp		display_end
decoder_next8:
	cpi		r17,8
	brne		decoder_next9
	ldi		r17,0x7f
	rjmp		display_end
decoder_next9:
	ldi		r17,0x6f
display_end:
	out		PORTD,r17	; ����� ���������� ������������� � ���� D
	ret

; �������������� ��������� ����� � �������-����������
bin2bcd:
	clr		r20
	; �������� ���������� �������� (>99)
	cpi		r19,100
	brlo		b2b_normal
	ldi		r18,0x99
	rjmp		b2b_end
b2b_normal:
	cpi		r19,10
	brlo		b2b_1
	subi		r19,10
	inc		r20
	rjmp		b2b_normal
b2b_1:
	swap		r20
	or		r19,r20
	mov		r18,r19
b2b_end:
	ret
 





