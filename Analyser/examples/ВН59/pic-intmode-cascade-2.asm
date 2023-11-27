; Проверка контроллера прерываний ВН59
; Каскадный вариант с двумя ведомыми контроллерами (на линиях IRQ6 и IRQ7)
; Обработчики прерываний просто выдают свой номер на индикатор
; Обработчик IRQ0 выдает FFh
; Обработчик IRQ31 выполняется довольно долго,
; он показывает числа от 0 до 20 на большом индикаторе
; IRQ1, IRQ3, IRQ5 замаскированы

const ind_address  010000000000000b
const pic_address0 100000000000000b
const pic_address1 100000000000001b
const off_address  110000000000000b
const off_address1 110000000000001b
const slave1_addr0 110000000000010b
const slave1_addr1 110000000000011b
const slave2_addr0 110000000000100b
const slave2_addr1 110000000000101b

lxi sp, 1000h
lxi h, pic_address0
mvi m, 00010100b

lxi h, pic_address1
mvi m, 01h
mvi m, 11000000b
mvi m, 11010101b

lxi h, pic_address0
mvi m, 11000100b

lxi h, slave1_addr0
mvi m, 00010100b

lxi h, slave1_addr1
mvi m, 02h
mvi m, 06h
mvi m, 11111111b

lxi h, slave2_addr0
mvi m, 00010100b

lxi h, slave2_addr1
mvi m, 03h
mvi m, 07h
mvi m, 11111111b

;hlt
ei

:wait_for_interrupts
jmp wait_for_interrupts

skip 100h
jmp handler0
skip 104h
jmp handler1
skip 108h
jmp handler2
skip 10Ch
jmp handler3
skip 110h
jmp handler4
skip 114h
jmp handler5
skip 118h
jmp handler6
skip 11Ch
jmp handler7

:handler0
push psw
push h
lda pic_address1
sta ind_address
mvi a, 00001011b
sta pic_address0
lda pic_address0
sta off_address
mvi a, 00001010b
sta pic_address0
lda pic_address0
sta off_address1
jmp handler_cleanup

:handler1
push psw
push h
mvi a, 01h
sta ind_address
jmp handler_cleanup

:handler2
push psw
push h
mvi a, 02h
sta ind_address
jmp handler_cleanup

:handler3
push psw
push h
mvi a, 03h
sta ind_address
jmp handler_cleanup

:handler4
push psw
push h
mvi a, 04h
sta ind_address
jmp handler_cleanup

:handler5
push psw
push h
mvi a, 05h
sta ind_address
jmp handler_cleanup

:handler6
push psw
push h
mvi a, 06h
sta ind_address
jmp handler_cleanup

:handler7
push psw
push h
mvi a, 07h
sta ind_address
jmp handler_cleanup

:handler_cleanup
lxi h, pic_address0
;mvi m, 00100000b
mvi m, 10100000b  ; автоцикл
pop h
pop psw
ei
ret

skip 0200h
:handler_irq21
push psw
push h
mvi a, 21h
sta ind_address
lxi h, slave1_addr0
mvi m, 10100000b 
lxi h, pic_address0
mvi m, 10100000b 
pop h
pop psw
ei
ret

skip 0300h
:handler_irq31
push psw
push h
mvi a, 07h
sta ind_address

lxi h, off_address
xra a
:handler7_loop
ei 
mov m, a
cpi 0FFh
jz handler7_cleanup
inr a
jmp handler7_loop
:handler7_cleanup
lxi h, slave2_addr0
mvi m, 10100000b 
lxi h, pic_address0
mvi m, 10100000b 
pop h
pop psw
ei
ret

