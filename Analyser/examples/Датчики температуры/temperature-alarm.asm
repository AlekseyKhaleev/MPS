const adc_addr      8000h
const ind_addr      8001h
const alarm_addr    8002h
const alarm_counter 5h

lxi sp, 1000h
lxi hl, 01FFh
sta adc_addr
ei

:eternity
hlt
jmp eternity

skip 38h

:isr

lda adc_addr
mov d, a
call convert_to_bcd
sta ind_addr
mov a, d
sta adc_addr

cpi 70
jm normal

dcr h
jnz exit
mov a, l
sta alarm_addr
xri 1
mov l, a
mvi h, alarm_counter
jmp exit

:normal
mvi a, 00h
lxi hl, 01FFh
sta alarm_addr

:exit
ei
ret

; Преобразование двоичного числа в BCD
; Исходное число в A
; Результат также помещается в A
:convert_to_bcd

mvi b, 0

:loop
cpi 10
jm end_of_division
sui 10
inr b
jmp loop

:end_of_division
mov c, a
mov a, b
rlc
rlc
rlc
rlc

ora c
ret