;----------------------------------------------------
; Project: aniol64.zdsp
; File: mon.asm
; Date: 9/22/2021 13:36:12
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------

SetValue: 	defb "s", 0
SetAddress: defb "a", 0
NextScreen: defb "n", 0
PrevScreen: defb "p", 0
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
Blank:		defb "                                      ", 0

MonCurrAddr equ PROGRAM_DATA 
LINE_NUM 	equ 26

PROC
defb "mon_main"
mon_main:
		CALL vga_clrScr
        LD A, 0  
        LD (MonCurrAddr), A
        LD (MonCurrAddr + 1), A
		CALL mon_refresh
mon_main_loop:
		CALL vga_curOn
		CALL mon_gotoCmdLine
        CALL kbd_readLine
        LD IX, LineBuff
        CALL str_tok
        ; set value command
        LD IX, LineBuff
        LD IY, SetValue
        CALL str_cmp
        CP 0
        JP Z, mon_setValue
        ; fill command
        LD IX, LineBuff
        LD IY, Fill
        CALL str_cmp
        CP 0
        JP Z, mon_fill
        ; copy command
        LD IX, LineBuff
        LD IY, Copy
        CALL str_cmp
        CP 0
        JP Z, mon_copy
        ; set address command
        LD IX, LineBuff
        LD IY, SetAddress
        CALL str_cmp
        CP 0
        JP Z, mon_setAddress
        ; next screen command
        LD IX, LineBuff
        LD IY, NextScreen
        CALL str_cmp
        CP 0
        JP Z, mon_nextScreen
        ; prev screen command
        LD IX, LineBuff
        LD IY, PrevScreen
        CALL str_cmp
        CP 0
        JP Z, mon_prevScreen
        ; next line command
        LD IX, LineBuff
        LD IY, NextLine
        CALL str_cmp
        CP 0
        JP Z, mon_nextLine
         ; prev line command
        LD IX, LineBuff
        LD IY, PrevLine
        CALL str_cmp
        CP 0
        JP Z, mon_prevLine
        ; set command
        LD IX, LineBuff
        LD IY, SetValue
        CALL str_cmp
        CP 0
        JP Z, mon_setValue
        ; run command
        LD IX, LineBuff
        LD IY, Run
        CALL str_cmp
        CP 0
        JP Z, mon_run
        ; bye command
        LD IX, LineBuff
        LD IY, Bye
        CALL str_cmp
        CP 0
        JR Z, _bye
        ; unknown command 
        LD IX, UnknownCmd
        CALL mon_gotoStatusLine
        CALL vga_wriStr
        JP mon_main_loop
_bye:
        RET
ENDP

mon_gotoCmdLine:
		LD B, 0
		LD C, LINE_NUM
		CALL vga_gotoXY
		LD IX, Blank
		CALL vga_wriStr
		LD B, 0
		LD C, LINE_NUM
		CALL vga_gotoXY
		RET
		
mon_gotoStatusLine:
		LD B, 0
		LD C, LINE_NUM + 1
		CALL vga_gotoXY
		LD IX, Blank
		CALL vga_wriStr
		LD B, 0
		LD C, LINE_NUM + 1
		CALL vga_gotoXY
		RET

PROC
mon_setAddress:
        PUSH HL
        POP IX  ; setting IX to point to the argument of the adr command
        CALL parseDByte
        CP 0
        JR NZ, _parseError
        LD (MonCurrAddr), HL
        CALL mon_dsp
        JP mon_main_loop
_parseError:
        CALL mon_gotoStatusLine
        LD IX, InvAddr
        CALL vga_wriStr
        CALL kbd_readKey
        CALL mon_refresh
        JP mon_main_loop
ENDP

PROC
mon_run:
        PUSH HL
        POP IX  ; setting IX to point to the argument of the adr command
        CALL parseDByte
        CP 0
        JR NZ, _parseError
        JP (HL)  ; we are assuming whatever program we call will
                ;either continue running until system reset or jump back to a known location, such as mon_main
_parseError:
        CALL mon_gotoStatusLine
        LD IX, InvAddr
        CALL vga_wriStr
        CALL kbd_readKey
        CALL mon_refresh
        JP mon_main_loop
        RET
ENDP

PROC
mon_setValue:
        PUSH HL
        POP IX                  ; put the arguments of the set command in IX
        CALL str_len
        CP 0                    ; if we've reached the end of argument list
        JP Z, _completed         ; return from this routine
        CALL str_tok            ; extract the first of the remaining arguments
        PUSH HL                 ; save the rest of the arguments on stack
        CALL parseByte
        CP 0                    ; check if parse is successful
        JR NZ, _parseError
        LD A, B                 ; transfer the parsed value to A
        LD HL, (MonCurrAddr)
        LD (HL), A
        INC HL
        LD (MonCurrAddr), HL
        POP HL
        JR mon_setValue
_parseError:
        CALL mon_gotoStatusLine
        LD IX, InvVal
        CALL vga_wriStr
        CALL kbd_readKey
        JP mon_main_loop
_completed:
        CALL mon_dsp
        JP mon_main_loop
ENDP

PROC
mon_fill:
        PUSH HL
        POP IX                  ; put the arguments of the fill command in IX
        CALL str_tok            ; number of bytes now in a string pointed to by IX
                                ; value now in a string pointed to by HL
        CALL parseByte
        CP 0
        JP NZ, _parseError
        PUSH BC                 ; saving the parsed number in B
        PUSH HL
        POP IX
        CALL parseByte          ; now parsing the value
        CP 0
        JP NZ, _parseError
        LD A, B                 ; value to fill now in A
        POP BC                  ; number of fills now in B
_loop:
        LD HL, (MonCurrAddr)
        LD (HL), A
        INC HL
        LD (MonCurrAddr), HL    ; moving to the next address
        DJNZ _loop              ; if B is not zero, repeat
        CALL mon_dsp
        JP mon_main_loop
_parseError:
        CALL mon_gotoStatusLine
        LD IX, InvVal
        CALL vga_wriStr
        CALL kbd_readKey
        CALL mon_refresh
        JP mon_main_loop
ENDP

PROC
mon_copy:
        PUSH HL
        POP IX                  ; put the arguments of the copy command in IX
        CALL str_tok            ; number of bytes now in a string pointed to by IX
                                ; source address is now in a string pointed to by HL
        CALL parseByte
        CP 0
        JP NZ, _invalidValue
        PUSH BC                 ; saving the parsed number in B
        PUSH HL
        POP IX                  ; source address is now in a string pointed to by IX
        CALL parseDByte         ; now parsing the value
        CP 0
        JP NZ, _invalidAddress
        PUSH HL
        POP IX
        POP BC
_loop:
        LD A, (IX + 0)
        LD HL, (MonCurrAddr)
        LD (HL), A
        INC HL
        LD (MonCurrAddr), HL    ; moving to the next address
        INC IX
        DJNZ _loop              ; if B is not zero, repeat
        CALL mon_dsp
        JP mon_main_loop
_invalidValue:
        CALL mon_gotoStatusLine
        LD IX, InvVal
        CALL vga_wriStr
        CALL kbd_readKey
        CALL mon_refresh
        JP mon_main_loop
_invalidAddress:
        CALL mon_gotoStatusLine
        LD IX, InvAddr
        CALL vga_wriStr
        CALL kbd_readKey
        CALL mon_refresh
        JP mon_main_loop
ENDP

PROC
mon_nextScreen:
		PUSH BC
        LD HL, (MonCurrAddr)
		LD B, LINE_NUM
_loop:
        CALL mon_nextAddrs
        DJNZ _loop
        LD (MonCurrAddr), HL
        CALL mon_dsp
		POP BC
        JP mon_main_loop
ENDP

PROC
mon_prevScreen:
		PUSH BC
        LD HL, (MonCurrAddr)
		LD B, LINE_NUM
_loop:
        CALL mon_prevAddrs
		DJNZ _loop
        LD (MonCurrAddr), HL
        CALL mon_dsp
		POP BC
        JP mon_main_loop
ENDP

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

PROC
mon_dsp:
		PUSH BC
        CALL vga_curOff
        LD HL, (MonCurrAddr) 
        LD A, L 
        AND 11111000b    ; make sure the address from which you start displaying is at an 8 byte alignement   
		LD L, A
		CALL vga_gotoLn1
		LD B, LINE_NUM
_loop:
		PUSH BC
        CALL mon_printAddrs
        CALL mon_printVals
        CALL vga_nextLine
		CALL mon_nextAddrs
		POP BC
		DJNZ _loop
		CALL vga_curOn
		POP BC
        RET
ENDP

; prints the addresses for a single line of output of the dsp command
; the first address in is HL
mon_printAddrs:
        PUSH HL
        POP IX
        CALL mon_printDByte
        LD A, ":"
        CALL vga_putChar
        RET

PROC
; prints the values for a single line of output of the dsp command
; the first address in is HL
mon_printVals:
		PUSH BC
        PUSH HL
        POP IX
		LD B, 8
_loop:
		PUSH BC
        LD A, " "
        CALL vga_putChar
        CALL mon_printByte
		INC IX
		POP BC
		DJNZ _loop
		POP BC
		; print the actual characters
		LD A, '|'
		CALL vga_putChar
		LD A, (IX - 8)
		CALL vga_putChar
		LD A, (IX - 7)
		CALL vga_putChar
		LD A, (IX - 6)
		CALL vga_putChar
		LD A, (IX - 5)
		CALL vga_putChar
		LD A, (IX - 4)
		CALL vga_putChar
		LD A, (IX - 3)
		CALL vga_putChar
		LD A, (IX - 2)
		CALL vga_putChar
		LD A, (IX - 1)
		CALL vga_putChar
        RET
ENDP

mon_printByte:
        LD A, (IX + 0)
mon_printByteA:
        CALL byte2asc
        PUSH AF
        LD A, B
        CALL vga_putChar
        POP AF
        CALL vga_putChar
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
        CALL vga_putChar
        POP AF
        CALL vga_putChar
        LD A, E
        CALL byte2asc
        PUSH AF
        LD A, B
        CALL vga_putChar
        POP AF
        CALL vga_putChar
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
        CALL vga_putChar
        POP AF
        CALL vga_putChar
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

PROC
mon_isWriteable:
        LD A, H
        CP 7Fh
        JR C, _nonWriteable
        LD A, TRUE
        RET
_nonWriteable:
        LD A, FALSE
        RET
ENDP

mon_refresh:
        CALL vga_clrScr
        CALL mon_dsp
        RET

PROC
mon_peek:
        CALL parseDByte
        CP 0
        JR NZ, _parseError
        LD A, (HL)
        CALL mon_printByteA
        RET
_parseError:
        LD IX, InvAddr
        CALL vga_wriStr
        RET
ENDP

PROC
mon_poke:
        CALL str_tok        ; address now in a string pointed to by IX, value in a string pointed to by HL
        PUSH HL             ; copying the value string
        POP IY              ; to IY for safekeeping
        CALL parseDByte     ; assuming parsing is OK, address is now in HL
        CP 0
        JR NZ, _addrError
        PUSH IY             ; transferring the value string
        POP IX              ; to IX
        CALL parseByte
        CP 0
        JR NZ, _valError
        LD A, B
        LD (HL), A
        RET
_addrError:
        LD IX, InvAddr
        CALL vga_wriStr
        RET
_valError:
        LD IX, InvVal
        CALL vga_wriStr
        RET
ENDP

PROC
mon_put:
        CALL str_tok        ; port number now in a string pointed to by IX, value in a string pointed to by HL
        PUSH HL             ; copying the value string
        POP IY              ; to IY for safekeeping
        CALL parseByte      ; assuming parsing is OK, port number is now in B
        CP 0
        JR NZ, _addrError
        LD C, B             ; save port number in C
        PUSH IY             ; transferring the value string
        POP IX              ; to IX
        CALL parseByte      ; assuming parsing is OK, value is now in B
        CP 0
        JR NZ, _valError
        LD A, B             ; load the value to A
        OUT (C), A          ; output the value to the port with the given number
        RET
_addrError:
        LD IX, InvAddr
        CALL vga_wriStr
        RET
_valError:
        LD IX, InvVal
        CALL vga_wriStr
        RET
ENDP

