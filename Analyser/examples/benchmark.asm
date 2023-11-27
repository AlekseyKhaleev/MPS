const indicator_reg 8001h
const break_reg     8002h

xra a
lxi h, indicator_reg

:repeat
mov m, a
inr a

mvi c, 0fh
:repeat_inner
dcr c
jnz repeat_inner

cpi 0FFh
jnz repeat

sta break_reg