mvi a, 0b4h
out 3
mvi a, 05h
out 3
xra a

:loop
out 1

:polling
in 2
ani 32
jz polling

in 0
inr a
jmp loop
