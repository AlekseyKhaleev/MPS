mvi a, 9h
out 3
mvi a, 0b4h
out 3
mvi a, 9h
out 3

:loop
in 2
jmp loop

mvi a, 5ah
lxi sp, 0FFFh
ei

:start
out 1
jmp start

skip 38h
:isr
in 0
inr a
mvi a, 0b4h
out 3
mvi a, 9h
out 3
in 0
inr a
ei
ret