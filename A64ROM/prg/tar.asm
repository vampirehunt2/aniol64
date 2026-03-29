; Project: aniol64
; tape archiver program
; 26/03/2026

; This program allows storing and loading text files through a serial interface. 
; running on the B port of the DART at 300baud.
; Connection parameters are
; 	- 2 stop bits
;	- even parity
; 	- 8bits per character
; It uses software handshaking with Xon/Xoff on the receiving side.
; It uses no handshaking on the transmitting side, assuming the 
; computer on the other side is able to handle keyclicks in time.
; There is no teardown procedure implemented at this point,
; to exit the terminal program you have to reset the machine.

EOF equ 04h
tarHelp db "tar -s/-l <filename>", 0
 

tar_main:
    PUSH IX             ; save pointers to command line arguments
    PUSH HL
    CALL dart_init      ; initialise the serial interface
    POP HL              ; save pointers to command line arguments
    POP IX
    CALL str_shift      ; move IX to the first argument
    LD A, (IX)
    CP '-'
    JR NZ, .help
    LD A, (IX + 1)
    CP '?'
    JR Z, .help
    CP 's'
    JR Z, tar_store
    CP 'l'
    JR Z, tar_load
// run through, show help if the argument is not -s or -l
.help:
    LD IX, tarHelp
    CALL writeStr
    CALL nextLine
    RET


tar_load:
    CALL str_tok        
    CALL str_shift
    CALL dos_touch
    CP DOS_OK
	JR NZ, .err
.loop:
    CALL dart_getChar
    CP EOF
    JR Z, .cont
    CALL dos_fWrite
    JR .loop
.cont:
    CALL dos_saveFile
    CP DOS_OK
	JR NZ, .err
    RET
.err:
	CALL dos_getStatusMsg
	CALL writeLn
    RET

tar_store:
    CALL str_tok        
    CALL str_shift
	CALL dos_loadFile
	LD A, (DosErr)
	CP DOS_OK
	JR NZ, .err
	LD BC, (CurrentFileSize)
	LD IX, FileBuffer
.loop:
	LD A, 0
	CP H
	JR NZ, .cont
	CP L
	JR NZ, .cont
    LD A, EOF
    CALL dart_putChar
	RET
.cont:
	LD A, (IX)
	CALL dart_putChar
	INC IX
	DEC HL
	JR .loop
.err:
	CALL dos_getStatusMsg
	CALL writeLn
    RET

