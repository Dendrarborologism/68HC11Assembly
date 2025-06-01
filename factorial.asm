**************************************
*
* David Douglass
*
* Program description:  calculate the
* factorial N! of an unsigned 1-byte number N. 
*
* Pseudocode:
* unsigned int next, result, store, count, n, nfac;
*    n = 4; 
*    if (n < 2) {
*        nfac = 1; 
*    }
*    else {
*        nfac = n; 
*        next = n-1;  
*        while (next > 0) {
*            result = 0; 
*            store = nfac; 
*            count = next; 
*            while (count > 0) {
*                result += store;
*                count--;  
*            }
*            nfac = result; 
*            next--;   
*        }
*    }
**************************************

* start of data section

	ORG $B000
N	FCB	10
	ORG $B010
NFAC	RMB	2
NEXT	RMB	1
RESULT	RMB	2
STORE	RMB	2
COUNT	RMB	1


	ORG $C000
* start of the program
IF	LDAA	N
	CMPA	#2	
	BHS	ELSE	if n >= 2 then perform the factorial algorithm
	LDAA	#1	
	STAA	NFAC+1	else nfac = 1 and that's it 
	BRA	END
ELSE
	CLR	NFAC
	LDAA	N
	STAA	NFAC+1	nfac = n
	DECA
	STAA	NEXT	next = n-1 
WHILE1	LDAA	NEXT
	TSTA
	BLS	END	while (next > 0) 
	CLR	STORE
	CLR	STORE+1	
	CLR	RESULT
	CLR 	RESULT+1	result = 0
	LDAD	NFAC
	STAD	STORE	store = nfac; 
	LDAA	NEXT 
	STAA	COUNT	count = next
WHILE2	LDAA	COUNT
	TSTA	
	BLS	ENDWHI2	while(count > 0) 
	LDAD	RESULT
	ADDD	STORE
	STAD	RESULT	result += store 
	DEC	COUNT	count-- 
	BRA	WHILE2
ENDWHI2	LDAD	RESULT
	STAD	NFAC	nfac = result
	DEC	NEXT	next--
	BRA	WHILE1
END	STOP
