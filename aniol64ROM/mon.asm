;----------------------------------------------------
; Project: aniol64.zdsp
; File: mon.asm
; Date: 9/22/2021 13:36:12
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------

St: defb "set", 0
Adr: defb "adr", 0
Bye: defb "bye", 0
Nxt: defb "nxt", 0
Exit: defb "Exiting...", 0
ParseErr: defb "Parse error", 0
InvAddr: defb "Invalid address", 0

PROC
mon_main:
        LD A, 0
        LD (MonCurrAddr), A
        LD (MonCurrAddr + 1), A
        CALL mon_dsp
_loop:
        CALL mon_blank
        CALL kbd_readLine
        LD IX, LineBuff
        CALL str_tok
        ; dsp command
        LD IX, LineBuff
        LD IY, Adr
        CALL str_cmp
        CP 0
        JR Z, _adr
        ; nxt command
        LD IX, LineBuff
        LD IY, Nxt
        CALL str_cmp
        CP 0
        JR Z, _nxt
        ; set command
        LD IX, LineBuff
        LD IY, St
        CALL str_cmp
        CP 0
        JR Z, _set
        ; bye command
        LD IX, LineBuff
        LD IY, Bye
        CALL str_cmp
        CP 0
        JR Z, _bye
        ; unknown command
        LD IX, UnknownCmd
        CALL lcd_gotoLn4
        CALL lcd_wriStr
        JR _loop
_adr:
        CALL mon_adr
        JR _loop
_set:
        CALL mon_set
        JR _loop
_nxt:
        CALL mon_nextPage
        JR _loop
_bye:
        LD IX, Exit
        CALL lcd_wriStr
        RET
ENDP

PROC
mon_dsp:
        CALL lcd_hideCursor
        LD HL, (MonCurrAddr)              ; puts the current mon address in HL
        CALL lcd_gotoLn1
        CALL mon_printAddrs
        CALL mon_printVals
        CALL lcd_gotoLn2
        CALL mon_nextAddrs
        CALL mon_printAddrs
        CALL mon_printVals
        CALL lcd_gotoLn3
        CALL mon_nextAddrs
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

; prints the addresses for a single line of output of the dsp command
; the first address in is HL
mon_printAddrs:
        PUSH HL
        POP IX
        CALL mon_printDByte
        LD A, '-'
        CALL lcd_putChar
        INC IX
        INC IX
        INC IX
        CALL mon_printLByte
        LD A, ":"
        CALL lcd_putChar
        LD A, " "
        CALL lcd_putChar
        RET

; prints the values for a single line of output of the dsp command
; the first address in is HL
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

mon_nextAddrs:
        INC HL
        INC HL
        INC HL
        INC HL
        RET

mon_nextPage:
        LD HL, (MonCurrAddr)
        CALL mon_nextAddrs
        CALL mon_nextAddrs
        CALL mon_nextAddrs
        LD (MonCurrAddr), HL
        CALL mon_dsp
        RET

PROC
mon_adr:
        PUSH HL
        POP IX  ; setting IX to point to the argument of the adr command
        CALL parseDByte
        CP 0
        JR NZ, _parseError
        LD (MonCurrAddr), HL
        CALL mon_dsp
        RET
_parseError:
        CALL lcd_gotoLn4
        LD IX, InvAddr
        CALL lcd_wriStr
        CALL kbd_readKey
        CALL mon_blank
        RET
ENDP

mon_blank:
        CALL lcd_gotoLn4
        LD IX, BlankLine
        CALL lcd_wriStr
        CALL lcd_gotoLn4
        RET





