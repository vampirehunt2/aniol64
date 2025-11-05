 device NOSLOT64K 


 org 0000h
    ;LD SP, 4000h
    JP init

 ds 0066h - $, 0
	; NMI handler
	RETN

Cursor				equ 4000h
Colour              equ 4001h
CurX 				equ 4002h
CurY 				equ 4003h
Scroll		    	equ 4004h	

PixelData equ 4000h
ColourData equ 0000h


init:
;    CALL dspInit
;    LD A, '@'
;    CALL putChar

; fill Pixels:
    LD HL, PixelData
    LD BC, 4000h 
.loop:
    LD A, 00h
    LD (HL), A
    INC HL
    DEC BC
    LD A, B
    OR C
    JR NZ, .loop

    ; initialise colour data with white on black
    LD HL, ColourData
    LD BC, 4000h 
    ;LD D, 10h
.loop1:
    LD A, 0F0h
    LD (HL), A
    ;ADD A, 10h
    ;LD D, A
    INC HL
    DEC BC
    LD A, B
    OR C
    JR NZ, .loop1



    LD HL, PixelData + (5 * 64 * 8) + 20
    LD BC, 64
    LD A, 00
    LD (HL), A
    ADD HL, BC
    LD A, 3Ch
    LD (HL), A
    ADD HL, BC
    LD A, 66h
    LD (HL), A
    ADD HL, BC
    LD A, 6Eh
    LD (HL), A
    ADD HL, BC
    LD A, 6Eh
    LD (HL), A
    ADD HL, BC
    LD A, 60h
    LD (HL), A
    ADD HL, BC
    LD A, 3Eh
    LD (HL), A
    ADD HL, BC
    LD A, 00h
    LD (HL), A
    

.stop:
    HALT
    JP .stop 

; include colourvga.asm

    