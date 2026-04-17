;----------------------------------------------------
; Project: aniol64.zdsp
; File: dart.asm
; Date: 8/27/2021 13:05:50
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------
 
 
DART_A_CMD equ 11101110b
DART_B_CMD equ 11101111b 
DART_A_DAT equ 11101100b
DART_B_DAT equ 11101101b

WR_0    equ 00011000b	; channel reset
WR_4    equ 11000100b	; x64 clock, no parity, 1 stop bit
WR_3    equ 11000000b	; Rx 8 bits disable Rx
WR_5    equ 01100000b	; Tx 8 bits, Tx disabled
WR_1    equ 10000000b	; disable interrupts, enable WAIT
 
X_ON equ 13h 
X_OFF equ 11h

X64:    db "b300", 0
X32:    db "b600", 0
X16:    db "b1200", 0
X01:    db  "b19200", 0
PARITY_EVEN:    db "p2", 0
PARITY_ODD:     db "p1", 0
PARITY_NONE:    db "p0", 0
STOP_BITS_1:    db "s1", 0
STOP_BITS_2:    db "s2", 0

Unsupported: db "Unsupported", 0

init_seq equ PROGRAM_DATA

dart_setup:
    LD IY, init_seq
    LD (IY+0), 0
    LD (IY+1), WR_0
    LD (IY+2), 4
    LD (IY+3), WR_4
    LD (IY+4), 3
    LD (IY+5), WR_3
    LD (IY+6), 5
    LD (IY+7), WR_5
    LD (IY+8), 1
    LD (IY+9), WR_1
    RET



; dart -xClock -pParity -sStopBits -r Receiver On -t Transmitter On 
; dart -x64 -p0 -s1 -r -t
dart_main:
    CALL dart_setup
.paramLoop:
    CALL str_shift
    CALL str_tok
    CALL str_len
    CP 0            ; end of params?
    JR Z, .end
    LD A, (IX)
    CP '-'
    JR NZ, .err
    INC IX
    LD A, (IX)
    CP 'b'
    CALL Z, dart_setClock
    CP 'p'
    CALL Z, dart_setParity
    CP 's'
    CALL Z, dart_setStopBits
    CP 'r'
    CALL Z, dart_setReceiver
    CP 't'
    CALL Z, dart_setTransmiter
    JR .paramLoop
.err:
    LD IX, SyntaxError
    CALL writeLn
    RET
.end:
    CALL dart_init
    RET

dart_setClock:
    LD IY, X64
    CALL str_cmp
    RET Z           ; do nothing the default is already x64 clock
    LD IY, X32
    CALL str_cmp
    JR Z, .x32
    LD IY, X16
    CALL str_cmp
    JR Z, .x16
    LD IY, X01
    CALL str_cmp
    JR Z, .x1
    RET                 ; unsupported baudrate, fall back to default
.x32:   
    LD A, (init_seq + 3)
    AND 10111111b
    LD (init_seq + 3), A
    RET
.x16:  
    LD A, (init_seq + 3)
    AND 01111111b
    LD (init_seq + 3), A
    RET 
.x1:
    LD A, (init_seq + 3)
    AND 00111111b
    LD (init_seq + 3), A
    RET


dart_setParity:
    LD IY, PARITY_NONE
    CALL str_cmp
    RET Z               ; do nothing the default is already no parity
    LD IY, PARITY_EVEN
    CALL str_cmp
    JR Z, .even
    LD IY, PARITY_ODD
    CALL str_cmp
    JR Z, .odd
    RET                 ; invalid parity, fall back to default
.even:   
    LD A, (init_seq + 3)
    OR 00000011b
    LD (init_seq + 3), A
    RET
.odd:  
    LD A, (init_seq + 3)
    AND 00000001b
    LD (init_seq + 3), A
    RET 


dart_setStopBits:   
    LD IY, STOP_BITS_1
    CALL str_cmp
    RET Z               ; do nothing the default is already 1 stop bit
    LD IY, STOP_BITS_2
    CALL str_cmp
    RET NZ              ; invalid number of stop bits, fall back to default   
    LD A, (init_seq + 3)
    OR 00001000b
    LD (init_seq + 3), A
    RET 

dart_setReceiver:
    LD A, (init_seq + 5)
    OR 00000001b
    LD (init_seq + 5), A 
    RET

dart_setTransmiter:
    LD A, (init_seq + 7)
    OR 00001000b
    LD (init_seq + 7), A 
    RET

dart_init:
	LD HL, init_seq
	LD B, 10
	LD C, DART_B_CMD
	OTIR
    RET

; writes a character out through the serial port	
; A - character to write out
dart_putChar:
	OUT (DART_B_DAT), A
	; waiting for the character to be sent is done automatically
	; since WAIT function is enabled.
	RET
	 
 
; synchronously reads a character from the serial port
; when a character is available, it's ASCII code is in A
dart_getChar:
	IN A, (DART_B_CMD)
	BIT 0, A
	JR Z, dart_getChar
	IN A, (DART_B_DAT)
	RET

		
dart_xoff:
	PUSH AF
	LD A, X_OFF
	OUT (DART_B_DAT), A
	POP AF
	RET
		
dart_xon:
	PUSH AF
	LD A, X_ON
	OUT (DART_B_DAT), A
	POP AF
	RET
	
; waits until the Tx buffer is empty	
dart_TxWait:
	LD A, 1				; select RR1
	OUT (DART_B_CMD), A
	IN A,(DART_B_CMD) 	; read RR1
	BIT 0, A			; check if ALL SENT bit is set
	JR Z, dart_TxWait	; wait if not
	RET
		
