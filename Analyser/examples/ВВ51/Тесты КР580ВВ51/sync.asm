const i8251_control_reg 01h
const i8251_data_reg    00h

lxi sp, 1000h

mvi a, 10111100b
out i8251_control_reg

mvi a, 10101011b
out i8251_control_reg

mvi a, 10010101b
out i8251_control_reg

mov a, c
out i8251_data_reg

mvi c, 10h
:long_wait
nop
nop
nop
nop
dcr c 
jnz long_wait

:transmit
mvi c, 0

:loop
mov a, c
out i8251_data_reg

:poll
in i8251_control_reg
ani 02h
jz poll

in i8251_data_reg
mov d, a
inr c
jmp loop

