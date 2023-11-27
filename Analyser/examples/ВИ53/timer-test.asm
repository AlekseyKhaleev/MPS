; filetest.asm

const timer_gates  010000000000000b
const timer1_addr0 100000000000000b
const timer1_addr1 100000000000001b
const timer1_addr2 100000000000010b
const timer1_addr3 100000000000011b
const timer2_addr0 110000000000000b
const timer2_addr1 110000000000001b
const timer2_addr2 110000000000010b
const timer2_addr3 110000000000011b

const timer_value 05h

mvi a, 00110000b
sta timer1_addr3
mvi a, 01110010b
sta timer1_addr3
mvi a, 10110100b
sta timer1_addr3

mvi a, 00110110b
sta timer2_addr3
mvi a, 01111000b
sta timer2_addr3
mvi a, 10111010b
sta timer2_addr3

lxi h, timer1_addr0
mvi m, timer_value
mvi m, 0

lxi h, timer1_addr1
mvi m, timer_value
mvi m, 0

lxi h, timer1_addr2
mvi m, timer_value
mvi m, 0

lxi h, timer2_addr0
mvi m, timer_value
mvi m, 0

lxi h, timer2_addr1
mvi m, timer_value
mvi m, 0

lxi h, timer2_addr2
mvi m, timer_value
mvi m, 0

mvi a, 0FFh
sta timer_gates

lxi h, timer1_addr0
:eternity
mov a, m
mov a, m
jmp eternity