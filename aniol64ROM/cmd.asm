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
Load: 		defb "load", 0
Save:		defb "save", 0
Beep: 		defb "beep", 0
Term: 		defb "term", 0
DiskInfo: 	defb "di", 0
DiskDiag:	defb "dd", 0
Test:		defb "test", 0
Snake:		defb "snake", 0
Onp:		defb "onp", 0
; DOS commands
Pwd:		defb "pwd", 0
Ls:			defb "ls", 0
MkDir:		defb "mkdir", 0
RmDir:		defb "rmdir", 0

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
        JP Z, _clr
        ; reset command
        LD IY, Reset
        CALL str_cmp
        JP Z, _rst
        ; echo command
        LD IY, EchoCmd
        CALL str_cmp
        JP Z, _echo
        ; rnd command
        LD IY, Rnd
        CALL str_cmp
        JP Z, _rnd
        ; monitor program
        LD IY, Mon
        CALL str_cmp
        JP Z, _mon
        ; peek command
        LD IY, Peek
        CALL str_cmp
        JP Z, _peek
        ; poke command
        LD IY, Poke
        CALL str_cmp
        JP Z, _poke
        ; put command
        LD IY, Put
        CALL str_cmp
        JP Z, _put
		; get command
		LD IY, Get
		CALL str_cmp
		JP Z, _get
		; load command
		LD IY, Load
		CALL str_cmp
		JP Z, _load
		; save command
		LD IY, Save
		CALL str_cmp
		JP Z, _save
        ; beep command
        LD IY, Beep
        CALL str_cmp
        JP Z, _beep
		; term program
		LD IY, Term
		CALL str_cmp
		JP Z, term_main
		; disk info
		LD IY, DiskInfo
		CALL str_cmp
		JP Z, _di
		; disk info
		LD IY, DiskDiag
		CALL str_cmp
		JP Z, _dd
		; test command
		LD IY, Test
		CALL str_cmp
		JP Z, _test
		; snake 
		LD IY, Snake
		CALL str_cmp
		JP Z, snake_main
		; onp 
		LD IY, Onp
		CALL str_cmp
		JP Z, _onp
		; pwd command
		LD IY, Pwd
		CALL str_cmp
		JP Z, _pwd     
		; ls command
		LD IY, Ls
		CALL str_cmp
		JP Z, _ls
		; mkdir command
		LD IY, MkDir
		CALL str_cmp
		JP Z, _mkdir
		; rmdir command
		LD IY, RmDir
		CALL str_cmp
		JP Z, _rmdir
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
        CALL str_shift
        CALL vga_writeLn
        JP cmd_main
_peek:
        CALL mon_peek
        JP _wrap
_poke:
        CALL mon_poke
        JP cmd_main
_put:
        CALL mon_put
        JP cmd_main
_get:
		CALL mon_get
		JP _wrap
_load:
		CALL dos_load
		JP cmd_main
_save:
		CALL dos_save
		JP cmd_main
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
		CALL onp_main
		JP cmd_main
_pwd:
		CALL dos_pwd
		JP cmd_main
_ls:
		CALL dos_ls
		JP cmd_main
_mkdir:
		CALL dos_mkDir
		JP cmd_main
_rmdir:
		CALL dos_rmDir
		JP cmd_main
ENDP

cmd_readLn:
        CALL kbd_readLine
        CALL vga_nextLine
        LD IX, LineBuff
        RET
