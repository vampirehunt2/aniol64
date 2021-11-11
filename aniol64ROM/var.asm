;----------------------------------------------------
; Project: aniol64.zdsp
; File: var.asm
; Date: 11/8/2021 12:20:28
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------

IF version=64
Aniol: defb   "     _ANIOL 64_     ", 0
RAMTOP equ 0FFFFh
TestAddr equ 8000h  ; points to the beginning of RAM
ENDIF

IF version=32
Aniol: defb   "     _ANIOL 32_     ", 0
RAMTOP equ 07FFFh
TestAddr equ 4000h  ; points to the beginning of RAM
ENDIF

IF version=640
Aniol: defb   "     _ANIOL640_     ", 0
RAMTOP equ 0BFFFh
TestAddr equ 8000h  ; points to the beginning of RAM
ENDIF
