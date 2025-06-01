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


	ORG $D000
* start of the subroutine
* doesn't declare variables before hand unlike factorials.asm, just uses the stack for parameter passing
FAC	PULY		preserve return address (8-9,Y)
	DES
	DES		open a two byte hole for the return parameter `ret`
	PSHY		reorder stack so the return param is on the bottom
	DES		unsigned int next; (5,Y)
	DES		unsigned int count; (4,Y)
	DES
	DES		unsigned int result; (2-3,Y)
	DES
	DES		unsigned int store; (0-1,Y) 
	TSY
IF	CMPA	#2	
	BHS	ELSE	if n >= 2 then perform the factorial algorithm	
	CLR	8,Y
	LDAB	#1
	STAB	9,Y	else ret = 1 and that's it 
	BRA	DONE
ELSE
	CLR	8,Y
	STAA	9,Y	ret = n
	STAA	5,Y	
	DEC	5,Y	next = n-1 
WHILE1	LDAB	5,Y
	TSTB
	BLS	DONE	while (next > 0) 
	CLR	0,Y
	CLR	1,Y	
	CLR	2,Y
	CLR 	3,Y	result = 0
	LDAB	8,Y
	STAB	0,Y
	LDAB	9,Y
	STAB	1,Y	store = ret; 
	LDAB	5,Y 
	STAB	4,Y	count = next
WHILE2	LDAB	4,Y
	TSTB	
	BLS	ENDWHI2	while(count > 0) 
	LDAD	2,Y
	ADDD	0,Y
	STAD	2,Y	result += store 
	DEC	4,Y	count-- 
	BRA	WHILE2
ENDWHI2	LDAB	2,Y
	STAB	8,Y
	LDAB	3,Y
	STAB	9,Y	ret = result
	DEC	5,Y	next--
	BRA	WHILE1
DONE	INS
	INS
	INS
	INS
	INS
	INS		frees up all dynamic local variables on the stack 
	RTS
