;----------------------------------------------------
; Project: aniol64.zdsp
; File: vga.asm
; Date: 3/25/2022 20:38:59
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------

VRAM equ 3800h

PROC
vga_clrscr:
        PUSH HL
        PUSH BC
        LD B, 255
_loop:
        LD HL, VRAM
        LD (HL), 0
        INC HL
        LD (HL), 0
        INC HL
        LD (HL), 0
        INC HL
        LD (HL), 0
        INC HL
        LD (HL), 0
        INC HL
        LD (HL), 0
        INC HL
        LD (HL), 0
        INC HL
        LD (HL), 0
        INC HL
        DJNZ _loop
        POP BC
        POP HL
        RET
ENDP

PROC
vga_cursorOn:
        RET
ENDP

PROC
vga_cursorOff:
        RET
ENDP

PROC
vga_wriStr:
        LD IY, VRAM ; for now, just write from the beginning of the screen
                ; later on we will track the cursor position
_loop:
        LD A, (IX)
        CP 0
        RET Z
        LD (IY), A
        INC IX
        INC IY
        JP _loop
ENDP
