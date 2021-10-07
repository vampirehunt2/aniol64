;----------------------------------------------------
; Project: aniol64.zdsp
; File: lcd.asm
; Date: 8/26/2021 13:43:57
;
; Created with zDevStudio - Z80 Development Studio.
;
; Handling of hd44780 LCD display controller
;----------------------------------------------------

LCD_CMD_WR equ 11110100b ; write command port of the LCD
LCD_DAT_WR equ 11110101b ; write data port of the LCD
LCD_CMD_RD equ 11110110b ; read command port of the LCD
LCD_DAT_RD equ 11110111b ; read data port of the LCD
BUSY_MASK  equ 10000000b

; checks the BUSY flag (D7) of the lcd display
; and loops until it's not busy.
lcd_wait:
        IN A, (LCD_CMD_RD)
        AND BUSY_MASK
        CP 0
        RET Z
        JP lcd_wait

; resets the LCD display
lcd_init:
        CALL lcd_wait
        LD C, LCD_CMD_WR
        LD A, 00001111b ; init: set display on, cursor on, blinking on
        OUT (C), A
        CALL lcd_wait
        LD A, 00111000b ; set data length: 8b, 2 lines
        OUT (C), A
        RET

; writes a null-terminated string to the LCD screen
; IX: address of the string
lcd_wriStr:
        LD C, LCD_DAT_WR
loop_wriStr:
        CALL lcd_wait
        LD A,(IX+0)
        CP 0
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

lcd_resetCursorPos:
        LD C, LCD_CMD_WR
        LD A, 02h
        OUT (C), A
        RET

lcd_cursorLShift:
        LD C, LCD_CMD_WR
        LD A, 04h
        OUT (C), A
        RET

lcd_cursorRShift:
        LD C, LCD_CMD_WR
        LD A, 06h
        OUT (C), A
        RET

lcd_screenRShift:
        LD C, LCD_CMD_WR
        LD A, 05h
        OUT (C), A
        RET

lcd_screenLShift:
        LD C, LCD_CMD_WR
        LD A, 07h
        OUT (C), A
        RET


