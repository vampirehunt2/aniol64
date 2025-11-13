; Colour codes:
BLACK equ 00h
BLUE equ 01h
GREEN equ 02h
CYAN equ 03h
OLIVE equ 04h
SAPPHIRE equ 05h
RED equ 08h
PURPLE equ 09h
YELLOW equ 0Ah
ORANGE equ 0Ch
PINK equ 0Dh
WHITE equ 0Fh

PixelData equ 0C000h
ColourData equ 8000h

MAX_X equ 39
MAX_Y equ 29
LF    equ 10
CR	  equ 13

SCROLL_PORT equ 11011111b   ; scroll register activated by A5

Blank:		defb "                                      ", 0

Font: 
 incbin ../dev/ATARI.fnt

dspInit:
    LD A, 0
    CALL vga_setScroll
    CALL clrScr
    LD A, 0F0h
    LD (Colour), A
    RET


home:
    CALL cursorOff
    XOR A           ;LD A, 0
    LD (CurX), A
    LD (CurY), A
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
    LD HL, PixelData
    LD DE, PixelData + 1
    LD (HL), A      ; initialise the first byte of Pixel RAM to 0
    LD BC, 16*1024-1; set loop counter to the full size of Pixel RAM
    LDIR            ; repeatedly copy previous byte to the current byte

    LD A, 0F0h          
    LD HL, ColourData
    LD DE, ColourData + 1
    LD (HL), A      ; initialise the first byte of Colour RAM
    LD BC, 16*1024-1; set loop counter to the full size of Colour RAM
    LDIR            ; repeatedly copy previous byte to the current byte

    CALL home       ; move the cursor to 0,0   

    ; restore register values
    POP DE
    POP BC
    POP HL
    RET

; turns off the cursor for the character at the current cursor position
cursorOff: ; TODO: protect against calling cursorOff twice working like cursorOn
; turns on the cursor for the character at the current cursor position
cursorOn:
    PUSH BC
    PUSH DE
    PUSH HL
    CALL vga_XY2addr
    LD BC, 64   ; number of bytes in a physical screen line
    LD D, 8     ; number of physical screen lines in a character line
.loop:
    LD A, (HL)  ; get the colour data at that position
    RLC A       ; rotate 4 times to swap around the foregroung with the background colour
    RLC A
    RLC A
    RLC A
    LD (HL), A
    ADD HL, BC  ; move to the next screen line
    DEC D
    JR NZ, .loop; repeat 8 times
    POP HL
    POP DE
    POP BC
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
    LD (CurX), A
    LD A, C
    LD (CurY), A
    CALL cursorOn
    RET
		
cursorLShift:
    CALL cursorOff
	LD A, (CurX)
    CP 0
    JR Z, .end
    DEC A
    LD (CurX), A
.end:
    CALL cursorOn
	RET

; puts a single character on the screen
; and moves the cursor over by one
; A - character to be written
putChar:
    ; save register values
    PUSH HL
    PUSH BC
    PUSH DE
    PUSH IX
; find the font data for the specific character
    LD HL, Font
    LD B, 0
    LD C, A             ; move character ASCII code to BC
    SLA C               ; multiply BC by 8, for 8 bytes per character font data
    RL B
    SLA C
    RL B
    SLA C
    RL B
    ADD HL, BC          ; HL points into the Fonts table at the required character
    PUSH HL             ; transfer the pointer to IX
    POP IX
 ; fill in colour data
    CALL vga_XY2addr
    PUSH HL             ; save for later to avoid havng to call vga_XY2aadr again
    LD BC, 64           ; 64 characters per line
    LD D, 8             ; 8 screen lines per character line
    LD A, (Colour)
.colloop:
    LD (HL), A          ; store colour data    
    ADD HL, BC          ; move HL to the next screen line of the same character
    DEC D
    JR NZ, .colloop
; fill in pixel data
    POP HL              ; restore the result of calling vga_XY2aadr
    LD BC, 4000h        ; 16k
    ADD HL, BC          ; get pixel data pointer
    LD BC, 64           ; 64 characters per line
    LD D, 8             ; 8 screen lines per character line
.pixloop:
    LD A, (IX)          ; load the pixel data for the character from Fonts table
    LD (HL), A
    INC IX              ; move to the next line for the character in the Fonts table
    ADD HL, BC          ; move to the next screen line in PixelData
    DEC D
    JR NZ, .pixloop
; restore register values
    POP IX
    POP DE
    POP BC
    POP HL
    RET

; gets a single character from the screen at current cursor position
; and moves the cursor over by one
; result in A
getChar:
    RET

; writes a string to the display at current cursor position
; IX - null-terminated string to write
writeStr:
    PUSH IX
.loop:
    LD A, (IX)
    CP 0   ; eol?
    JR Z, .end
    CALL putChar
    INC IX
    CALL vga_advanceCur
    JR .loop
.end:
    POP IX
    RET

; goes to the next line of the display
; if there are free lines below the current ones, goes to the next one
; if we're already in the last line, the whole display is scrolled up
nextLine:
    CALL cursorOff
    XOR A           ; LD A, 0
    LD (CurX), A ; move the cursor to the beginning of line
    LD A, (CurY) ; load current cursor Y position (line number)
    CP MAX_Y        ; if already at the bottom of the screen
    JR NC, .scroll   ; then scroll the screen
    JR Z, .scroll
    INC A           ; else move to the next line down
    LD (CurY), A
    JR .end
.scroll:
    CALL scroll
.end:
    CALL cursorOn
    RET

scroll: 
    LD A, (Scroll)
    INC A
    LD (Scroll), A
    CALL vga_setScroll
    RET

; ###################################################################################
; ########## private functions ######################################################
; ###################################################################################

vga_wrapLine:
	CALL cursorOff
    XOR A           ; LD A, 0
    LD (CurX), A ; move the cursor to the beginning of line
    LD A, (CurY) ; load current cursor Y position (line number)
    CP MAX_Y        ; if already at the bottom of the screen
	JR Z, .wrapScreen   
    INC A           ; else move to the next line down
	JR .end
.wrapScreen:
	LD A, 0
.end:
    LD (CurY), A
	RET

vga_advanceCur:
	PUSH AF
    PUSH BC
    CALL cursorOff
    LD A, (CurX)
    LD B, A         ; read in the X position
    LD A, (CurY)
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
    LD (CurX), A
    LD A, C
    LD (CurY), A
    CALL cursorOn
    POP BC
	POP AF
    RET

; returns the VRAM address for current cursor position
; this is for text mode only
; returns the address within ColourData
; add 4000h for PixelData address
; CurX - X position
; CurY - Y position
; result in HL
; destroys A
vga_XY2addr:
    LD A, (CurY)
    LD H, 0
    LD L, A         ; 16 bit cusor Y position now in HL
    XOR A           ; clear carry
    LD B, 9         ; multiply by 64 characters per character line times 8 screen lines per character line
.loop:
    SLA L           ; multiply HL by two
    RL H
    DJNZ .loop
    LD A, (CurX)    ; get the cursor X position
    LD B, A
    LD C, 0
    ADD HL, BC      ; add the cursor X position
    LD BC, ColourData
    ADD HL, BC
    RET

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

; sets the scroll value (number of the starting line in video memory)
; value in A
vga_setScroll:
    LD (Scroll), A
    OUT (SCROLL_PORT), A
    RET