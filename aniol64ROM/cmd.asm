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
Poke: defb "poke", 0
Put: defb "put", 0
Beep: defb "beep", 0
UnknownCmd: defb "Unknown cmd: ", 0
Prompt: defb ">", 0

PROC
cmd_main:
		LD IX, Prompt
		CALL vga_wriStr
		CALL vga_curOn
        CALL cmd_readLn
        CALL str_tok
        ; clear screen command
        LD IX, LineBuff
        LD IY, Clr
        CALL str_cmp
        CP 0
        JP Z, _clr
        ; reset command
        LD IX, LineBuff
        LD IY, Reset
        CALL str_cmp
        CP 0
        JP Z, _rst
        ; echo command
        LD IX, LineBuff
        LD IY, Echo
        CALL str_cmp
        CP 0
        JP Z, _echo
        ; rnd command
        LD IX, LineBuff
        LD IY, Rnd
        CALL str_cmp
        CP 0
        JP Z, _rnd
        ; monitor program
        LD IX, LineBuff
        LD IY, Mon
        CALL str_cmp
        CP 0
        JP Z, _mon
        ; peek command
        LD IX, LineBuff
        LD IY, Peek
        CALL str_cmp
        CP 0
        JP Z, _peek
        ; poke command
        LD IX, LineBuff
        LD IY, Poke
        CALL str_cmp
        CP 0
        JP Z, _poke
        ; put command
        LD IX, LineBuff
        LD IY, Put
        CALL str_cmp
        CP 0
        JP Z, _put
        ; beep command
        LD IX, LineBuff
        LD IY, Beep
        CALL str_cmp
        CP 0
        JP Z, _beep
        ; unknown command
        LD IX, UnknownCmd
        CALL vga_wriStr
        CALL bzr_beep
_wrap:
		CALL vga_nextLine
		JP cmd_main
_clr:
        CALL vga_clrScr
        CALL vga_home
        JP cmd_main
_rst:
        RST 00h
_echo:
        PUSH HL
        POP IX
        CALL vga_writeLn
        JP cmd_main
_peek:
        PUSH HL
        POP IX
        CALL mon_peek
        JP _wrap
_poke:
        PUSH HL
        POP IX
        CALL mon_poke
        JP cmd_main
_put:
        PUSH HL
        POP IX
        CALL mon_put
        JP cmd_main
_beep:
        CALL bzr_beep
        JP _wrap
_rnd:
        CALL rnd
        CALL byte2asc
        PUSH AF
        LD A, B
        CALL vga_putChar
        POP AF
        CALL vga_putChar
        JP _wrap
_mon:
        CALL mon_main
        JP _wrap
        RET
ENDP

cmd_readLn:
        CALL kbd_readLine
        CALL vga_nextLine
        LD IX, LineBuff
        RET
