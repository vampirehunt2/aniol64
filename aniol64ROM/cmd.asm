;----------------------------------------------------
; Project: aniol64.zdsp
; File: cmd.asm
; Date: 11/12/2021 9:53:48
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------

Clr: defb "cl", 0
Mon: defb "mon", 0
Clk: defb "clk", 0
Reset: defb "rst", 0
Echo: defb "eco", 0
UnknownCmd: defb "Unknown command", 0

PROC
defb "cmd_main"
cmd_main:
        CALL kbd_readLine
        CALL lcd_nextLine
        LD IX, LineBuff
        ; clear screen command
        LD IY, Clr
        CALL str_cmp
        LD A, C
        CP 0
        JR Z, _clr
        ; reset command
        LD IY, Reset
        CALL str_cmp
        LD A, C
        CP 0
        JR Z, _rst
        ; echo command
        LD IY, Echo
        CALL str_cmp
        LD A, C
        CP 0
        JR Z, _echo
        ; unknown command
        LD IX, UnknownCmd
        CALL lcd_wriStr
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
        JP _wrap
;
        RET
ENDP
