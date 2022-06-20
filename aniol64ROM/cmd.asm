;----------------------------------------------------
; Project: aniol64.zdsp
; File: cmd.asm
; Date: 11/12/2021 9:53:48
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------
 
Clr: 		defb "clr", 0
Mon: 		defb "mon", 0
Reset: 		defb "rst", 0
EchoCmd:	defb "echo", 0
Rnd: 		defb "rnd", 0
Peek: 		defb "peek", 0
Poke: 		defb "poke", 0
Put: 		defb "put", 0
Get:		defb "get", 0
Beep: 		defb "beep", 0
Term: 		defb "term", 0
DiskInfo: 	defb "di", 0
DiskDiag:	defb "dd", 0
Test:		defb "test", 0
Snake:		defb "snake", 0
Onp:		defb "onp", 0
UnknownCmd: defb "Unknown cmd", 0
Prompt: 	defb ">", 0

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
        LD IY, EchoCmd
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
		; get command
		LD IX, LineBuff
		LD IY, Get
		CALL str_cmp
		CP 0
		JP Z, _get
        ; beep command
        LD IX, LineBuff
        LD IY, Beep
        CALL str_cmp
        CP 0
        JP Z, _beep
		; term program
		LD IX, LineBuff
		LD IY, Term
		CALL str_cmp
		CP 0
		JP Z, term_main
		; disk info
		LD IX, LineBuff
		LD IY, DiskInfo
		CALL str_cmp
		CP 0
		JP Z, _di
		; disk info
		LD IX, LineBuff
		LD IY, DiskDiag
		CALL str_cmp
		CP 0
		JP Z, _dd
		; test command
		LD IX, LineBuff
		LD IY, Test
		CALL str_cmp
		CP 0
		JP Z, _test
		; snake 
		LD IX, LineBuff
		LD IY, Snake
		CALL str_cmp
		CP 0
		JP Z, snake_main
		; onp 
		LD IX, LineBuff
		LD IY, Onp
		CALL str_cmp
		CP 0
		JP Z, _onp
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
_get:
		PUSH HL
		POP IX
		CALL mon_get
		JP _wrap
_beep:
        CALL bzr_beep
        JP cmd_main
_rnd:
        CALL rnd
        CALL byte2asc
        PUSH AF
        LD A, B
        CALL vga_putChar
        POP AF
        CALL vga_putChar
        JP _wrap
_di:
		CALL dos_cfDiskInfo
		JP _wrap
_dd:	
		CALL cf_diag
		CALL mon_printByteA
		JP _wrap
_test:
		CALL test_main
		JP cmd_main
_mon:
        CALL mon_main
        JP _wrap
        RET
_onp:
		PUSH HL
		POP IX
		CALL onp_main
		JP cmd_main
ENDP

cmd_readLn:
        CALL kbd_readLine
        CALL vga_nextLine
        LD IX, LineBuff
        RET
