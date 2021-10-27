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
LINE1 equ 00d
LINE2 equ 40d
LINE3 equ 20d
LINE4 equ 60d

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

; writes a null-terminated string to the LCD screen
; IX: address of the string
lcd_wriStr:
        LD C, LCD_DAT_WR
loop_wriStr:
        CALL lcd_wait
        LD A,(IX+0)
        CP 0                                  ;
        RET Z
        OUT (C),A
        INC IX
        JR loop_wriStr
        RET

lcd_clrScr:
        CALL lcd_wait
        LD C, LCD_CMD_WR
        LD A, 01h
        OUT (C), A
        RET

lcd_home:
        LD C, LCD_CMD_WR
        LD A, 02h
        OUT (C), A
        RET

lcd_cursorLShift:
        LD C, LCD_CMD_WR
        LD A, 00010000b
        OUT (C), A
        RET

lcd_cursorRShift:
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
        JP lcd_setCursorPos
lcd_gotoLn2:
        LD A, LINE2
        JP lcd_setCursorPos
lcd_gotoLn3:
        LD A, LINE3
        JP lcd_setCursorPos
lcd_gotoLn4:
        LD A, LINE4
        JP lcd_setCursorPos ; redundant, but more clear this way
; sets cursor position.
; A - cursor position on lower 7 bits
lcd_setCursorPos:
        OR 10000000b ; setting bit DB7 which indicates write to DDRAM address
        PUSH AF      ; lcd_wait uses A register, so we need to save our value to stack
        CALL lcd_wait
        POP AF
        LD C, LCD_CMD_WR
        OUT (C), A
        RET

; checks the BUSY flag (D7) of the lcd display
; and loops until it's not busy.
lcd_wait:
        IN A, (LCD_CMD_RD)
        AND BUSY_MASK
        CP 0 ;TODO probably redundant
        RET Z
        JP lcd_wait
