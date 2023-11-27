; ������ 2
; ���� ��������� ������� �� ���������� �������

; ������������ ���� ��� ���������������� AT90S2313
.include "2313def.inc"

; ������� ������
.dseg
h:	.byte 1	; ����
m:	.byte 1	; ������
s:	.byte 1	; �������

; ������� ����
.cseg

; ������ � 0-�� ������ ������� �������� ������������ ����������
.org 0				; ������ ���������� ������ ������ ��������� � ������ �������� �� 0-� ������
	rjmp		reset		; ����� �������� "reset", "tim0_ovf" ����� �����������
.org OVF1addr			
	rjmp		tim1_ovf	; ������ ���������� �� ������������ ������� 1
.org OVF0addr			
	rjmp		tim0_ovf	; ������ ���������� �� ������������ ������� 0

; �������������
reset:
; ��������� ��������� �����
	ldi		r16,low(RAMEND)
	out		SPL,r16

; ������������� ������ - ��� � ���� ����������
;
; ���� B
;------------
;
; ���� (������), ����������� ���������� ���������� ������������ �����������
;------------
; ��� PB0 (����� 0x01): i1 - ��������� 1 (������� �����)
; ��� PB1 (����� 0x02): i2 - ��������� 2 (������� �����)
; ��� PB2 (����� 0x04): i3 - ��������� 3 (������� �����)
; ��� PB3 (����� 0x08): i4 - ��������� 4 (������� �����)
; ��� PB4 (����� 0x10): i5 - ��������� 5 (������� ������)
; ��� PB5 (����� 0x20): i6 - ��������� 6 (������� ������)
;
; ���� 
;------------
; ��� PB6 (����� 0x40): k1
; ��� PB7 (����� 0x80): k2

	; ��������� ����� B
	;-------------------
	ldi		r16,0x3f	; ������ ������ - �����, ������ ����������� - ������
	out		DDRB,r16
;
; ���� D
;------------
;
; ���� D ������� ������������ �� ���������� ���������� ������������ �����������
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

	; ������� ���������� �������
	;----------------------------
	; ����� �������� � �������-���������� ����
	sts		h,r16
	sts		m,r16
	sts		s,r16

	; ��������� ������� 0
	;---------------------
	; ������ 0 ����� ��� ����������� �������������� ������ (��������)
	;  ��������� ������ - �� ������ ��.
	ldi		r16,0x02
	out		TCCR0,r16	; ����������� ������� ������� clk/1024
	clr		r16
	out		TCNT0,r16	; ������� �������� �������

	; ��������� ������� 1
	;---------------------
	; ������ 1 ����� ��� ����� �������, �, ������ �������, ��� ������������
	;  ������������ ������ �������� � 1 �������.
	; ���� �� �������� ���� �� ������� ������ ��������, �� ����� ������� � ����������
	ldi		r16,0x03
	out		TCCR1B,r16
	ldi		r16,0xff
	out		TCNT1H,r16
	ldi		r16,0x70
	out		TCNT1L,r16

	; ���������� ���������� �� ������������ �������� 1 � 0
	ldi		r16,0x82	; ��� 7 (����� 0x80) - ��� ������� 1, ��� 1 (����� 0x02) - ��� ������� 0
	out		TIMSK,r16

	; ���������� ���������� ����������
	sei

; ������� ������� ����
;----------------------
; ����� ���������� ������������ ������������ �����������
main:
	in		r16,PORTB
	lsl		r16
	andi		r16,0x3f
	cpi		r16,0x00
	brne		mM
	ldi		r16,0x01
mM:
	sbis		PORTB,0
	rjmp		m1
	; ��������� 1 ������� ������
m0:
	cbi		PORTB,0
	rcall		display
	sbi		PORTB,1
	rjmp		main
m1:
	sbis		PORTB,1
	rjmp		m2
	; ��������� 2 ������� ������
	cbi		PORTB,1
	rcall		display
	sbi		PORTB,2
	rjmp		main
m2:
	sbis		PORTB,2
	rjmp		m3
	; ��������� 2 ������� ������
	cbi		PORTB,2
	rcall		display
	sbi		PORTB,3
	rjmp		main
m3:
	sbis		PORTB,3
	rjmp		m4
	; ��������� 3 ������� ������
	cbi		PORTB,3
	rcall		display
	sbi		PORTB,4
	rjmp		main
m4:
	sbis		PORTB,4
	rjmp		m5
	; ��������� 4 ������� ������
	cbi		PORTB,4
	rcall		display
	sbi		PORTB,5
	rjmp		main
m5:
	sbis		PORTB,5
	rjmp		mR
	; ��������� 5 ������� ������
	cbi		PORTB,5
	rcall		display
	sbi		PORTB,0
	rjmp		main
mR:
; �������������� ��������, �������, � ��������, ���� �� �����
; ��, �� ������ ������, ����� ��������� ������ ����� �����, � ����
	rjmp		m0

	rjmp		main		; ������� � ������ �������� �������� �����

; ���������� ���������� �� ������������ ������� 1
;-------------------------------------------------
; ����� ���������� ������� �������
tim1_ovf:
; �������� ������
	lds		r23,s
; ��������� ������ ������
	inc		r23
; �������� �� ���������� �� 10 ������
	mov		r31,r23
	andi		r31,0x0f
	cpi		r31,0x0a
	brne		tim_s		; �� ����������
	rjmp		tim_ss	; ����������
tim_s:
; ���������� ������ � �����
	sts		s,r23
	rjmp		tim_end
tim_ss:
; ��������� �������� ������
	andi		r23,0xf0
	ldi		r31,0x10
	add		r23,r31
; �������� �� ���������� �� 60 ������
	cpi		r23,0x60
	brlo		tim_s		; �� ����������
; ����������
; ��������� � ���������� ������
	clr		r23
	sts		s,r23
; �������� �����
	lds		r23,m
; ��������� ������ �����
	inc		r23
; �������� �� ���������� �� 10 �����
	mov		r31,r23
	andi		r31,0x0f
	cpi		r31,0x0a
	brne		tim_m		; �� ����������
	rjmp		tim_mm	; ����������
tim_m:
; ���������� ����� � �����
	sts		m,r23
	rjmp		tim_end
tim_mm:
; ��������� �������� �����
	andi		r23,0xf0
	ldi		r31,0x10
	add		r23,r31
; �������� �� ���������� �� 60 �����
	cpi		r23,0x60
	brlo		tim_m		; �� ����������
; ����������
; ��������� � ���������� �����
	clr		r23
	sts		m,r23
; �������� �����
	lds		r23,h
; ��������� ������ �����
	inc		r23
; �������� �� ���������� �� 10 �����
	mov		r31,r23
	andi		r31,0x0f
	cpi		r31,0x0a
	brne		tim_h		; �� ����������
	rjmp		tim_hh	; ����������
tim_h:
; ���������� ����� � �����
	sts		h,r23
	rjmp		tim_end
tim_hh:
; ��������� �������� �����
	andi		r23,0xf0
	ldi		r31,0x10
	add		r23,r31
; �������� �� ���������� �� 24 ����
	cpi		r23,0x24
	brlo		tim_h		; �� ����������
; ����������
; ��������� � ���������� �����
	clr		r23
	sts		h,r23
tim_end:
; �������������� ����������������� ��������
; ��� �������, ���������� ������� �� ������� 1 ��
	ldi		r31,0xff
	out		TCNT1H,r31
	ldi		r31,0x70
	out		TCNT1L,r31
	reti

; ���������� ���������� �� ������������ ������� 0
;-------------------------------------------------
; ����� ���������� ����� (��������) ��������� ������, ������ ������, �������
;  �� �� ������� (���������� 1 ��� ���������� 0)
tim0_ovf:
; �������� ������� ������ 1
	sbic		PINB,6	; �������� ������� 1
	rjmp		key_pin6_set
; ������ 1 ������
; ��������� �����
	lds		r19,h
	inc		r19
	cpi		r19,0x24
	brne		save_h
	clr		r19
save_h:
	sts		h,r19
key_pin6_set:
; �������� ������� ������ 2
	sbic		PINB,7	; �������� ������� 2
	rjmp		key_pin7_set
; ������ 2 ������
; ��������� �����
	lds		r19,m
	inc		r19
	cpi		r19,0x60
	brne		save_m
	clr		r19
save_m:
	sts		m,r19
key_pin7_set:
	reti

; ������ � ���� D ������ - ��������� ��������������� ����� ���������� ���������
display:
; ����������� ����� ��������� ������ ��� �����������
; ���� ��� - ��������� ������� "switch" � ����� ��
	cpi		r16,0x01
	brne		display_next1
	; ������� �����
	lds		r17,h
	swap		r17
	rjmp		decoder
display_next1:
	cpi		r16,0x02
	brne		display_next2
	; ������� �����
	lds		r17,h
	rjmp		decoder
display_next2:
	cpi		r16,0x04
	brne		display_next3
	; ������� �����
	lds		r17,m
	swap		r17
	rjmp		decoder
display_next3:
	cpi		r16,0x08
	brne		display_next4
	; ������� �����
	lds		r17,m
	rjmp		decoder
display_next4:
	cpi		r16,0x10
	brne		display_next5
	; ������� ������
	lds		r17,s
	swap		r17
	rjmp		decoder
display_next5:
	; ������� ������
	lds		r17,s

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
 
