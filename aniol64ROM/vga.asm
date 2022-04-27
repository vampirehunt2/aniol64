;----------------------------------------------------
; Project: aniol64.zdsp
; File: vga.asm
; Date: 3/25/2022 20:38:59
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------

VRAM equ 3800h
MAX_X equ 39
MAX_Y equ 29

vga_init:
        LD A, 0
        LD (VgaCurX), A
        LD (VgaCurY), A
        CALL vga_curOn
        RET

PROC
; clears the screen by filling the entire VRAM area with zeroes
; this includes the blanking regions, which may be somewhat redundant
; and impact performance slightly, but at least it ensures no data is sent
; to the display during blanking period
vga_clrscr:
        ; store register values
        PUSH HL
        PUSH BC
        PUSH DE

        LD A, 0
        LD HL, VRAM
        LD DE, VRAM + 1
        LD (HL), A   ; initialise the first byte of VRAM to 0
        LD BC, 2048  ; set loop counter to the full size of VRAM
        LDIR         ; repeatedly copy previous byte to the current byte

        ; restore register values
        POP DE
        POP BC
        POP HL
        RET
ENDP

vga_scroll:
       ; store register values
        PUSH HL
        PUSH BC
        PUSH DE

        LD HL, VRAM + 64  ; 64 is the number of bytes for one display line
        LD DE, VRAM
        LD BC, 64 * 30  ; set loop counter to the size of visible memory (VRAM minus vertical blanking)
        LDIR         ; repeatedly copy previous byte to the current byte

        ; restore register values
        POP DE
        POP BC
        POP HL
        RET

PROC
; turns on the cursor for the character at the current cursor position
vga_curOn:
        CALL vga_getAddr
        LD A, (HL)      ; get character at current cursor position
        OR 10000000b    ; set the cursor bit (D7)
        LD (HL), A
        RET
ENDP

PROC
; turns off the cursor for the character at the current cursor position
vga_curOff:
        CALL vga_getAddr
        LD A, (HL)      ; get character at current cursor position
        AND 01111111b    ; clear the cursor bit (D7)
        LD (HL), A
        RET
ENDP

PROC
; checks whether screen coordinates are within the visible area [0..39, 0..29]
; B - X position
; C - Y position
; result in HL
; errors reported in A
vga_validAddr:
        LD A, MAX_X
        CP B
        RET C ; if X position is more than 39, return non zero code in A
        LD A, MAX_Y
        CP C
        RET C ; if Y position is more than 29, return non zero code in A
        LD A, 0
        RET
ENDP

; returns the VRAM address for current cursor position
; VgaCurX - X position
; VgaCurY - Y position
; result in HL
; errors reported in A
vga_getAddr:
        LD A, (VgaCurX)
        LD B, A         ; read in the X position
        LD A, (VgaCurY)
        LD C, A         ; read in the Y position
        CALL vga_getAddrXY
        RET

vga_setAddr:
        LD A, H
        RET

PROC
; returns the VRAM address for given XY position on screen
; B - X position
; C - Y position
; result in HL
; errors reported in A
vga_getAddrXY:
        ; error checking
        CALL vga_validAddr
        CP 0
        RET NZ
        ; end error checking

        PUSH DE  ; store register values
        LD E, C  ; load the line number into E
        LD D, 0  ; clear D
        AND A   ; clear carry
        SLA E   ; multiply the line number by 64, as there are 64 bytes per line
        RL D
        SLA E
        RL D
        SLA E
        RL D
        SLA E
        RL D
        SLA E
        RL D
        SLA E
        RL D    ; end multiply by 64
        LD A, E
        ADD A, B   ; add X position
        LD E, A
        JP C, _inc ; if adding the X position resulted in overflow, increment D
        JP _end
_inc:
        INC D
_end:
        LD HL, VRAM
        ADD HL, DE ; add base VRAM address to the calculated offset
        POP DE    ; restore registers
        LD A, 0   ; report no errors
        RET
ENDP

; moves the cursor to a new X, Y position on screen
; B - X position
; C - Y position
; TODO: do error checking
vga_gotoXY:
        CALL vga_curOff
        LD A, B
        LD (VgaCurX), A
        LD A, C
        LD (VgaCurY), A
        CALL vga_curOn
        RET

PROC
vga_advanceCur:
        CALL vga_curOff
        ; the following 4 lines are redundant, as vga_curOff already does this
        ;LD A, (VgaCurX)
        ;LD B, A         ; read in the X position
        ;LD A, (VgaCurY)
        ;LD C, A         ; read in the Y position
        INC B           ; move the cursor to the next charatcter
        LD A, MAX_X     ; if we are over the line end
        CP B             ; then wrap line
        JR C, _wrapLine
        JR _end
_wrapLine:
        LD B, 0       ; move cursor to beginning of line
        INC C         ; move cursor to next line
        LD A, MAX_Y   ; if we are over the end of screen
        CP C          ; then wrap back to 0,0
        JR C, _wrapScreen
        JR _end
_wrapScreen:
        LD B, 0       ; wrapping back to 0,0
        LD C, 0
_end:
        LD A, B        ; store new cursor location
        LD (VgaCurX), A
        LD A, C
        LD (VgaCurY), A
        CALL vga_curOn
        RET
ENDP

PROC
; puts a single character on the screen
; and moves the cursor over by one
; A - character to be written
vga_putChar:
        PUSH AF
        CALL vga_getAddr
        CALL vga_advanceCur
        POP AF
        AND 01111111b   ; make sure cursor data is not stored
        LD (HL), A
        RET
ENDP

PROC
; gets a single character from the screen at current cursor position
; and moves the cursor over by one
; result in A
vga_getChar:
        CALL vga_getAddr
        CALL vga_advanceCur
        LD A, (HL)
        AND 01111111b   ; make sure cursor data is not returned
        RET
ENDP

PROC
vga_wriStr:
        CALL vga_getAddr
_loop:
        LD A, (IX)
        CP 0
        RET Z
        AND 01111111b ; make sure cursor data is not stored
        LD (HL), A
        INC IX
        INC HL
        JP _loop
ENDP
