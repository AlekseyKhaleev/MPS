; �������� ����������� ���������� ��59
; ��� ��������������, ����� ����������
; ����������� ���������� ������ ������ ���� ����� �� ���������
; ���������� IRQ0 ������ FFh
; ���������� IRQ7 ����������� �������� �����,
; �� ���������� ����� �� 0 �� 20 �� ������� ����������
; ������������ �������� ��� ���������� ����������
; IRQ7 �������� � ������ ����������� �����
; IRQ1, IRQ3, IRQ5 �������������

const ind_address  010000000000000b
const pic_address0 100000000000000b
const pic_address1 100000000000001b
const off_address  110000000000000b
const off_address1 110000000000001b

lxi sp, 1000h
lxi h, pic_address0
mvi m, 00010110b
mvi m, 01h

lxi h, pic_address1
mvi m, 11010101b

lxi h, pic_address0
mvi m, 11000100b

ei

:wait_for_interrupts
jmp wait_for_interrupts

skip 100h
jmp handler0
skip 104h
jmp handler1
skip 108h
jmp handler2
skip 10Ch
jmp handler3
skip 110h
jmp handler4
skip 114h
jmp handler5
skip 118h
jmp handler6
skip 11Ch
jmp handler7

:handler0
push psw
push h
lda pic_address1
sta ind_address
mvi a, 00001011b
sta pic_address0
lda pic_address0
sta off_address
mvi a, 00001010b
sta pic_address0
lda pic_address0
sta off_address1
jmp handler_cleanup

:handler1
push psw
push h
mvi a, 01h
sta ind_address
jmp handler_cleanup

:handler2
push psw
push h
mvi a, 02h
sta ind_address
jmp handler_cleanup

:handler3
push psw
push h
mvi a, 03h
sta ind_address
jmp handler_cleanup

:handler4
push psw
push h
mvi a, 04h
sta ind_address
jmp handler_cleanup

:handler5
push psw
push h
mvi a, 05h
sta ind_address
jmp handler_cleanup

:handler6
push psw
push h
mvi a, 06h
sta ind_address
jmp handler_cleanup

:handler7
push psw
push h
mvi a, 07h
sta ind_address

mvi a, 01101000b    ; ��������� ����������� �����
sta pic_address0

lxi h, off_address
xra a

ei
:handler7_loop
mov m, a
cpi 0FFh
jz handler_cleanup
inr a
jmp handler7_loop

:handler_cleanup
lxi h, pic_address0
;mvi m, 00100000b

mvi a, 01000000b  ; ����� ����������� �����
sta pic_address0

mvi m, 10100000b  ; ��������
pop h
pop psw
ei
ret