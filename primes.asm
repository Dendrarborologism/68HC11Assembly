***************************************
*
* David Douglass
*
* Program description: Determine whether each value in a table is prime or not using a subroutine call
*
*
* Pseudocode of Main Program:
*	#define sentin $ff 
*	int *table, *prime, *tablep, *primep;
*	tablep = &table[0]; 
*	primep = &prime[0];
*	while (*tablep != sentin)
*	{
*		*primep = cprime(*tablep); 
*		tablep++; 
*		primep++; 
*	}
*---------------------------------------
*
* Pseudocode of Subroutine:
*unsigned int sub(unsigned int n)
*    unsigned int divisor;
*    unsigned int remainder;
*    unsigned int p;
*    unsigned int m;   
*    p = 1; 
*    if (n == 1) p = 0;
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
*            p = 0; 
*	   }
*        m--;  
*    }
*	return p; 
*    }
***************************************
* start of data section

	ORG $B000
N	FCB     1, 2, 11, 14, 31, 32, 37, 241, 251, 252, $FF     
SENTIN	EQU	$FF
    
	ORG $B010
PRIME	RMB     10   

* the subroutine does not access any of these variables, including
* N and PRIME
	ORG $C000
	LDS	#$01FF		initialize stack pointer
* start of the program
	LDX	#N	tablep = &table[0]
	LDY	#PRIME	primep = &prime[0]
WHILE	LDAA	0,X	
	CMPA	#SENTIN	
	BEQ	END	if *tablep != sentin then end
	PSHY		preserve primep 
	JSR	CPRIME	call subroutine 
	PULB		take the returned function val off the stack
	PULY		recall primep from the bottom of the stack 
	STAB	0,Y	*prime = cprime(*tablep)
	INX		tablep++
	INY		primep++ 
	BRA	WHILE
END	STOP	

* subroutine variables (params)
DIVISOR	RMB	1
REMAINDER	RMB	1
M	RMB	1


	ORG $D000
* start of your subroutine 

CPRIME	PULY		preserve return address		
		DES		open a slot for return param
		PSHY		reorders stack so the return param is on the bottom
	TSY
	LDAB	#1
	STAB	2,Y	param = 1 by default 

IF	CMPA	#1	if param in A register == 1	
	BNE	ELSE	
	TSY		point to the top of the stack
	LDAB	#0	param = 0
	STAB	2,Y	pass param to the ret hole on the stack
	BRA	DONE	end function call 

ELSE	DECA
	STAA	M	m=param-1
	INCA		update param to its previous value
	
WHILE1	LDAB	M
	CMPB	#1	
	BLS	DONE	m > 1?
	STAB	DIVISOR	m = n-1
	STAA	REMAINDER	remainder = param

WHILE2	LDAB	REMAINDER	fetches dividend 			
	CMPB	DIVISOR	checks if dividend >= divisor 
	BLO	IF1	leave the while loop if not 
	SUBB	DIVISOR	remainder -= divisor 
	STAB	REMAINDER	update remainder in memory
	BRA	WHILE2	repeat the while loop

IF1	TSTB		 
	BNE	ENDIF	remainder == 0?
	TSY		point to the top of the stack in Y
	LDAB	#0	
	STAB	2,Y	param = 0
	
ENDIF	DEC	M	m--; 
	BRA	WHILE1

DONE	RTS 
