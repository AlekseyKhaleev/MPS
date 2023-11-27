; org 100h

:start
jmp begin

const c1 0FFFFh
const port 0AAh

db 0ffh
test 	db 1h, 2h, 3h, 10o, 1010b, 'this is a test', 10
test2 	dw test, c1

hl1     dw test_proc
hl2     dw

hl3     dw 01000h

label begin

stc

mov a, h ; comment
;stax bc
ldax d
mov a, b
mov a, c
mov a, d
mov a, e
mov a, h
mov a, l
mov b, c
mov h, m
mov l, m

mvi a, 0AAh
mvi b, 0BBh
mvi c, 0CCh
mvi D, 0DDh
mvi E, 0EEh
mvi h, 011h
mvi l, 022h
mvi m, 00h

lhld hl1
pchl

:return
shld hl2

lxi hl, 1000h
lxi de, 2000h
lxi bc, 3000h
sphl
xchg
xchg
xthl
xthl

push b
push d
push h
push psw
pop psw
pop h
pop d
pop b

inr a
inr b
inr c
inr d
inr e
inr h
inr l
inr m

dcr a
dcr b
dcr c
dcr d
dcr e
dcr h
dcr l
dcr m

cma 
cmc 
daa

rlc
rrc
ral
rar

in 00h
in port
out port

add a
add h

adc m
adc l

sub c
sub d

sbb a
sbb b

ana c
ana m

xra a

ora b

cmp c

jz next1
:next1
jnz next2
:next2
jc next3
:next3
jnc next4
:next4
jp next5
:next5
jm next6
:next6
jpe next7
:next7
jpo next8
:next8

call dummy_proc
cz   dummy_proc
cnz  dummy_proc
cc   dummy_proc
cnc  dummy_proc
cp   dummy_proc
cm   dummy_proc
cpe  dummy_proc
cpo  dummy_proc

call test_rz
call test_rnz
call test_rc
call test_rnc
call test_rp
call test_rm
call test_rpe
call test_rpo

dad  b
dad  de
dad  sp
dad  h

inx  h
inx  bc
inx  d
inx  sp

dcx  sp
dcx  de
dcx  bc
dcx  hl

jmp start

area dr 5, 10h
     dr 0FFh, 0FFh

label dummy_proc
ret

label test_rz
rz
ret

label test_rnz
rnz
ret

label test_rc
rc
ret

label test_rnc
rnc
ret

label test_rp
rp
ret

label test_rm
rm
ret

label test_rpe
rpe
ret

label test_rpo
rpo
ret

label test_proc
cma
jmp return