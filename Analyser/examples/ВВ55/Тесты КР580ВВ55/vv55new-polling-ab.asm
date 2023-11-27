mvi a, 0A7h
out 3
xra a

:loop
out 0

:polling
in 2
ani 2
jz polling

in 1
inr a
jmp loop
