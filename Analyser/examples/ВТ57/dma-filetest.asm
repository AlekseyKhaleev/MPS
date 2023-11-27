; filetest.asm
; ������ � ������������ ��� (DMAC)

; ����� ���������� 
const ind_addr    010000000000000b

; ������ ��������� DMAC 
const dmac_addr0  110000000000000b
const dmac_ctr0   110000000000001b
const dmac_addr1  110000000000010b
const dmac_ctr1   110000000000011b

; ����� ������������ �������� DMAC
const dmac_ctl    110000000001000b

:try_dma_again

lxi h, dmac_addr0     ; �������� ���������� ������ ������
mvi m, 00h            ; ��� ������ ������ �� DMA (0100h)
mvi m, 01h
lxi h, dmac_ctr0      ; �������� ����� ������
mvi m, 000h           ; 
mvi m, 10000011b      ; ����� ������ � ������ 
                      ; (�������� ��������, ��� ��������� DMAC)
                      ; �� ����� ���� ��� ����� ������, �� �� ��
lxi h, dmac_addr1
mvi m, 00h
mvi m, 01h
lxi h, dmac_ctr1
mvi m, 000h
mvi m, 01000011b

lxi h, dmac_ctl

mvi m, 01010001b      ; ��-����, ����������� ���������, �������� DRQ0

:poll_for_dma0_finish
mov a, m
ani 0Fh
jz poll_for_dma0_finish

mvi m, 01010010b

:poll_for_dma1_finish
mov a, m
ani 0Fh
jz poll_for_dma1_finish

hlt

skip 100h
:dma_receive_buffer