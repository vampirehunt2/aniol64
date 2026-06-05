; The driver for the colour VGA card
; See card schematic at https://forum-trioda.pl/download/file.php?id=112365
; Native VGA signal is 640x480x60Hz, but logical pixels are 2x2 phyical pixels.
; Therefore the effective resolution is therefore 320x240.
;
; The below driver implements a text mode with 40x30 8x8 characters, which is a subset of the card's capabilities.
; A font is included, but own font can be supplied by storing it in the RAM and pointing (FontAddr) to it.
; There are 4 bits per colour, but only 12 colours available. The remaining 4 are repeats.
; A foreground and a background colour can be specified for each character.
;
; Cursor is handled programmaticaly by the driver. 
; Scrolling is done by utilising the hardware scrolling feature of the card.
; Currently, getChar is not implemented.


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

; Image memory addresses.
; These overlap the system ROM.
; ROM is accessed on read operations, and image memory on writes.
PixelData equ 4000h + 512   ; + 512 is for skipping the first line of display that are skewed.
ColourData equ 0000h + 512

; Constants
MAX_X equ 39
MAX_Y equ 28
LF    equ 10
CR	  equ 13

SCROLL_PORT equ 11011111b   ; scroll register activated by A5

Blank:		defb "                                      ", 0

Font: 
 incbin dev/eightbb.fnt

dspInit:
    LD HL, Font         ; load predefined font address
    LD (FontAddr), HL   ; put it in the FontAddr, so that it can be redefined later
    LD A, 0
    CALL vga_setScroll
    LD A, 0F0h
    LD (Colour), A
    LD A, TRUE
    LD (Cursor), A
    CALL clrScr
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
    ; clear colour and pixel data
    LD HL, ColourData
    LD BC, 8000h - 512   ; total size of colour and pixel data
.loop:              ; iterates through both colour and pixel data
    XOR A           ; LD A, 0
    LD (HL), A
    INC HL
    DEC BC
    LD A, B
    OR C
    JR NZ, .loop
    ; 
    CALL home       ; move the cursor to 0,0   
    ; restore register values
    POP BC
    POP HL
    RET

; turns off the cursor for the character at the current cursor position
cursorOff:
    PUSH BC
    PUSH HL
    CALL vga_XY2addr
    LD BC, 7 * 64   ; only draw the cursor in the last line
    ADD HL, BC         
    LD A, (Colour)  ; load the current colour
    LD (HL), A
    POP HL
    POP BC    
    RET

; turns on the cursor for the character at the current cursor position
cursorOn:
    LD A, (Cursor)
    CP FALSE
    RET Z
    PUSH BC
    PUSH HL
    CALL vga_XY2addr
    LD BC, 7 * 64   ; only draw the cursor in the last line
    ADD HL, BC         
    LD A, (Colour)  ; load the current colour
    CPL             ; invert it
    LD (HL), A
    POP HL
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
    LD E, A
; find the font data for the specific character
    LD HL, (FontAddr)
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
    CALL vga_advanceCur
    LD A, E
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
    LD (CurX), A    ; move the cursor to the beginning of line
    LD A, (CurY)    ; load current cursor Y position (line number)
    CP MAX_Y        ; if already at the bottom of the screen
    JR NC, .scroll  ; then scroll the screen
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
    ; store register values
    PUSH HL
    PUSH BC
    ; scroll the display using hardware scrolling
    LD A, (Scroll)
    ADD A, 4    ; scroll by 4 doublelines, i.e. one character line
    LD (Scroll), A
    CALL vga_setScroll
    ; clear the last line's colour data
    LD HL, ColourData + MAX_Y * 64 * 8
    LD BC, 8 * 64   ; 8 lines per character times 64 characters
.loop:
    XOR A           ; LD A, 0
    LD (HL), A
    INC HL
    DEC BC
    LD A, B 
    OR C
    JR NZ, .loop
    ; clear the last line's pixel data
    LD HL, PixelData + MAX_Y * 64 * 8
    LD BC, 8 * 64 ; beginning of the last chracter line of pixel data
.loop1:
    XOR A           ; LD A, 0
    LD (HL), A
    INC HL
    DEC BC
    LD A, B 
    OR C
    JR NZ, .loop1  
    ; restore register values
    POP BC
    POP HL
    RET

; ###################################################################################
; ########## private functions ######################################################
; ###################################################################################


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
    JR C, .scroll
    JR .end
.scroll:
    DEC C         ; move the cursor back to last line
    ;CALL scroll
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
    LD C, A
    LD B, 0
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
