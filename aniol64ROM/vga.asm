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
        ; store register values
        PUSH HL
        PUSH BC
        PUSH DE

        XOR A   ; load 0 to A
        LD HL, VRAM
        LD DE, (VRAM + 1)
        LD (HL), A  ; initialise the first byte of VRAM to 0
        LD BC, 2048  ; set loop counter to the full size of VRAM
        LDIR         ; repeatedly copy previous byte to the current byte

        ; restore register values
        POP DE
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
; checks whether screen coordinates are within the visible area [0..39, 0..29]
; B - X position
; C - Y position
; result in HL
; errors reported in A
vga_validAddr:
        LD A, 39
        CP B
        RET C ; if X position is more than 39, return non zero code in A
        LD A, 29
        CP C
        RET C ; if Y position is more than 29, return non zero code in A
        LD A, 0
        RET
ENDP

PROC
; returns the VRAM address for given XY position on screen
; B - X position
; C - Y position
; result in HL
; errors reported in A
defb "vga_getAddr"
vga_getAddr:
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
