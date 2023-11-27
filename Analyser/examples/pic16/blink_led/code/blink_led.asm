;**********************************************************************
;                                                                     *
;   This file is a code example for Microchip PIC16F84A               *
;   microcontroller. The program continually changes the output value *
;   of PORTB of Microcontroller to make the LEDs connected to the     *
;   outputs of the port blink.                                        * 
;   The recomended operation speed is 10 kHz                          *
;                                                                     *
;   Refer to the MPASM User's Guide for additional information on     *
;   features of the assembler (Document DS33014).                     *
;                                                                     *
;   Refer to the respective PIC data sheet for additional             *
;   information on the instruction set.                               *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Filename:        blink_led.asm                                         *
;    Date:                                                            *
;    File Version:                                                    *
;                                                                     *
;    Author:    Sergei Loschilov                                      *
;    Company:   N.Novgorod State Technical University                 *
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
counter      EQU     0x0E        ; Counter

;**********************************************************************
RESET_VECTOR      CODE    0x0000  ; processor reset vector

; put logic nulls to the PORTB output
		clrf   PORTB

; make the PORTB pins to be output pins
		bsf    STATUS,RP0 ; SELECT bank 1
		clrf   TRISB      ; Set all bits of TRISB register to 0
		bcf    STATUS,RP0 ; SELECT bank 0
 
; wait the loop of 255 cycles
wait:
		clrf   counter
loop:
		incfsz counter
		goto   loop
; toggle the output values for PORTB	
		comf   PORTB,F
		goto   wait	

        END                       ; directive 'end of program'

