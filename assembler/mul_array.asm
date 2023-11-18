;
; sum.asm
;

	.mmregs						; Include memory mapped registers to be refered to by their short name
	.sect	".text:mul_array"   ; Tell the compiler to put this code in the correct subsection of the .text section
	.align 4					; Align the _sum function entry
	.def	_mul_array			; Define the function entry

;----------------------------------------------------------------------
;   	 long mul_array(short * a,           => AR0
;                  	    short y              => T0
;				  	) 						 => AC0
;----------------------------------------------------------------------

_mul_array:
	; Save status registers
    pshm  ST1_55             		; Save ST1
    pshm  ST2_55					; Save ST2
    pshm  ST3_55					; Save ST3

	; Write implementation here.
	mov 	#0, AC0					; clear AC0
    MVK    1, AC0                ; Initialize AC0 with 1 for multiplication
    RPT    T0                    ; Set up a repeat for T0 times
    MPY    *AR0+, AC0            ; Multiply each element with AC0 and auto-increment AR0

	; Restore status registers
    popm  ST3_55       			; Restore ST1
    popm  ST2_55				; Restore ST2
    popm  ST1_55				; Restore ST3

    ret							; Exit function

    .end
