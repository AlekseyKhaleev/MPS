const alu_accl  0
const alu_acch  1
const alu_rg1l  2
const alu_rg1h  3
const alu_rg2l  4
const alu_rg2h  5
const alu_cmd   6
const alu_ecmd  7

mvi a, 0FFh
out alu_accl
mvi a, 00010000b
out alu_ecmd
mvi a, 01h
out alu_rg1l
mvi a, 00010001b
out alu_cmd

in  alu_accl
in  alu_acch

mvi a, 0FFh
out alu_rg2l
mvi a, 01h
out alu_rg2h
mvi a, 00010010b
out alu_cmd

in  alu_accl
in  alu_acch

mvi a, 01h
out alu_rg1l
out alu_rg1h

mvi a, 02h
out alu_rg2l
xra a
out alu_rg2h

mvi a, 01000110b
out alu_cmd

in  alu_accl
in  alu_acch

in  alu_rg1l
in  alu_rg1h

