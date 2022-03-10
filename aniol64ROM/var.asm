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
FirstRamPage equ 80h
TestAddr equ 8000h              ; points to the beginning of RAM
ClkScratchpad equ 8008h
ClkData equ 8009h
KbdBuff equ 8012h         ; a 1-byte buffer
LcdBuff equ 8020h         ; 20 byte long buffer + 1 byte for the trailing 0
NmiCount equ 8035h         ; reserving 4 bytes for the counter
MonCurrAddr equ 8036h
Random equ 8038h
LineBuff equ 8100h         ; 256 byte long buffer, including 1 byte for the trailing 0
PROGRAM_DATA equ 8200h
ENDIF

IF version=32
Aniol: defb   "     _ANIOL 32_     ", 0
RAMTOP equ 07FFFh
TestAddr equ 4000h  ; points to the beginning of RAM
ClkScratchpad equ 4008h
ClkData equ 4009h
KbdBuff equ 4012h         ; a 1-byte buffer
LcdBuff equ 4020h
NmiCount equ 4035h         ; reserving 4 bytes for the counter
MonCurrAddr equ 4036h
Random equ 4038h
LineBuff equ 4100h
PROGRAM_DATA equ 4200h
ENDIF

IF version=640
Aniol: defb   "     _ANIOL640_     ", 0
RAMTOP equ 0BFFFh
TestAddr equ 8000h  ; points to the beginning of RAM
ClkScratchpad equ 8008h
ClkData equ 8009h
KbdBuff equ 8012h         ; a 1-byte buffer
LcdBuff equ 8020h
LineBuff equ 8100h
NmiCount equ 8035h         ; reserving 4 bytes for the counter
MonCurrAddr equ 8036h
Random equ 8038h
Banks equ 8039h
PROGRAM_DATA equ 8200h
ENDIF
