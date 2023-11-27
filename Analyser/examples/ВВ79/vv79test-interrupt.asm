const cw_reset       11000011b    ; ������� ������ ��79
const cw_coded_scans 00000110b    ; ������� ������ ������� ������ ������
const cw_write_aincr 10010000b    ; ������� ������ � ��� �����������
                                  ; � ���������������
const mask_one       00000110b    ; ����� ������� ������� (8-����������)
const mask_zero      00111111b    ; ����� ������� ���� (8-����������)
const port_data      0            ; ���� �����/������ ������
const port_cmd       1            ; ���� ������ ������/����� ���������

org 0h                           
jmp initialize                    ; ����� �����. ������������� ����

skip 38h                          ; ISR ������ ������������� �� ����� ������

:isr                              
in port_cmd                       ; ������ ����� ���������
ani 0Fh                           ; ���� ����� � ������� ?
jz exit_isr                       ; ���� ���, ������� �� ISR
in port_data                      ; ���� ����� ������ � A
call show_bit_mask                ; ����� �� ���������� 
jmp isr                           ; ���������, ���� ���� �������

:exit_isr                         ; ����� � ����������� ����������
ei
ret

:initialize                       ; �������������
mvi a, cw_reset                   ; ����������� �����
out port_cmd
mvi a, cw_coded_scans             ; ������������ ������������ �������
out port_cmd                      ; � ���� �� ������
ei

:forever                          ; ������ ����
jmp forever                       ; ����� ����� ����������� ����������

:show_bit_mask                    ; ������������ ������������ ������

mov b, a                          ; ������� ������� ������ � ���
mvi a, cw_write_aincr             ; ����������� � ���������������
out port_cmd
mvi c, 8                          ; ����� 8 �������� � ����� ;)
mov a, b

:repeat
ral                               ; ������� ������������ ����� 
mov b, a                          ; �������� A � B
jnc show_zero                     ; ���� ������� ������ - ����...
mvi a, mask_one                   ; ����� ��������� ����� �������
jmp do_show

:show_zero
mvi a, mask_zero                  ; ��������� ����� ����

:do_show                          ; ������� ������� �����
out port_data
mov a, b
dcr c                             ; � ��������� � ��������� ��������
jnz repeat

ret