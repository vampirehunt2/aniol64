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
TestAddr equ 8000h              ; points to the beginning of RAM
ClkScratchpad equ 8008h
ClkData equ 8009h
KbdBuff equ 8012h         ; a 1-byte buffer
LineBuff equ 8100h
ENDIF

IF version=32
Aniol: defb   "     _ANIOL 32_     ", 0
RAMTOP equ 07FFFh
TestAddr equ 4000h  ; points to the beginning of RAM
ClkScratchpad equ 4008h
ClkData equ 4009h
KbdBuff equ 4012h         ; a 1-byte buffer
LineBuff equ 4100h
ENDIF

IF version=640
Aniol: defb   "     _ANIOL640_     ", 0
RAMTOP equ 0BFFFh
TestAddr equ 8000h  ; points to the beginning of RAM
ClkScratchpad equ 8008h
ClkData equ 8009h
KbdBuff equ 8012h         ; a 1-byte buffer
LineBuff equ 8100h
ENDIF