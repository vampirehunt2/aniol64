;----------------------------------------------------
; Project: aniol64.zdsp
; File: lcd.asm
; Date: 8/26/2021 13:43:57
;
; Created with zDevStudio - Z80 Development Studio.
;
; Handling of hd44780 LCD display controller
;----------------------------------------------------

; LCD display is selected with A3
LCD_CMD_WR equ 11110100b ; write command port of the LCD
LCD_DAT_WR equ 11110101b ; write data port of the LCD
LCD_CMD_RD equ 11110110b ; read command port of the LCD
LCD_DAT_RD equ 11110111b ; read data port of the LCD

BUSY_MASK  equ 10000000b
DDRAM_MASK equ 01111111b

; starting DDRAM addresses for physical display lines
; note, logical lines don't match the order of physical lines
LINE1 equ 00h
LINE2 equ 40h
LINE3 equ 14h
LINE4 equ 54h
BlankLine: defb "                    ", 0

; resets the LCD display
lcd_init:
        LD C, LCD_CMD_WR
        LD A, 00001111b ; init: set display on, cursor on, blinking on
        OUT (C), A
        CALL delay10ms
        LD A, 00111000b ; set data length: 8b, 2 lines
        OUT (C), A
        CALL delay10ms
        RET

lcd_hideCursor:
        CALL lcd_wait
        LD C, LCD_CMD_WR
        LD A, 00001100b
        OUT (C), A
        RET

lcd_showCursor:
        CALL lcd_wait
        LD C, LCD_CMD_WR
        LD A, 00001111b
        OUT (C), A
        RET

; writes a null-terminated string to the LCD screen
; IX: address of the string
PROC
lcd_wriStr:
        LD C, LCD_DAT_WR
_loop:
        CALL lcd_wait
        LD A,(IX+0)
        CP 0                                  ;
        RET Z
        OUT (C),A
        INC IX
        JR _loop
        RET
ENDP

; puts a single character on the screen
; A - character to be written
lcd_putChar:
        LD C, LCD_DAT_WR
        PUSH AF
        CALL lcd_wait
        POP AF
        OUT (C), A
        RET

; gets a single character from the screen at current cursor position
; and moves the cursor over by one
; result in A
lcd_getChar:
        LD C, LCD_DAT_RD
        CALL lcd_wait
        IN A, (C)
        RET

; clears the screen
lcd_clrScr:
        CALL lcd_wait
        LD C, LCD_CMD_WR
        LD A, 01h
        OUT (C), A
        RET

; moves the cursor to the first position
lcd_home:
        CALL lcd_wait
        LD C, LCD_CMD_WR
        LD A, 02h
        OUT (C), A
        RET

; shifts cursor left by one position
lcd_cursorLShift:
        CALL lcd_wait
        LD C, LCD_CMD_WR
        LD A, 00010000b
        OUT (C), A
        RET

; shifts cursor right by one position
lcd_cursorRShift:
        CALL lcd_wait
        LD C, LCD_CMD_WR
        LD A, 00010100b
        OUT (C), A
        RET

; reads the current cursor position
; result in A
lcd_getPos:
        CALL lcd_wait
        IN A, (LCD_CMD_RD)
        AND DDRAM_MASK
        RET

; moves cursor to the beginning of a line
; line number in A
lcd_gotoLn:
        CP 1
        JR Z, lcd_gotoLn1
        CP 2
        JR Z, lcd_gotoLn2
        CP 3
        JR Z, lcd_gotoLn3
        CP 4
        JR Z, lcd_gotoLn4   ; TODO: for some reason this doesn't work
        RET   ; if line number is not 1-4, do nothing
lcd_gotoLn1:
        LD A, LINE1
        JP lcd_setPos
lcd_gotoLn2:
        LD A, LINE2
        JP lcd_setPos
lcd_gotoLn3:
        LD A, LINE3
        JP lcd_setPos
lcd_gotoLn4:
        LD A, LINE4
        JP lcd_setPos ; redundant, but more clear this way
; sets cursor position.
; A - cursor position on lower 7 bits
lcd_setPos:
        OR 10000000b ; setting bit DB7 which indicates write to DDRAM address
        PUSH AF      ; lcd_wait uses A register, so we need to save our value to stack
        CALL lcd_wait
        POP AF
        LD C, LCD_CMD_WR
        OUT (C), A
        RET

; reads a particular line from the display
; line number in A
; result in LcdBuff
PROC
lcd_readLn:
        CALL lcd_gotoLn
        LD IX, LcdBuff
        LD B, 20
_loop:
        CALL lcd_getChar
        LD (IX+0), A
        INC IX
        DJNZ _loop
        LD A, 0
        LD (IX+0), A
        RET
ENDP

; gets the physical line in which the cursor is
; result in A
PROC
lcd_getCurrentLine:
        CALL lcd_getPos
        CP LINE3
        JR C, _line1
        CP LINE2
        JR C, _line3
        CP LINE4
        JR C, _line2
_line4:
        LD A, 4
        RET
_line1:
        LD A, 1
        RET
_line3:
        LD A, 3
        RET
_line2:
        LD A, 2
        RET
ENDP

PROC
lcd_nextLine:
        CALL lcd_getCurrentLine
        CP 1
        JP Z, lcd_gotoLn2
        CP 2
        JP Z, lcd_gotoLn3
        CP 3
        JP Z, lcd_gotoLn4
        ;CP 4
        CALL lcd_scroll
        RET
ENDP

lcd_scroll:
        CALL lcd_hideCursor
        LD A, 2
        CALL lcd_readLn
        CALL lcd_gotoLn1
        LD IX, LcdBuff
        CALL lcd_wriStr
        LD A, 3
        CALL lcd_readLn
        CALL lcd_gotoLn2
        LD IX, LcdBuff
        CALL lcd_wriStr
        LD A, 4
        CALL lcd_readLn
        CALL lcd_gotoLn3
        LD IX, LcdBuff
        CALL lcd_wriStr
        CALL lcd_gotoLn4
        LD IX, BlankLine
        CALL lcd_wriStr
        CALL lcd_gotoLn4
        CALL lcd_showCursor
        RET


; checks the BUSY flag (D7) of the lcd display
; and loops until it's not busy.
lcd_wait:
        IN A, (LCD_CMD_RD)
        AND BUSY_MASK
        CP 0 ;TODO probably redundant
        RET Z
        JP lcd_wait
