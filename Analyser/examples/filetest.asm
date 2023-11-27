; filetest.asm

const ind_address  010000000000000b
const file_address 100000000000000b
const off_address  110000000000000b

lxi hl, 0

:loop
shld off_address
lda  file_address
sta  ind_address
inx  hl
jmp  loop