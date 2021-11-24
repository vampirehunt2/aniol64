;----------------------------------------------------
; Project: aniol64.zdsp
; File: mon.asm
; Date: 9/22/2021 13:36:12
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------

St: defb "set", 0
Dsp: defb "dsp", 0
Bye: defb "bye", 0
Exit: defb "Exiting...", 0
ParseErr: defb "Parse error", 0

PROC
mon_main:
        LD A, 0
        LD (MonCurrAddrL), A
        LD (MonCurrAddrH), A
        CALL mon_dsp
_loop:
        CALL lcd_gotoLn4
        CALL cmd_readLn
        CALL str_tok
        ; dsp command
        LD IX, LineBuff
        LD IY, Dsp
        CALL str_cmp
        CP 0
        JR Z, _dsp
        JR _loop
        ; set command
        LD IX, LineBuff
        LD IY, St
        CALL str_cmp
        CP 0
        JR Z, _set
        ; unknown command
        LD IX, UnknownCmd
        CALL lcd_gotoLn4
        CALL lcd_wriStr
        JR _loop
_dsp:
        CALL mon_dsp
        JR _loop
_set:
        CALL mon_set
        JR _loop
_bye:
        LD IX, Exit
        CALL lcd_wriStr
        RET
ENDP

PROC
mon_dsp:
        CALL lcd_hideCursor
        LD A, (MonCurrAddrH)
        LD B, A
        LD A, (MonCurrAddrL)
        LD C, A
        PUSH BC
        POP HL                 ; puts the current mon address in HL
        CALL lcd_gotoLn1
        CALL mon_printAddrs
        CALL mon_printVals
        CALL lcd_gotoLn2
        CALL mon_printAddrs
        CALL mon_printVals
        CALL lcd_gotoLn3
        CALL mon_printAddrs
        CALL mon_printVals
        CALL lcd_gotoLn4
        CALL lcd_showCursor
        RET
ENDP

PROC
mon_set:
        RET
ENDP

mon_printAddrs:
        PUSH HL
        POP IX
        CALL mon_printDByte
        LD A, '-'
        CALL lcd_putChar
        INC IX
        INC IX
        INC IX
        INC IX
        CALL mon_printLByte
        LD A, ":"
        CALL lcd_putChar
        LD A, " "
        CALL lcd_putChar
        RET

mon_printVals:
        PUSH HL
        POP IX
        CALL mon_printByte
        LD A, " "
        CALL lcd_putChar
        INC IX
        CALL mon_printByte
        LD A, " "
        CALL lcd_putChar
        INC IX
        CALL mon_printByte
        LD A, " "
        CALL lcd_putChar
        INC IX
        CALL mon_printByte
        RET

mon_printByte:
        LD A, (IX + 0)
        CALL byte2asc
        PUSH AF
        LD A, B
        CALL lcd_putChar
        POP AF
        CALL lcd_putChar
        RET

; prints the value of a double byte stored in IX to the lcd screen
; IX - the value of the double byte to print
mon_printDByte:
        PUSH IX
        POP DE
        LD A, D
        CALL byte2asc
        PUSH AF
        LD A, B
        CALL lcd_putChar
        POP AF
        CALL lcd_putChar
        LD A, E
        CALL byte2asc
        PUSH AF
        LD A, B
        CALL lcd_putChar
        POP AF
        CALL lcd_putChar
        RET

; prints the value the lower byte of IX to the lcd screen
; IX - the value of the double byte to print
mon_printLByte
        PUSH IX
        POP DE
        LD A, E
        CALL byte2asc
        PUSH AF
        LD A, B
        CALL lcd_putChar
        POP AF
        CALL lcd_putChar
        RET






