; The driver for the colour VGA card
; See card schematic at https://forum-trioda.pl/download/file.php?id=112365
; Native VGA signal is 640x480x60Hz, but logical pixels are 2x2 phyical pixels.
; Therefore the effective resolution is therefore 320x240.
;
; The below driver implements a text mode with 80x30 4x8 characters, which is a subset of the card's capabilities.
; A font is included, but own font can be supplied by storing it in the RAM and pointing (FontAddr) to it.
; There are 3 bits per colour, 8 colours available.
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


;BaseAddr equ 0000h
;Offset equ 128 ; skipping the first 2 lines of display that are skewed.
;MemSize equ 4000h

BaseAddr equ 0000h
;Offset equ 128 ; skipping the first 2 lines of display that are skewed.
MemSize equ 4000h


; Image memory addresses.
; These overlap the system ROM.
; ROM is accessed on read operations, and image memory on writes.

ColourData equ BaseAddr; + Offset
PixelData equ ColourData + MemSize


; Constants
MAX_X equ 79
MAX_Y equ 29
LF    equ 10
CR	  equ 13

SCROLL_PORT equ 11011111b   ; scroll register activated by A5

Blank:		defs 80, " "
            defb 0

Font: 
 incbin dev/4x7block.fnt

dspInit:
    LD HL, Font         ; load predefined font address
    LD (FontAddr), HL   ; put it in the FontAddr, so that it can be redefined later
    XOR A               ; LD A, 0
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
    LD BC, MemSize * 2  ; total size of colour and pixel data
.loop:
    XOR A
    LD (HL), A
    INC HL
    DEC BC
    LD A, B
    OR C
    JR NZ, .loop        ; zero out both colour and pixel data 
    CALL home           ; move the cursor to 0, MAX_Y   
    ; restore register values
    POP BC
    POP HL
    RET

; turns off the cursor for the character at the current cursor position
cursorOff:
    LD A, FALSE
    LD (Cursor), A
    CALL vga_toggleCursor
    RET

; turns on the cursor for the character at the current cursor position
cursorOn:
    LD A, TRUE
    LD (Cursor), A
    CALL vga_toggleCursor
    RET


writeLn:
	CALL writeStr
	CALL nextLine
	RET

; not implemented. This text mode only supports sequential character output.
gotoXY:
    RET
		
cursorLShift:
    LD A, 127   ; DEL character in ASCII
    CALL putChar
	RET

; puts a single character on the screen
; and moves the cursor over by one
; A - character to be written
putChar:
    LD B, A
    LD A, (CurX)
    AND 00000001b
    JR NZ, .odd
.even:
    LD A, B
    JP putEvenChar
.odd:
    LD A, B
    JP putOddChar
    
putEvenChar:
; save register values
    PUSH HL
    PUSH BC
    PUSH DE
    PUSH IX
    LD E, A
    LD (PrevChar), A
    CALL vga_findFont
    PUSH HL             ; transfer the pointer to IX
    POP IX
    CALL vga_XY2addr
; fill in pixel data
    PUSH HL             ; store the result of calling vga_XY2aadr
    LD BC, MemSize       
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
; fill in colour data
    POP HL              ; restore the result of calling vga_XY2aadr
    LD BC, 64           ; 64 characters per line
    LD D, 8             ; 8 screen lines per character line
    LD A, GREEN * 16
.colloop:
    LD (HL), A          ; store colour data    
    ADD HL, BC          ; move HL to the next screen line of the same character
    DEC D
    JR NZ, .colloop
; restore register values
    CALL vga_advanceCur
    LD A, E
    POP IX
    POP DE
    POP BC
    POP HL
    RET


putOddChar:
; save register values
    PUSH HL
    PUSH BC
    PUSH DE
    PUSH IX
    PUSH IY
    LD E, A
    CALL vga_findFont
    PUSH HL
    POP IX              ; transfer the pointer to current character font data to IX
    LD A, (PrevChar)
    CALL vga_findFont
    PUSH HL             ; transfer the pointer to previous character font data IY
    POP IY
    CALL vga_XY2addr
; fill in pixel data
    LD BC, MemSize      
    ADD HL, BC          ; get pixel data pointer
    LD BC, 64           ; 64 characters per line
    LD D, 8             ; 8 screen lines per character line
.pixloop:
    LD A, (IY)          ; load the pixel data for the previous character from Fonts table
    LD E, A
    LD A, (IX)          ; load the pixel data for the current character from Fonts table
    SRL A
    SRL A
    SRL A
    SRL A               ; shift the font data over to the odd character position
    OR E
    LD (HL), A
    INC IX              ; move to the next line for the current character in the Fonts table
    INC IY              ; move to the next line for the previous character in the Fonts table
    ADD HL, BC          ; move to the next screen line in PixelData
    DEC D
    JR NZ, .pixloop
; restore register values
    CALL vga_advanceCur
    LD A, E
    POP IY
    POP IX
    POP DE
    POP BC
    POP HL
    RET

; gets a single character from the screen at current cursor position
; and moves the cursor over by one
; result in A
getChar:
    ; not implemented
    XOR A
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
; the whole display is scrolled up
nextLine:
    CALL cursorOff
    XOR A           ; LD A, 0
    LD (CurX), A    ; move the cursor to the beginning of line
    CALL scroll
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
    LD A, (CurX)
    CP MAX_X
    JR Z, .wrapLine
    INC A
    LD (CurX), A
    RET
.wrapLine:
    XOR A
    LD (CurX), A
    CALL scroll
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
    LD HL, ColourData + MAX_Y * 64 * 8
    LD A, (CurX)    ; get the cursor X position
    SRL A           ; divide by two, as there are two characters per byte
    LD C, A
    LD B, 0
    ADD HL, BC      ; add the cursor X position
    RET

; checks whether screen coordinates are within the visible area [0..79, 0..29]
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

vga_toggleCursor:
    PUSH BC
    PUSH HL
    CALL vga_XY2addr
    LD BC, 7 * 64   ; only draw the cursor in the last line
    ADD HL, BC
    LD BC, MemSize
    ADD HL, BC
    LD A, (Cursor)  ; check if cursor is supposed to be drawn
    CP TRUE            
    JR Z, .on       
    LD A, 00000000b
    LD (HL), A
    JR .end
.on:
    LD A, (CurX)
    AND 00000001b
    JR Z, .even
    LD A, 00001111b
    LD (HL), A
    JR .end
.even:
    LD A, 11110000b
    LD (HL), A
.end:
    POP HL
    POP BC
	RET

; find the font data for the specific character
; character in A
vga_findFont:
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
    RET
