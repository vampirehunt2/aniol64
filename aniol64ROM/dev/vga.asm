;----------------------------------------------------
; Project: aniol64.zdsp
; File: vga.asm
; Date: 3/25/2022 20:38:59
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------

VRAM equ 3800h + 64	; + 64 is for skipping the first line of display that is skewed.
MAX_X equ 39
MAX_Y equ 29
LF    equ 10
CR	  equ 13

Blank:		defb "                                      ", 0

dspInit:
        CALL clrScr
        CALL home
        RET

home:
        CALL cursorOff
        XOR A           ;LD A, 0
        LD (VgaCurX), A
        LD (VgaCurY), A
        CALL cursorOn
        RET


; clears the screen by filling the entire VRAM area with zeroes
; this includes the blanking regions, which may be somewhat redundant
; and impact performance slightly, but at least it ensures no data is sent
; to the display during blanking period
clrScr:
        ; store register values
        PUSH HL
        PUSH BC
        PUSH DE

        XOR A           ;LD A, 0
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

 
 
; turns on the cursor for the character at the current cursor position
cursorOn:
		LD A, (Cursor)
		CP FALSE
		JR Z, .noCursor
		PUSH HL
        CALL vga_XY2addr
        LD A, (HL)      ; get character at current cursor position
        OR 10000000b    ; set the cursor bit (D7)
        LD (HL), A
		POP HL
        RET
.noCursor:
		CALL cursorOff
		RET



; turns off the cursor for the character at the current cursor position
cursorOff:
		PUSH HL
        CALL vga_XY2addr
        LD A, (HL)      ; get character at current cursor position
        AND 01111111b    ; clear the cursor bit (D7)
        LD (HL), A
		POP HL
        RET

		
writeLn:
		CALL writeStr
		CALL nextLine
		RET

; moves the cursor to a new X, Y position on screen
; B - X position
; C - Y position
; destroys A
; TODO: do error checking
gotoXY:
        CALL cursorOff
        LD A, B
        LD (VgaCurX), A
        LD A, C
        LD (VgaCurY), A
        CALL cursorOn
        RET
		

cursorLShift:
		PUSH HL
		CALL cursorOff
		CALL vga_XY2addr
		DEC HL
		CALL vga_addr2XY
		CALL cursorOn
		POP HL
		RET


; puts a single character on the screen
; and moves the cursor over by one
; A - character to be written
putChar:
        PUSH HL
        PUSH AF
        CALL vga_XY2addr
        POP AF
        AND 01111111b   ; make sure cursor data is not stored
        LD (HL), A
		CALL vga_advanceCur
        POP HL
        RET

; gets a single character from the screen at current cursor position
; and moves the cursor over by one
; result in A
getChar:
        PUSH HL
        CALL vga_XY2addr
        CALL vga_advanceCur ; TODO vga_advanceCur should go at the end?
        LD A, (HL)
        AND 01111111b   ; make sure cursor data is not returned
        POP HL
        RET


; writes a string to the display at current cursor position
; IX - null-terminated string to write
writeStr:
        PUSH HL           ; store register state
		PUSH IX
        CALL vga_XY2addr  ; loads current VRAM address into HL
.loop:
        LD A, (IX)    ; loads the current character in the string to A
        CP 0          ; check if it's an EOL
        JR Z, .end    ; if so, end the procedure
        AND 01111111b ; make sure cursor data is not stored
        LD (HL), A    ; store the character into VRAM
        INC IX        ; move to the next character in the string
        INC HL        ; move to the next VRAM location
        LD A, L
        AND 00111111b ; get X position of the current character
        CP MAX_X      ; if we're at the end of the line, we should wrap around
        JR Z, .wrap
        JR NC, .wrap   ; if we happen to be beyond the end of line, best we wrap as well
        JP .loop
.wrap:
        CALL vga_addr2XY      ; store the current X and Y position in memory
        CALL nextLine  	  ; move to the next line, either down or by scrolling
        CALL vga_XY2addr      ; calculate the new VRAM address and load it to HL
        JP .loop
.end:
        CALL vga_addr2XY      ; store the final X and Y position in memory
		POP IX
        POP HL                ; restore register state
        RET



; goes to the next line of the display
; if there are free lines below the current ones, goes to the next one
; if we're already in the last line, the whole display is scrolled up
nextLine:
        CALL cursorOff
        XOR A           ; LD A, 0
        LD (VgaCurX), A ; move the cursor to the beginning of line
        LD A, (VgaCurY) ; load current cursor Y position (line number)
        CP MAX_Y        ; if already at the bottom of the screen
        JR NC, .scroll   ; then scroll the screen
        JR Z, .scroll
        INC A           ; else move to the next line down
        LD (VgaCurY), A
        JR .end
.scroll:
        CALL scroll
.end:
        CALL cursorOn
        RET

scroll:
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

; ###################################################################################
; ########## private functions ######################################################
; ###################################################################################


; checks whether screen coordinates are within the visible area [0..39, 0..29]
; D - X position
; E - Y position
; result in HL
; errors reported in A
vga_validAddr:
        LD A, MAX_X
        CP D
        RET C ; if X position is more than 39, return non zero code in A
        LD A, MAX_Y
        CP E
        RET C ; if Y position is more than 29, return non zero code in A
        LD A, 0
        RET



; returns the VRAM address for current cursor position
; VgaCurX - X position
; VgaCurY - Y position
; result in HL
; destroys A
vga_XY2addr:
        PUSH BC         ; store register values
        PUSH DE

        LD A, (VgaCurY) ; read in the Y position
        LD E, A
        LD D, 0         ; clear D
        AND A           ; clear carry
        LD B, 6         ; init the loop counter
.loop:
        SLA E           ; multiply the line number by 64...
        RL D            ; ... as there are 64 bytes per line
        DJNZ .loop      ; end multiply by 64
        LD A, (VgaCurX)
        ADD A, E           ; add X position
        LD E, A
        LD HL, VRAM     ; load the base VRAM address
        ADD HL, DE      ; add base VRAM address to the calculated offset

        POP DE
        POP BC          ; restore register values
        RET



; sets the X and Y cursor position based on VRAM address
; address in HL
; result:
; - VgaCurX - X position
; - VgaCurY - Y position
; destroys A
vga_addr2XY:
        PUSH BC			; store register state
		PUSH HL
        AND A           ; clear carry
        LD BC, VRAM		; reading in the VRAM base address to BC
        SBC HL, BC		; subtracting the base VRAM address from HL
        LD A, L
        AND 00111111b	; extract column number (X position of the cursor)
        LD (VgaCurX), A ; store column number
        AND A           ; clear carry
        LD B, 6         ; init loop conter
.loop:
        SRL H           ; divide HL by 64
        RR L
        DJNZ .loop
        LD A, L         ; line number now in L
        LD (VgaCurY), A ; store line number
		POP HL			; restore re
        POP BC
        RET



vga_advanceCur:
		PUSH AF
        PUSH BC
        CALL cursorOff
        LD A, (VgaCurX)
        LD B, A         ; read in the X position
        LD A, (VgaCurY)
        LD C, A         ; read in the Y position
        INC B           ; move the cursor to the next charatcter
        LD A, MAX_X     ; if we are over the line end
        CP B             ; then wrap line
        JR C, .wrapLine
        JR .end
.wrapLine:
        LD B, 0       ; move cursor to beginning of line
        INC C         ; move cursor to next line
        LD A, MAX_Y   ; if we are over the end of screen
        CP C          ; then wrap back to 0,0
        JR C, .wrapScreen
        JR .end
.wrapScreen:
        LD B, 0       ; wrapping back to 0,0
        LD C, 0
.end:
        LD A, B        ; store new cursor location
        LD (VgaCurX), A
        LD A, C
        LD (VgaCurY), A
        CALL cursorOn
        POP BC
		POP AF
        RET



vga_wrapLine:
		CALL cursorOff
        XOR A           ; LD A, 0
        LD (VgaCurX), A ; move the cursor to the beginning of line
        LD A, (VgaCurY) ; load current cursor Y position (line number)
        CP MAX_Y        ; if already at the bottom of the screen
		JR Z, .wrapScreen   
        INC A           ; else move to the next line down
		JR .end
.wrapScreen:
		LD A, 0
.end:
        LD (VgaCurY), A
		RET

		

