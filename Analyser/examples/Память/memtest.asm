; Äëÿ memtest.sch

org 0h

const start_address    2000h
const increment        2Dh
const max_address_msb  40h

:start
xra   a
out   0h
lxi   h, start_address

:loop
xra   a

:inner
mov   m, a
cmp   m
jnz   error

adi   increment
jnc   inner

inx   h
mov   a, l
out   00h
mov   a, h
cpi   max_address_msb

jnz   loop
jmp   start

:error
dcr   a
out   00h
jmp   error