;----------------------------------------------------
; Project: aniol64.zdsp
; File: cmd.asm
; Date: 11/12/2021 9:53:48
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------

Clr: defb "clr", 0
Mon: defb "mon", 0
Clk: defb "clk", 0
Reset: defb "rst", 0
Echo: defb "echo", 0
Rnd: defb "rnd", 0
Peek: defb "peek", 0
UnknownCmd: defb "Unknown cmd", 0

PROC
defb "cmd_main"
cmd_main:
        CALL cmd_readLn
        CALL str_tok
        ; clear screen command
        LD IX, LineBuff
        LD IY, Clr
        CALL str_cmp
        CP 0
        JR Z, _clr
        ; reset command
        LD IX, LineBuff
        LD IY, Reset
        CALL str_cmp
        CP 0
        JR Z, _rst
        ; echo command
        LD IX, LineBuff
        LD IY, Echo
        CALL str_cmp
        CP 0
        JR Z, _echo
        ; rnd command
        LD IX, LineBuff
        LD IY, Rnd
        CALL str_cmp
        CP 0
        JR Z, _rnd
        ; monitor program
        LD IX, LineBuff
        LD IY, Mon
        CALL str_cmp
        CP 0
        JR Z, _mon
        ; peek command
        LD IX, LineBuff
        LD IY, Peek
        CALL str_cmp
        CP 0
        JR Z, _peek
        ; unknown command
        LD IX, UnknownCmd
        CALL lcd_wriStr
        CALL bzr_beep
_wrap:
        CALL lcd_nextLine
        JP cmd_main
_clr:
        CALL lcd_clrScr
        CALL lcd_home
        JP cmd_main
_rst:
        RST 00h
        JP _wrap
_echo:
        PUSH HL
        POP IX
        CALL lcd_wriStr
        JP _wrap
_peek:
        PUSH HL
        POP IX
        CALL mon_peek
        JP _wrap
_rnd:
        CALL rnd
        CALL byte2asc
        PUSH AF
        LD A, B
        CALL lcd_putChar
        POP AF
        CALL lcd_putChar
        JP _wrap
_mon:
        CALL mon_main
        JP _wrap
        RET
ENDP

cmd_readLn:
        CALL kbd_readLine
        CALL lcd_nextLine
        LD IX, LineBuff
        RET
