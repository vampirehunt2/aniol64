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
Cat:		defb "cat", 0
Beep: 		defb "beep", 0
Term: 		defb "term", 0
DiskInfo: 	defb "di", 0
DiskDiag:	defb "dd", 0
Test:		defb "test", 0
Snake:		defb "snake", 0
Vh:			defb "vh", 0
Onp:		defb "onp", 0
Edit:		defb "edit", 0
Tar:		defb "tar", 0
Man:        defb "man", 0
Cpm: 		defb "cpm", 0
Dart:       defb "dart", 0
; DOS commands
Pwd:		defb "pwd", 0
Ls:			defb "ls", 0
MkDir:		defb "mkdir", 0
RmDir:		defb "rmdir", 0
Cd:			defb "cd", 0
Touch:		defb "touch", 0
Rm:			defb "rm", 0
Format:		defb "format", 0
Mv:			defb "mv", 0
Cp:			defb "cp", 0

; APL commands
Apl:		defb "apl", 0
AplRun: 	defb "run", 0		

UnknownCmd: defb "Unknown cmd", 0
Prompt: 	defb ">", 0


cmd_main:
		LD IX, Prompt
		CALL writeStr
		CALL cursorOn
        CALL cmd_readLn
cmd_debug:
		LD IX, LineBuff 		; redundant, used for debugging only
        CALL str_tok
		;LD (Args), HL
		LD A, (IX)
		CP '.'
		JR NZ, .cont
		LD A, (IX + 1)
		CP '/'
		JR NZ, .cont
		LD A, ' '				; hack :)
		LD (IX + 1), A
		CALL str_tok
		JP .run
.cont:
		; clear screen command
        LD IY, Clr
        CALL str_cmp
        JP Z, .clr
        ; reset command
        LD IY, Reset
        CALL str_cmp
        JP Z, .rst
        ; echo command
        LD IY, EchoCmd
        CALL str_cmp
        JP Z, .echo
        ; rnd command
        LD IY, Rnd
        CALL str_cmp
        JP Z, .rnd
        ; monitor program
        LD IY, Mon
        CALL str_cmp
        JP Z, .mon
        ; peek command
        LD IY, Peek
        CALL str_cmp
        JP Z, .peek
        ; poke command
        LD IY, Poke
        CALL str_cmp
        JP Z, .poke
        ; put command
        LD IY, Put
        CALL str_cmp
        JP Z, .put
		; get command
		LD IY, Get
		CALL str_cmp
		JP Z, .get
		; load command
		LD IY, Load
		CALL str_cmp
		JP Z, .load
		; save command
		LD IY, Save
		CALL str_cmp
		JP Z, .save
		; cat command
		LD IY, Cat
		CALL str_cmp
		JP Z, .cat
        ; beep command
        LD IY, Beep
        CALL str_cmp
        JP Z, .beep
		; term program
		LD IY, Term
		CALL str_cmp
		JP Z, term_main
		; disk info
		LD IY, DiskInfo
		CALL str_cmp
		JP Z, .di
		; disk info
		LD IY, DiskDiag
		CALL str_cmp
		JP Z, .dd
		; test command
		LD IY, Test
		CALL str_cmp
		JP Z, .test
		; snake 
		LD IY, Snake
		CALL str_cmp
		JP Z, snake_main
		; vh
		LD IY, Vh
		CALL str_cmp
		JP Z, rog_main
		; onp 
		LD IY, Onp
		CALL str_cmp
		JP Z, .onp
		; edit command
		LD IY, Edit
		CALL str_cmp
		JP Z, .edit
		; execute CP/M
		LD IY, Cpm
		CALL str_cmp
		JP Z, .cpm
        ; DART config command
        LD IY, Dart
        CALL str_cmp
        JP Z, .dart
		; pwd command
		LD IY, Pwd
		CALL str_cmp
		JP Z, .pwd     
		; ls command
		LD IY, Ls
		CALL str_cmp
		JP Z, .ls
		; mkdir command
		LD IY, MkDir
		CALL str_cmp
		JP Z, .mkdir
		; rmdir command
		LD IY, RmDir
		CALL str_cmp
		JP Z, .rmdir
		; cd command
		LD IY, Cd
		CALL str_cmp
		JP Z, .cd
		; touch command
		LD IY, Touch
		CALL str_cmp
		JP Z, .touch
		; rm command
		LD IY, Rm
		CALL str_cmp
		JP Z, .rm
		; format command
		LD IY, Format
		CALL str_cmp
		JP Z, .format
		; tar command
		LD IY, Tar
		CALL str_cmp
		JP Z, .tar
        ; man command
        LD IY, Man
        CALL str_cmp
        JP Z, .man
		; mv command
		LD IY, Mv
		CALL str_cmp
		JP Z, .mv
		; cp command
		LD IY, Cp
		CALL str_cmp
		JP Z, .cp
		; APL command
		LD IY, Apl
		CALL str_cmp
		JP Z, .apl
		; Run command
		LD IY, AplRun
		CALL str_cmp
		JP Z, .run
        ; unknown command
        LD IX, UnknownCmd
        CALL writeStr
        ; CALL bzr_beep too noisy
.wrap:
		CALL nextLine
		JP cmd_main
.clr:
        CALL clrScr
        CALL home
        JP cmd_main
.rst:
        RST 00h
.echo:
        CALL cmd_echo
        JP cmd_main
.peek:
        CALL mon_peek
        JP .wrap
.poke:
        CALL mon_poke
        JP cmd_main
.put:
        CALL mon_put
        JP cmd_main
.get:
		CALL mon_get
		JP .wrap
.load:
		CALL cmd_loadFile
		JP cmd_main
.save:
		CALL cmd_saveFileAs
		JP cmd_main
.cat:
		CALL dos_cat
		JP cmd_main
.beep:
        CALL bzr_beep
        JP cmd_main
.rnd:
        CALL rnd
        CALL byte2asc
        PUSH AF
        LD A, B
        CALL putChar
        POP AF
        CALL putChar
        JP .wrap
.di:
		CALL dos_cfDiskInfo
		JP .wrap
.dd:	
		CALL cf_diag
		CALL mon_printByteA
		JP .wrap
.test:
		CALL test_main
		JP cmd_main
.mon:
        CALL mon_main
        JP .wrap
        RET
.onp:
		CALL onp_main
		JP cmd_main
.edit:
		CALL ed_main
		JP cmd_main
.cpm:
		CALL cpm_main
		JP cmd_main
.pwd:
		CALL dos_pwd
		JP cmd_main
.dart:
        CALL dart_main
        JP cmd_main
.ls:
		CALL dos_ls
		JP cmd_main
.mkdir:
		CALL cmd_mkDir
		JP cmd_main
.rmdir:
		CALL cmd_rmDir
		JP cmd_main
.cd:
		CALL cmd_cd
		JP cmd_main
.touch:
		CALL cmd_touch
		JP cmd_main
.rm:
		CALL cmd_rm
		JP cmd_main
.format:
		CALL dos_format
		JP cmd_main
.tar:
		CALL tar_main
		JP cmd_main
.man:
        CALL man_main
        JP cmd_main
.mv:	
		CALL cmd_mv
		JP cmd_main
.cp:
		CALL cmd_cp
		JP cmd_main
.apl:
		CALL apl_main
		JP cmd_main
.run:
		CALL run_main
		JP cmd_main


cmd_readLn:
        LD A, WHITE  * 16
        LD (Colour), A
        CALL readLine
        CALL nextLine
        LD A, GREEN  * 16
        LD (Colour), A
        LD IX, LineBuff
        LD IY, PrevLineBuff
        CALL str_copy
        RET


cmd_echo:
	CALL str_shift
	PUSH IX
.loop:
	LD A, (IX)
	CP '>'			; check if redirection character is present
	JR Z, .toFile
	CP 0
	JR Z, .endLoop
	INC IX
	JR .loop
.endLoop:
	POP IX
	CALL writeLn
	RET
.toFile:
	LD A, 0
	LD (IX), A		; write an EOL where the redirection was
	INC IX
	LD IY, CurrentFileName
	CALL str_copy	; copy the file name to the dos file descriptor
	POP IX			; point IX back to the beginning of the content string
	CALL str_len
	LD (CurrentFileSize), A		; copy the file size to the dos file descriptor
	LD A, 0						; upper byte set to 0, due to command line length limitation...
	LD (CurrentFileSize + 1), A ; ... the size of a file created by echo cannot be longer than 256 bytes
	LD IY, FileBuffer
	CALL str_copy				; copy the file contents TODO add a newline at the end
	CALL cmd_saveFile
	RET


