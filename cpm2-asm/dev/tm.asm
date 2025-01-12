; TellyMate PAL driver
; http://www.batsocks.co.uk/products/Other/TellyMate_UserGuide_ControlSequences.htm
; 

MAX_X equ 37
MAX_Y equ 24
		

; puts a single character on the screen
; and moves the cursor over by one
; A - character to be written
putChar:
	OUT (DART_B_DAT), A
    RET

