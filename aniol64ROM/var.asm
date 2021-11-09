;----------------------------------------------------
; Project: aniol64.zdsp
; File: var.asm
; Date: 11/8/2021 12:20:28
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------

IF version=64
RAMTOP equ 0FFFFh
Aniol: defb   "     _ANIOL 64_     ", 0
ENDIF

IF version=32
RAMTOP equ 07FFFh
Aniol: defb   "     _ANIOL 32_     ", 0
ENDIF

IF version=640
RAMTOP equ 0BFFFh
Aniol: defb   "     _ANIOL640_     ", 0
ENDIF
