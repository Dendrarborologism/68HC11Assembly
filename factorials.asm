**************************************
*
* David Douglass
*
* Program description: Iterates through an array N of one one-byte unsigned numbers
* and stores the results in an array NFAC of two-byte numbers 
*
* Pseudocode of Main Program:
* #define sentin $ff 
* int *n, *nfac, *np, *nfacp; 
* np = n; &n[0]; 
* nfacp = &nfac[0]; 
* while (np != sentin) {
*  *nfacp = fac(*np); 
*  np++; 
*  nfacp++;
*  nfacp++; 
* }
* Pseudocode of Subroutine:
* unsigned int fac(unsigned int n) {
* usnigned int next, result, store, count, ret; 
*    if (n < 2) {
*        ret = 1; 
*    }
*    else {
*        ret = n; 
*        next = n-1;  
*        while (next > 0) {
*            result = 0; 
*            store = ret; 
*            count = next; 
*            while (count > 0) {
*                result += store;
*                count--;  
*            }
*            ret = result; 
*            next--;   
*        }
*    }
*    return ret; 
* }
**************************************


* start of data section

	ORG $B000
N	FCB	0, 1, 5, 8, 10, $FF
SENTIN	EQU	$FF

	ORG $B010
NFAC	RMB	10

	ORG $C000
* start of the main program
	LDS	#$01FF
	LDX	#N	np = &n[0]
	LDY	#NFAC	nfac = &nfac[0] 
WHILE	LDAA	0,X	
	CMPA	#SENTIN	
	BEQ	END	if *np != sentin then end
	PSHY		preserve nfacp 
	JSR	FAC	call subroutine 
	PULA		take the high byte of the returned function val off the stack
	PULB		take the low byte of the returned function val off the stack 	
	PULY		recall primep from the bottom of the stack 
	STAA	0,Y	stores the high byte in the appropriate slot in nfac
	STAB	1,Y	stores the low byte in the appropriate slot in nfac
	INX		np++
	INY		nfacp++ 
	INY		nfacp++	increments twice because the nfac table has twice as many bytes
	BRA	WHILE
END	STOP	


* subroutine vars 
NEXT	RMB	1
RESULT	RMB	2
STORE	RMB	2
COUNT	RMB	1


	ORG $D000
* start of the subroutine
FAC	PULY		preserve return address
	DES
	DES		open a two byte hole for the return parameter `ret`
	PSHY		reorder stack so the return param is on the bottom
	TSY
IF	CMPA	#2	
	BHS	ELSE	if n >= 2 then perform the factorial algorithm	
	CLR	2,Y
	LDAB	#1
	STAB	3,Y	else ret = 1 and that's it 
	BRA	DONE
ELSE
	CLR	2,Y
	STAA	3,Y	ret = n
	STAA	NEXT	
	DEC	NEXT	next = n-1 
WHILE1	LDAB	NEXT
	TSTB
	BLS	DONE	while (next > 0) 
	CLR	STORE
	CLR	STORE+1	
	CLR	RESULT
	CLR 	RESULT+1	result = 0
	LDAB	2,Y
	STAB	STORE
	LDAB	3,Y
	STAB	STORE+1	store = ret; 
	LDAB	NEXT 
	STAB	COUNT	count = next
WHILE2	LDAB	COUNT
	TSTB	
	BLS	ENDWHI2	while(count > 0) 
	LDAD	RESULT
	ADDD	STORE
	STAD	RESULT	result += store 
	DEC	COUNT	count-- 
	BRA	WHILE2
ENDWHI2	LDAB	RESULT
	STAB	2,Y
	LDAB	RESULT+1
	STAB	3,Y	ret = result
	DEC	NEXT	next--
	BRA	WHILE1
DONE	RTS
