;----------------------------------------------------
; Project: aniol64.zdsp
; File: mon.asm
; Date: 9/22/2021 13:36:12
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------

SetValue: 	defb "s", 0
SetAddress:     defb "a", 0
NextScreen:     defb "n", 0
PrevScreen:     defb "p", 0
NextLine: 	defb "d", 0
PrevLine: 	defb "u", 0
Fill: 		defb "f", 0
Copy: 		defb "c", 0
Run: 		defb "r", 0

Bye: 		defb "bye", 			0
Exit: 		defb "Exiting...", 		0
ParseErr: 	defb "Parse error", 	0
InvAddr: 	defb "Invalid address", 0
InvVal: 	defb "Invalid value", 	0 

MonCurrAddr     equ PROGRAM_DATA 
LINE_NUM 	equ MAX_Y - 2


mon_main:
	CALL clrScr
        LD A, 0  
        LD (MonCurrAddr), A
        LD (MonCurrAddr + 1), A
	CALL mon_refresh
mon_main_loop:
	CALL cursorOn
	CALL mon_gotoCmdLine
        CALL readLine
        LD IX, LineBuff
        CALL str_tok
        ; set value command
        LD IX, LineBuff
        LD IY, SetValue
        CALL str_cmp
        JP Z, mon_setValue
        ; fill command
        LD IX, LineBuff
        LD IY, Fill
        CALL str_cmp
        JP Z, mon_fill
        ; copy command
        LD IX, LineBuff
        LD IY, Copy
        CALL str_cmp
        JP Z, mon_copy
        ; set address command
        LD IX, LineBuff
        LD IY, SetAddress
        CALL str_cmp
        JP Z, mon_setAddress
        ; next screen command
        LD IX, LineBuff
        LD IY, NextScreen
        CALL str_cmp
        JP Z, mon_nextScreen
        ; prev screen command
        LD IX, LineBuff
        LD IY, PrevScreen
        CALL str_cmp
        JP Z, mon_prevScreen
        ; next line command
        LD IX, LineBuff
        LD IY, NextLine
        CALL str_cmp
        JP Z, mon_nextLine
         ; prev line command
        LD IX, LineBuff
        LD IY, PrevLine
        CALL str_cmp
        JP Z, mon_prevLine
        ; set command
        LD IX, LineBuff
        LD IY, SetValue
        CALL str_cmp
        JP Z, mon_setValue
        ; run command
        LD IX, LineBuff
        LD IY, Run
        CALL str_cmp
        JP Z, mon_run
        ; bye command
        LD IX, LineBuff
        LD IY, Bye
        CALL str_cmp
        JR Z, .bye
        ; unknown command 
        LD IX, UnknownCmd
        CALL mon_gotoStatusLine
        CALL writeStr
        JP mon_main_loop
.bye:
        RET


mon_gotoCmdLine:
	LD B, 0
	LD C, LINE_NUM
	CALL gotoXY
	LD IX, Blank
        CALL writeStr
        LD B, 0
	LD C, LINE_NUM
	CALL gotoXY
	RET
		
mon_gotoStatusLine:
	LD B, 0
	LD C, LINE_NUM + 1
	CALL gotoXY
	LD IX, Blank
	CALL writeStr
	LD B, 0
	LD C, LINE_NUM + 1
	CALL gotoXY
	RET


mon_setAddress:
        PUSH HL
        POP IX  ; setting IX to point to the argument of the adr command
        CALL parseDByte
        CP 0
        JR NZ, .parseError
        LD (MonCurrAddr), HL
        CALL mon_dsp
        JP mon_main_loop
.parseError:
        CALL mon_gotoStatusLine
        LD IX, InvAddr
        CALL writeStr
        CALL readKey
        CALL mon_refresh
        JP mon_main_loop

mon_run:
        PUSH HL
        POP IX  ; setting IX to point to the argument of the adr command
        CALL parseDByte
        CP 0
        JR NZ, .parseError
        JP (HL)  ; we are assuming whatever program we call will
                ;either continue running until system reset or jump back to a known location, such as mon_main
.parseError:
        CALL mon_gotoStatusLine
        LD IX, InvAddr
        CALL writeStr
        CALL readKey
        CALL mon_refresh
        JP mon_main_loop
        RET

mon_setValue:
        PUSH HL
        POP IX                  ; put the arguments of the set command in IX
        CALL str_len
        CP 0                    ; if we've reached the end of argument list
        JP Z, .completed        ; return from this routine
	LD A, (IX)
	CP '='
        JP Z, .setDirect
        CALL str_tok            ; extract the first of the remaining arguments
        PUSH HL                 ; save the rest of the arguments on stack
        CALL parseByte
        CP 0                    ; check if parse is successful
        JR NZ, .parseError
        LD A, B                 ; transfer the parsed value to A
        LD HL, (MonCurrAddr)
        LD (HL), A
        INC HL
        LD (MonCurrAddr), HL
        POP HL
        JR mon_setValue
.setDirect:
	CALL str_tok            ; extract the first of the remaining arguments
	PUSH HL
	LD HL, (MonCurrAddr)
.loop:
	INC IX
	LD A, (IX)
	CP 0
	JP Z, .endSetDirect
	LD (HL), A
	INC HL
	JR .loop
.endSetDirect:
	LD (MonCurrAddr), HL
	POP HL
	JR mon_setValue
.parseError:
        CALL mon_gotoStatusLine
        LD IX, InvVal
        CALL writeStr
        CALL readKey
        JP mon_main_loop
.completed:
        CALL mon_dsp
        JP mon_main_loop

mon_fill:
        PUSH HL
        POP IX                  ; put the arguments of the fill command in IX
        CALL str_tok            ; number of bytes now in a string pointed to by IX
                                ; value now in a string pointed to by HL
        CALL parseByte
        CP 0
        JP NZ, .parseError
        PUSH BC                 ; saving the parsed number in B
        PUSH HL
        POP IX
        CALL parseByte          ; now parsing the value
        CP 0
        JP NZ, .parseError
        LD A, B                 ; value to fill now in A
        POP BC                  ; number of fills now in B
.loop:
        LD HL, (MonCurrAddr)
        LD (HL), A
        INC HL
        LD (MonCurrAddr), HL    ; moving to the next address
        DJNZ .loop              ; if B is not zero, repeat
        CALL mon_dsp
        JP mon_main_loop
.parseError:
        CALL mon_gotoStatusLine
        LD IX, InvVal
        CALL writeStr
        CALL readKey
        CALL mon_refresh
        JP mon_main_loop



mon_copy:
        PUSH HL
        POP IX                  ; put the arguments of the copy command in IX
        CALL str_tok            ; number of bytes now in a string pointed to by IX
                                ; source address is now in a string pointed to by HL
        CALL parseByte
        CP 0
        JP NZ, .invalidValue
        PUSH BC                 ; saving the parsed number in B
        PUSH HL
        POP IX                  ; source address is now in a string pointed to by IX
        CALL parseDByte         ; now parsing the value
        CP 0
        JP NZ, .invalidAddress
        PUSH HL
        POP IX
        POP BC
.loop:
        LD A, (IX + 0)
        LD HL, (MonCurrAddr)
        LD (HL), A
        INC HL
        LD (MonCurrAddr), HL    ; moving to the next address
        INC IX
        DJNZ .loop              ; if B is not zero, repeat
        CALL mon_dsp
        JP mon_main_loop
.invalidValue:
        CALL mon_gotoStatusLine
        LD IX, InvVal
        CALL writeStr
        CALL readKey
        CALL mon_refresh
        JP mon_main_loop
.invalidAddress:
        CALL mon_gotoStatusLine
        LD IX, InvAddr
        CALL writeStr
        CALL readKey
        CALL mon_refresh
        JP mon_main_loop



mon_nextScreen:
	PUSH BC
        LD HL, (MonCurrAddr)
	LD B, LINE_NUM
.loop:
        CALL mon_nextAddrs
        DJNZ .loop
        LD (MonCurrAddr), HL
        CALL mon_dsp
        POP BC
        JP mon_main_loop

mon_prevScreen:
	PUSH BC
        LD HL, (MonCurrAddr)
	LD B, LINE_NUM
.loop:
        CALL mon_prevAddrs
	DJNZ .loop
        LD (MonCurrAddr), HL
        CALL mon_dsp
	POP BC
        JP mon_main_loop


; scrolls one line down
mon_nextLine:
        LD HL, (MonCurrAddr)
        CALL mon_nextAddrs
        LD (MonCurrAddr), HL
        CALL mon_dsp
        JP mon_main_loop

; scrolls one line up
mon_prevLine:
        LD HL, (MonCurrAddr)
        CALL mon_prevAddrs
        LD (MonCurrAddr), HL
        CALL mon_dsp
        JP mon_main_loop

mon_dsp:
	PUSH BC
        CALL cursorOff
        LD HL, (MonCurrAddr) 
        LD A, L 
        AND 11111000b    ; make sure the address from which you start displaying is at an 8 byte alignement   
		LD L, A
		CALL home
		LD B, LINE_NUM
.loop:
		PUSH BC
        CALL mon_printAddrs
        CALL mon_printVals
        CALL nextLine
		CALL mon_nextAddrs
		POP BC
		DJNZ .loop
		CALL cursorOn
		POP BC
        RET


; prints the addresses for a single line of output of the dsp command
; the first address in is HL
mon_printAddrs:
        PUSH HL
        POP IX
        CALL mon_printDByte
        LD A, ":"
        CALL putChar
        RET


; prints the values for a single line of output of the dsp command
; the first address in is HL
mon_printVals:
        PUSH BC
        PUSH HL
        POP IX
	LD B, 8
.loop:
	LD A, 8
	CP B
	JR Z, .skipSpace
        LD A, " "
        CALL putChar
.skipSpace:
	PUSH BC
        CALL mon_printByte
	INC IX
	POP BC
	DJNZ .loop
	POP BC
	; print the actual characters
	LD A, '|'
	CALL putChar
	LD A, (IX - 8)
	CALL mon_printChar
	LD A, (IX - 7)
	CALL mon_printChar
	LD A, (IX - 6)
	CALL mon_printChar
	LD A, (IX - 5)
	CALL mon_printChar
	LD A, (IX - 4)
	CALL mon_printChar
	LD A, (IX - 3)
	CALL mon_printChar
	LD A, (IX - 2)
	CALL mon_printChar
	LD A, (IX - 1)
	CALL mon_printChar
        RET



mon_printChar:
		CP 32
		JR C, .special
		JR .print
.special:
		LD A, ' '
.print:
		CALL putChar
		RET


mon_printByte:
        LD A, (IX + 0)
mon_printByteA:
        PUSH BC
        CALL byte2asc
        PUSH AF
        LD A, B
        CALL putChar
        POP AF
        CALL putChar
        POP BC
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
        CALL putChar
        POP AF
        CALL putChar
        LD A, E
        CALL byte2asc
        PUSH AF
        LD A, B
        CALL putChar
        POP AF
        CALL putChar
        RET

; prints the value the lower byte of IX to the lcd screen
; IX - the value of the double byte to print
mon_printLByte:
        PUSH IX
        POP DE
        LD A, E
        CALL byte2asc
        PUSH AF
        LD A, B
        CALL putChar
        POP AF
        CALL putChar
        RET

; moves the address in HL by one line (8 memory cells)
mon_nextAddrs:
        INC HL
        INC HL
        INC HL
        INC HL
		INC HL
        INC HL
        INC HL
        INC HL
        RET

; moves back the address in HL by one line (8 memory cells)
mon_prevAddrs:
        DEC HL
        DEC HL
        DEC HL
        DEC HL
		DEC HL
        DEC HL
        DEC HL
        DEC HL
        RET


mon_isWriteable:
        LD A, H
        CP 7Fh
        JR C, .nonWriteable
        LD A, TRUE
        RET
.nonWriteable:
        LD A, FALSE
        RET


mon_refresh:
        CALL clrScr
        CALL mon_dsp
        RET


mon_peek:
		CALL str_shift
        CALL parseDByte
        CP 0
        JR NZ, .parseError
        LD A, (HL)
        CALL mon_printByteA
        RET
.parseError:
        LD IX, InvAddr
        CALL writeStr
        RET



mon_poke:
		CALL str_shift
        CALL str_tok        ; address now in a string pointed to by IX, value in a string pointed to by HL
        PUSH HL             ; copying the value string
        POP IY              ; to IY for safekeeping
        CALL parseDByte     ; assuming parsing is OK, address is now in HL
        CP 0
        JR NZ, .addrError
        PUSH IY             ; transferring the value string
        POP IX              ; to IX
        CALL parseByte
        CP 0
        JR NZ, .valError
        LD A, B
        LD (HL), A
        RET
.addrError:
        LD IX, InvAddr
        CALL writeStr
        RET
.valError:
        LD IX, InvVal
        CALL writeStr
        RET

mon_put:
		CALL str_shift
        CALL str_tok        ; port number now in a string pointed to by IX, value in a string pointed to by HL
        PUSH HL             ; copying the value string
        POP IY              ; to IY for safekeeping
        CALL parseByte      ; assuming parsing is OK, port number is now in B
        CP 0
        JR NZ, .addrError
        LD C, B             ; save port number in C
        PUSH IY             ; transferring the value string
        POP IX              ; to IX
.loop:
		CALL str_tok
		CALL str_len
		CP 0
		RET Z
        CALL parseByte      ; assuming parsing is OK, value is now in B
        CP 0
        JR NZ, .valError
        LD A, B             ; load the value to A
        OUT (C), A          ; output the value to the port with the given number
		CALL str_shift
		JR .loop
        RET
.addrError:
        LD IX, InvAddr
        CALL writeStr
        RET
.valError:
        LD IX, InvVal
        CALL writeStr
        RET



mon_get:
        CALL str_shift
		CALL parseByte
		CP 0
		JR NZ, .addrError
		LD C, B
		IN A, (C)
		CALL mon_printByteA
		RET
.addrError:
		LD IX, InvAddr
        CALL writeStr
        RET

