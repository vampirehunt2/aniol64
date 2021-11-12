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
Echo: defb "eco", 0
UnknownCmd: defb "Unknown command", 0

PROC
cmd_main:
        CALL kbd_readLine
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
        ; Echo command
        LD IY, Echo
        CALL str_cmp
        LD A, C
        CP 0
        JR Z, _echo
        ; unknown command
        LD IX, UnknownCmd
        CALL lcd_wriStr
        JP cmd_main
_clr:
        CALL lcd_clrScr
        CALL lcd_home
        JP cmd_main
_rst:
        RST 00h
        JP cmd_main

_echo:
        JP cmd_main
;
        RET
ENDP
