**************************************
*
* David Douglass
*
* Program description: Checks whether a number
* N (0 < N <= 255) is prime and stores the value in PRIME 
* 
*    Pseudocode: 
*
*    unsigned int divisor;
*    unsigned int remainder;
*    unsigned int n; 
*    unsigned int prime;
*    unsigned int m;  
*    n = 15; 
*    prime = 1; ; 
*    if (n == 1) prime = 0;
*    else 
*    {
*    m = n-1
*    while (m > 1)
*    { 
*        divisor = m;  
*        remainder = n; 
*        while (remainder >= divisor) 
*        {  
*            remainder -= divisor;  
*        } 
*        if (remainder == 0)
*        {
*            prime = 0; 
*	   }
*        m--;  
*    }
*    }
*
**************************************
*uses the A register for the outer loop 
*and the B register for the inner loop 
* start of data section

	ORG $B000
N	FCB     15    
    
	ORG $B010
PRIME	RMB       1   
DIVISOR	RMB	1
REMAINDER	RMB	1
M	RMB	1
	ORG $C000
* start of the program
 	LDAA	#1
	STAA	PRIME	prime = 1;

IF	LDAA	N	
	CMPA	#1
	BNE ELSE 
	LDAA #0 
	STAA PRIME
	BRA END 

ELSE	DECA	
	STAA	M	m = n-1

WHILE	LDAA	M
	CMPA	#1	
	BLS	END	m > 1?
	STAA	DIVISOR
	LDAB 	N
	STAB	REMAINDER	remainder = n 

WHILE1	LDAB	REMAINDER	fetches dividend 			
	CMPB	DIVISOR	checks if dividend >= divisor 
	BLO	IF1	leave the while loop if not 
	SUBB	DIVISOR	remainder -= divisor 	STAA	REMAINDER	update remainder in memory
	STAB	REMAINDER
	BRA	WHILE1	repeat the while loop 

IF1	TSTB		 
	BNE	ENDIF	remainder == 0?
	CLR	PRIME	prime = 0 
	
ENDIF	DECA	
	STAA	M	m--; 
	BRA	WHILE

END	STOP