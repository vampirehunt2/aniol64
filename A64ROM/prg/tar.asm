; Project: aniol64
; tape archiver program
; 26/03/2026

; This program allows storing and loading text files through a serial interface. 
; running on the B port of the DART at 300baud.
; Connection parameters are
; 	- 1 stop bit
;	- no parity
; 	- 8bits per character

; MAN page for tar:
; File Archiver program
; Allows loading and storing files
; through a serial port.
; tar -s <file> 
; stores an existing file
; tar -l <file>
; creates a new text file and fills it with data loaded from the serial port
; tar -b<size> <file>
; created a new binary file of a given size and fills it with data loaded from the serial port


EOF equ 04h

tar_FileSize equ PROGRAM_DATA ; 2 bytes

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
    CP 'b'
    JR Z, tar_loadBin
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
    LD HL, FileBuffer
.loop:
    CALL dart_getChar
    CP EOF
    JR Z, .cont
    LD (HL), A
    INC HL
    JR .loop
.cont:
    LD BC, FileBuffer
    SUB HL, BC
    LD (CurrentFileSize), HL
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
	LD HL, (CurrentFileSize)
	LD IX, FileBuffer
.loop:
    XOR A	
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

tar_loadBin:
    INC IX                  ; skip over the '-'
    INC IX                  ; skip over the 'b'
    CALL str_tok
    PUSH HL
    CALL u16_parseDec
    CP 0
    JR NZ, .parseErr
    LD (tar_FileSize), HL        
    POP HL
    CALL str_shift
    CALL dos_touch
    CP DOS_OK
	JR NZ, .err
    LD BC, (tar_FileSize)
    LD HL, FileBuffer
.loop:
    LD A, B
    OR C
    JR Z, .cont
    CALL dart_getChar
    LD (HL), A
    INC HL
    DEC BC
    JR .loop
.cont:
    LD BC, FileBuffer
    SUB HL, BC
    LD (CurrentFileSize), HL
    CALL dos_saveFile
    CP DOS_OK
	JR NZ, .err
    RET
.parseErr:
    LD IX, InvVal
    CALL writeLn
    RET
.err:
	CALL dos_getStatusMsg
	CALL writeLn
    RET

