;
; sum.asm
;

	.mmregs						; Include memory mapped registers to be refered to by their short name
	.sect	".text:sum_array"   ; Tell the compiler to put this code in the correct subsection of the .text section
	.align 4					; Align the _sum function entry
	.def	_sum_array			; Define the function entry

;----------------------------------------------------------------------
;   	 short sum_array(short * a,           => AR0
;                  	     short y              => T0
;				  ) 						  => T0
;----------------------------------------------------------------------

_sum_array:
	; Save status registers
    pshm  ST1_55             		; Save ST1
    pshm  ST2_55					; Save ST2
    pshm  ST3_55					; Save ST3

	; Write implementation here.
    ; The pointer to the array is in AR0, the number of elements is in T0
    CLR     AC0                ; Clear accumulator AC0 to start sum from 0
    RPTB    *+1                ; Begin repeat block
    ADD     *AR0+, AC0         ; Add element pointed by AR0 to AC0, then increment AR0
    DEC     T0                 ; Decrement T0 (number of elements left)
    B       *-2                ; Branch back two instructions if T0 not zero
    SAC     AC0, T0            ; Store the sum from AC0 to T0
    
	; Restore status registers
    popm  ST3_55       			; Restore ST1
    popm  ST2_55				; Restore ST2
    popm  ST1_55				; Restore ST3

    ret							; Exit function

    .end
