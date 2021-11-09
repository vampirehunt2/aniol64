;----------------------------------------------------
; Project: test.zdsp
; Main File: test.asm
; Date: 11/8/2021 11:52:05
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------


IF version=32
RAMTOP equ 0F0Fh
ELSE
RAMTOP equ 0D0Dh
ENDIF

LD SP, RAMTOP

