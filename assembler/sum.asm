;
; sum.asm
;

	.mmregs					; Include memory mapped registers to be refered to by their short name
	.sect	".text:sum"		; Tell the compiler to put this code in the correct subsection of the .text section
	.align 4				; Align the _sum function entry
	.def	_sum			; Define the function entry

;----------------------------------------------------------------------
;   	 short sum(short x,           => T0
;                  short y            => T1
;				  ) 				  => T0
;----------------------------------------------------------------------

_sum:
	; Save status registers
    pshm  ST1_55             		; Save ST1
    pshm  ST2_55					; Save ST2
    pshm  ST3_55					; Save ST3

	; Write implementation here.
    ; The parameters x and y are in T0 and T1 respectively.
    ; The result should be stored back in T0.
    add T1, T0                  ; Add y (T1) to x (T0) and store the result in T0

	; Restore status registers
    popm  ST3_55       			; Restore ST1
    popm  ST2_55				; Restore ST2
    popm  ST1_55				; Restore ST3

    ret							; Exit function

    .end
