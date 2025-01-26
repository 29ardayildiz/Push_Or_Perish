;-------------------------------------------------------------------------------
; 	  MSP430 Assembler Code Template for Use With TI Code Composer Studio
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include Device Header File

;-------------------------------------------------------------------------------
            .def    RESET                   ; Export Program Entry-Point to
                                            ; Make It Known to Linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble Into Program Memory.
            .retain                         ; Override ELF Conditional Linking
                                            ; and Retain Current Section.
            .retainrefs                     ; And Retain Any Sections That Have
                                            ; References to Current Section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize Stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop Watchdog Timer

;-------------------------------------------------------------------------------
; 						Main Loop and Pin Definitions
;-------------------------------------------------------------------------------
;
; 				P1.0, 1.1, 1.2, 1.4, 1.5, 1.6, 1.7 => 7 Segment LED Pins
; 							P2.0, 2.1 => Buttons
; 							 P2.2, 2.3 => LEDs
;
;-------------------------------------------------------------------------------

;--- Definitions and Initial Pin Setup ---
	bic.b #11110111b, &P1SEL     ; Clear P1SEL to Use Port 1 as GPIO
	bic.b #11110111b, &P1SEL2
	bic.b #00001111b, &P2SEL     ; Clear Lower 4 Bits of P2SEL for GPIO
	bic.b #00001111b, &P2SEL2

; 7 Segments And LEDs Output Setup
	bis.b #11110111b, &P1DIR     ; Set Corresponding Pins in P1DIR as Output
	bis.b #00001100b, &P2DIR

; Buttons Setup
	bic.b #00000011b, &P2DIR     ; P2.0, P2.1 Input for Buttons
	bis.b #00000011b, &P2REN     ; Enable Pull-Up Resistors
	bis.b #00000011b, &P2OUT

; Clear Outputs
	bic.b #11110111b, &P1OUT     ; Turn Off All 7-Segment LED Pins Initially
	bic.b #00001100b, &P2OUT     ; Turn Off Both LEDs Initially

; Enable Global Interrupts
	bis.w #GIE, SR               ; General Interrupt Enable

; Configure Interrupt Edge for Buttons on Port 2.0,2.1 H to L
	bis.b #00000011b, &P2IES

;-------------------------------------------------------------------------------
; 									Main
;-------------------------------------------------------------------------------
mainLoop:
	bis.b #00000011b, &P2IE      ; Enable Interrupts for P2.0 and P2.1

	call #sevenSegments_3
	call #controlFunction
	call #delay1Sec
	call #controlFunction

	call #sevenSegments_2
	call #controlFunction
	call #delay1Sec
	call #controlFunction

	call #sevenSegments_1
	call #controlFunction
	call #delay1Sec
	call #controlFunction

	call #sevenSegments_0
	call #controlFunction
	call #delay1Sec
	call #controlFunction

	bic.b #00000011b, &P2IE      ; Disable Interrupts for P2.0 and P2.1
	call #sevenSegments_Blank
	call #delay3Sec

	bic.b #00000011b, &P2IFG     ; Clear Port 2 Interrupt Flags
	jmp mainLoop                 ; Repeat the Main Loop Indefinitely

;-------------------------------------------------------------------------------
; 								Functions
;-------------------------------------------------------------------------------

;--- Delay 3 Seconds ---
delay3Sec:
	mov.w #0 , r4                ; Initialize Counter r4
	mov.w #0 , r5                ; Initialize Counter r5

delay_outer3sec:
	add.w #1 , r4                ; Outer Loop Increment

delay_inner3sec:
	add.w #1 , r5                ; Inner Loop Increment
	cmp #50000 , r5              ; Compare r5 with 50000
	jne delay_inner3sec          ; If not Equal, Keep Looping
	cmp #12 , r4                 ; Compare r4 with 12
	jne delay_outer3sec          ; If not Equal, Keep Looping
	ret                          ; Return when Both Loops Complete

;--- Delay 1 Second ---
delay1Sec:
	mov.w #0 , r4
	mov.w #0 , r5

delay_outer1sec:
	add.w #1 , r4

delay_inner1sec:
	add.w #1 , r5
	cmp #50000 , r5
	jne delay_inner1sec
	cmp #4 , r4
	jne delay_outer1sec
	ret

;--- Display Number "3" on 7 Segment LED ---
sevenSegments_3:                     ; Turn On 7 Segment LED's a, b, c, d, g LEDs
	mov.w #3 , r6                    ; Store Digit '3' in r6
	bic.b #11110111b, &P1OUT
	bis.b #10010111b, &P1OUT
	ret

;--- Display Number "2" on 7 Segment LED ---
sevenSegments_2:                     ; Turn On 7 Segment LED's a, b, d, e, g LEDs
	mov.w #2 , r6
	bic.b #10010111b, &P1OUT
	bis.b #10110011b, &P1OUT
	ret

;--- Display Number "1" on 7 Segment LED ---
sevenSegments_1:                     ; Turn On 7 Segment LED's b and c LEDs
	mov.w #1 , r6
	bic.b #10110011b, &P1OUT
	bis.b #00000110b, &P1OUT
	ret

;--- Display Number "0" on 7 Segment LED ---
sevenSegments_0:                     ; Turn On 7 Segment LED's a, b, d, e, f LEDs
	mov.w #0 , r6
	bic.b #00000110b, &P1OUT
	bis.b #01110111b, &P1OUT
	ret

;--- Turn All Segments Off and Turn On 7 Segment LED'S g LED ---
sevenSegments_Blank:
	mov.w #-1 , r6
	bic.b #01110111b, &P1OUT
	bis.b #10000000b, &P1OUT
	ret

;--- Control Function Checks State in r6 ---
controlFunction:				  ; Controller Function of Restarting Game When the Game Ends
	cmp #-2 , r6
	jeq mainLoop                  ; If r6 == -2, Jump Back to mainLoop
	ret

;-------------------------------------------------------------------------------
; 								  Interrupts
;-------------------------------------------------------------------------------

;--- Button Game Interrupt (Port 2) ---
Game:
	cmp #0, r6					  ; Current LED Position When Pressed
	jeq State_1

State_2:						  ; Function Applied for the Baseman Before the Game Starts
	bic.b #00000011b, &P2IE       ; Disable Interrupts on P2.0 and P2.1
	bit.b #00000001b, &P2IN       ; Check P2.0 Button State
	jeq player2_earlyPress

player1_earlyPress:
	bis.w #00001000b , &P2OUT
	call #delay1Sec
	bic.w #00001000b , &P2OUT
	jmp out

player2_earlyPress:
	bis.w #00000100b , &P2OUT
	call #delay1Sec
	bic.w #00000100b , &P2OUT
	jmp out

State_1:						  ; Control Operation When Pressed on Time
	bic.b #00000011b, &P2IE
	bit.b #00000001b, &P2IN
	jeq player2_win

player1_win:
	bis.w #00000100b , &P2OUT
	call #delay1Sec
	bic.w #00000100b , &P2OUT
	jmp out

player2_win:
	bis.w #00001000b , &P2OUT
	call #delay1Sec
	bic.w #00001000b , &P2OUT

out:
	bis.b #00000011b, &P2IE       ; Re-enable Interrupts
	bic.b #00000011b, &P2IFG      ; Clear Interrupt Flags for P2.0 and P2.1
	mov.w #-2 , r6
    reti

;-------------------------------------------------------------------------------
; 						  Stack Pointer Definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack

;-------------------------------------------------------------------------------
;							 Interrupt Vectors
;-------------------------------------------------------------------------------

			.sect ".int03"                  ; Port 2 Interrupt Vector
			.short	Game
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
