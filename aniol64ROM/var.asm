;----------------------------------------------------
; Project: aniol64.zdsp
; File: var.asm
; Date: 11/8/2021 12:20:28
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------

Aniol: defb   "               _ANIOL640_               ", 0
RAMTOP equ 0BFFFh
TestAddr equ 8000h  ; points to the beginning of RAM
ClkScratchpad equ 8008h
ClkData equ 8009h
KbdBuff equ 8012h         ; a 1-byte buffer
LcdBuff equ 8020h          ; 20 byte long buffer + 1 byte for the trailing 0
NmiCount equ 8035h
MonCurrAddr equ 8036h
Random equ 8038h
Banks equ 8039h
VgaCurX equ 8040h
VgaCurY equ 8041h
LineBuff equ 8100h
PROGRAM_DATA equ 8200h
