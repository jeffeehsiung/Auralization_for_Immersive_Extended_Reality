;
; sum.asm
;

	.mmregs					; Include memory mapped registers to be refered to by their short name
	.sect	".text:multiply"; Tell the compiler to put this code in the correct subsection of the .text section
	.align 4				; Align the _sum function entry
	.def	_multiply			; Define the function entry

;----------------------------------------------------------------------
;   	 long multiply(short x,           => T0
;                  	   short y            => T1
;				  ) 				 	  => AC0
;----------------------------------------------------------------------

_multiply:
	; Save status registers
    pshm  ST1_55             		; Save ST1
    pshm  ST2_55					; Save ST2
    pshm  ST3_55					; Save ST3

	; Write implementation here.
    ; The parameters x and y are in T0 and T1 respectively.
    ; The result will be stored in AC0.
    MPY   T1, T0                ; Multiply x (T0) and y (T1) and store the result in AC0

	; Restore status registers
    popm  ST3_55       			; Restore ST1
    popm  ST2_55				; Restore ST2
    popm  ST1_55				; Restore ST3

    ret							; Exit function

    .end
