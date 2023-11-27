;**********************************************************************
;                                                                     *
;   This file is a code example showing the work of PIC16F84A.        *
;   The Timer0 functionality and interrupts handling are in focus     *
;   Recomended clock frequency: 10 kHz                                *
;                                                                     *
;   Refer to the MPASM User's Guide for additional information on     *
;   features of the assembler (Document DS33014).                     *
;                                                                     *
;   Refer to the respective PIC data sheet for additional             *
;   information on the instruction set.                               *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Filename:        ctrl_blink_led.asm                              *
;    Date:            2009                                            *
;    File Version:                                                    *
;                                                                     *
;    Author:          Sergei Loschilov                                *
;    Company:         N. Novgorod State Technical University          *
;                                                                     *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Files required: P16F84A.INC                                      *
;                                                                     *
;                                                                     *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Notes:                                                           *
;                                                                     *
;                                                                     *
;                                                                     *
;                                                                     *
;**********************************************************************


    list      p=16F84A             ; list directive to define processor
    #include <p16F84a.inc>         ; processor specific variable definitions

    __CONFIG   _CP_OFF & _WDT_OFF & _PWRTE_ON & _RC_OSC

; '__CONFIG' directive is used to embed configuration data within .asm file.
; The lables following the directive are located in the respective .inc file.
; See respective data sheet for additional information on configuration word.

;***** VARIABLE DEFINITIONS
w_temp        EQU     0x0C        ; variable used for context saving 
status_temp   EQU     0x0D        ; variable used for context saving
buffer        EQU     0x0E        ; temporary buffer

;**********************************************************************
RESET_VECTOR      CODE    0x0000  ; processor reset vector
        goto    start             ; go to beginning of program

ISR               CODE    0x0004  ; interrupt vector location

Interrupt:

        movwf  w_temp             ; save off current W register contents
        movf   STATUS,w           ; move status register into W register
        movwf  status_temp        ; save off contents of STATUS register

;  Place ISR Here
		btfss INTCON, T0IF
		goto  end_isr
		; If the interrupt is from timer0
		bcf   INTCON, T0IF ; Clearing the interrupt flag
; Rotate left or right
		bcf   STATUS, RP0 ; Select bank 0
		btfss PORTB, 6 ; If 1 - rotate left, 0 - right 
		goto  rright
;Rotate left
		rlf   buffer
		btfsc buffer, 6 ; Is the 6th bit affected?
		bsf   buffer, 0  ; If yes - set the 0-th bit of buffer
		bcf   buffer, 6  ; Clear the 6th bit just in case
		goto out_to_port
rright:
;Rotate right
		rrf   buffer
		btfsc STATUS, C ; Is Carry bit affected?
		bsf   buffer,5  ; If yes - set the 5th bit of buffer
out_to_port:
		movf  buffer, W  ; Put the buffer content to W
		btfsc PORTB, 7   ; Test the 7th bit of PORTB
		comf  buffer, W  ; If the bit == 1 - inverse the value
		movwf PORTB      ; Output value to PORTB
end_isr:
        movf   status_temp,w      ; retrieve copy of STATUS register
        movwf  STATUS             ; restore pre-isr STATUS register contents
        swapf  w_temp,f
        swapf  w_temp,w           ; restore pre-isr W register contents
        retfie                    ; return from interrupt

MAIN_PROGRAM    CODE

start:

; remaining code goes here
;Clear the PORTB
		clrf   PORTB

; SELECT the insternal instruction cycle clock for TMR0
		bsf    STATUS, RP0 ; Select bank 1
		bcf    OPTION_REG, T0CS ; Select internal clock source for TMR0


		;No prescaler needed. The PSA bit should not be changed (remains 1)
; Configure PORTB (RB0.. RB5 - outputs, PB6..RB7 - inputs)
		movlw  0C0h	; 1100 0000
		movwf  TRISB
; filling in the temporary buffer
		clrf   buffer
		incf   buffer ; buffer = 0000 0001
; Enable interrupt from timer
		bsf    INTCON, T0IE ; Enable interrupt from Timer0
		bsf    INTCON, GIE	; Switch on interrupts	

        goto $

        END                       ; directive 'end of program'

