*the main program first initializes the hardware, and variables and registers (including the RESULT variable), then will continuously output the sequence $00, $FF, $00, $FF ... on port C.
*the IRQ-ISR counts the number of interrupts (i.e., the number of times the IRQ-ISR is called) and stores the 16-bit count result in the RESULT variable. 
*assumes that the external I/O hardware uses only the IRQ pin (assuming a level-sensitive IRQ) to synchronize with the processor. 

    ORG		$D000
RESULT	RMB		2
PORTC	EQU		$1003
DDRC	EQU		$1007


    ORG		$C000
MAIN	CLR 	PORTC	
		LDAA	#$3C
		STAA	DDRC
		LDS		#$01FF 
		CLR		RESULT
		CLR		RESULT+1
		CLI
LOOP	LDAA	PORTC 
IF		TSTA
		BNE 	ELSE		
		LDAA	#$FF
		STAA	PORTC
		BRA	 	LOOP 
ELSE	CLR		PORTC
		BRA	    LOOP 


    ORG		$E000
ISR	LDD		RESULT
	ADDD	#$0001
	STAD	RESULT
	RTI

	ORG		$FFF2
	FDB		ISR
