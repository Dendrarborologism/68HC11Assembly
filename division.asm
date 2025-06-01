**************************************
* David Douglass
*
* Program description: Divides DIVIDEND (unsigned 1-byte) by DIVISOR (unsigned 1-byte) via iterated subtraction, with QUOTIENT
* storing the quotient and REMAINDER storing the remainder. Division by zero results in 
* QUOTIENT and REMAINDER storing $FF. 
* Pseudocode:
*   unsigned int dividend; 
*   unsigned int divisor;
*   unsigned int quotient;
*   unsigned int remainder;
*   dividend = 201; 
*   divisor = 6; 
*   quotient = 0; 
*   remainder = dividend; 
*   if (divisor == 0) 
*   {
*       quotient = 0xFF; 
*       remainder = 0xFF;
*   } 
*   else 
*   {
*       while (remainder >= divisor) 
*       {  
*           remainder -= divisor;  
*           quotient++; 
*       } 
*   }
**************************************

* start of data section

	ORG $B000
DIVIDEND	FCB	201         The dividend
DIVISOR	FCB	6         The divisor.

	ORG $B010
QUOTIENT	RMB       1         The quotient.
REMAINDER	RMB       1         The remainder.

	ORG $C000
* start of the program
	CLR	QUOTIENT	quotient=0  
	LDAA	DIVIDEND
	STAA	REMAINDER	remainder=dividend
IF	LDAA	DIVISOR 	fetches divisor and checks if divisor is equal to zero
	TSTA		 	divisor == 0? 
	BNE	ELSEWHI  	enter the iterated subtraction loop if not 
	LDAA	#$FF 
	STAA	QUOTIENT	quotient=$FF
	STAA	REMAINDER	remainder =$FF
	BRA END	end the program since division by zero is invalid 
ELSEWHI	LDAA	REMAINDER	fetches dividend 
	CMPA	DIVISOR	checks if dividend >= divisor 
	BLO	END	leave the while loop if not 
	SUBA	DIVISOR	remainder -= divisor 
	INC	QUOTIENT	quotient++
	STAA	REMAINDER	update remainder in memory
	BRA	ELSEWHI	repeat the while loop 
END	STOP	end the program 
