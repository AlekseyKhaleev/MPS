:start
	mvi h,0  	 ;������������� � 0 ������� ������� ������ �� ����������
	lxi d,text  ;��������� � ������� d � e ������ ������
	mov l,e     ;��������� ������ ������
:metka2
	mvi a,len   ;��������:
	sub h       ;���� �� �������� �� ������� ����� ������ ������� �� ���
	mov c,a     ;������� ���������� ������ ���� ������ (������ ������� � �����)
	jc start    ;�� �������� ������� � �������
	inr h       ; ����������� �� ������� ������� ������� ������ �� ����������
	mvi c,08h   ;�������� � � ���������� ��������� �� �������
	mvi b,1b    ;� b ���������� ������ � �������� ����� �������� �����.
	mov e,l     ;������ � � ����� ������ ������ �� ������� (���������� ��� ����� ����������� �������� �� ������ ������)
	inr l       ;����������� ����� ������������ ������� �� 2
	inr l
:metka1
	mov a,b     ;�������� ������
	sta 8000h
	ldax d      ;���������� ��������� 8 ��� �������
	sta 8002h
	inr e
	ldax d      ;���������� ������ 8 ��� �������
	sta 8001h
	inr e
	mov a,b     ;������� ���������� b (� b � ��� ������������ ������) � ����� �� 1...
	rlc
	mov b,a
	dcr c       ;��������� C �� 1 (��� ������ ����� c = 8)
	jc metka2   ;���� � �� ����� 0 ������� ��������� ������
	jmp metka1  ;���� � ����� ���� (�� ��������� ���� �������) ���� � ������ ����� ����� ����� ������ ������ ������ ��� �����������
	text dw 0h,0h,0h,0h,0h,0h,0h,   2e08h,7600h, 6808h, 0e602h, 0ec00h, 6c02h, 6e00h,   0h,   0ef00h, 9d00h,   0h,    0d002h, 0fc02h, 0200h, 9c09h, 0c04h, 6008h, 0h,0h,0h,0h,0h,0h,0h,0h,0h			; ������� "       ������� �. �. 20-��         "
	const len 30;����� ������
