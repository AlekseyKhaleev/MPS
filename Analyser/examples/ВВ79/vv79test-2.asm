const reset       11000011b
const cscan2      00001000b
const writechar   10010000b
const pdata       0
const pcmd        1

org 0h
jmp initialize

:initialize
mvi a, reset
out pcmd
mvi a, cscan2
out pcmd
mvi a, writechar
out pcmd

lxi h, character_table

:loop
mov a, m
out pdata
inr l
mvi a, table_end
cmp l
jnz loop
mvi l, character_table
jmp loop

:character_table
   
   db 00111111b
   db 00000110b
   db 01011011b
   db 01001111b
   db 01100110b
   db 01101101b
   db 01111101b
   db 00000111b
   db 01111111b
   db 01101111b
   db 01110111b
   db 01111100b
   db 00111001b
   db 01011110b
   db 01111001b
   db 01110001b

:table_end
