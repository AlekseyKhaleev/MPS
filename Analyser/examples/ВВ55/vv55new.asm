mvi a, 0b4h
out 3
xra a
lxi sp, 0FFFh

:start
out 1
xra a
in  0
inr a
mov b, a
in  2
mov a, b
jmp start