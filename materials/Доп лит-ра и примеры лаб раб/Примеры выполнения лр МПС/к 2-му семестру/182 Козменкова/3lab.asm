	list p=16f84a
	#include <p16F84A.inc>

	org 0h
	clrf PORTB
	bsf STATUS, RP0
	movlw 0xFE
	movwf TRISB
	bcf STATUS,RP0
LOOP 	bsf PORTB,0
LOOPH 	btfss PORTB,1
	goto LOOPH
	bcf PORTB,0
LOOPL 	btfsc PORTB,1
	goto LOOPL
	goto LOOP
	end
