**************************************
*
* David Douglass
*
* Program description: Implements multiplication 
* via iterated addition of num1 by num2 
*
* Pseudocode:
* unsigned int num1, num2, result, count;
* result = 0; 
* store = num1; 
* count = num2; 
* while (count > 0) {
* 	result += store
*	count--; 
* }
*
**************************************

* start of data section

	ORG $B000
M1	FCB	$04
NUM2	FCB	$02

	ORG $B010
RESULT	RMB	2
COUNT RMB	1	 
STORE	RMB	2
	ORG $C000
* start of the program

	CLR	STORE
	CLR	STORE+1
	CLR	RESULT
	CLR 	RESULT+1
	LDAA	NUM1
	
	STAA	STORE+1	store = num1; 
	LDAA	NUM2 
	STAA	COUNT	count = num2

WHILE	LDAA	COUNT
	TSTA	
	BLS	END	if count <= 0 then end
	LDD	RESULT
	ADDD	STORE
	STAD	RESULT	result += store 
	DEC	COUNT	count-- 
	BRA	WHILE
END	STOP