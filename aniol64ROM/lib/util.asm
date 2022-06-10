;----------------------------------------------------
; Project: aniol64.zdsp
; File: util.asm
; Date: 10/26/2021 17:23:49
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------

FALSE equ 00h
TRUE equ 0FFh
ERR equ 01h


; converts a two-digit hex number to a printable string
; BC - representation of one byte as two hex digits in ASCII
; result in string pointed to by IX
asc2hexstr8b:
        LD (IX+0), '$' ;arbitrary character indicating a hex number
        LD (IX+1), B
        LD (IX+2), C
        LD (IX+3), 0
        RET

; converts a four-digit hex number to a printable string
; BCDE - representation of two bytes as four hex digits in ASCII
; result in string pointed to by IX
asc2hexstr16b:
        LD (IX+0), '$' ;arbitrary character indicating a hex number
        CALL byte2asc
        LD (IX+1), B
        LD (IX+2), C
        LD (IX+3), D
        LD (IX+4), E
        LD (IX+5), 0
        RET

; converts a two digit hex number in ASCII to its value
; BA - two hex digits in ASCII
; result in B
PROC
asc2byte:
        PUSH AF
        LD A, B

        POP AF
        RET
ENDP

; parses a byte - two hex digits
; IX: null-terminated string containing the byte digits
; result in B
; parse errors reported in A
PROC
parseByte:
        CALL isByteStr
        CP 0
        JR Z, _parseError
        LD A, (IX + 0)
        CALL hexDigit2nibble
        SLA A
        SLA A
        SLA A
        SLA A
        LD B, A
        LD A, (IX + 1)
        CALL hexDigit2nibble
        OR B
        LD B, A
_parseOk:
        LD A, 0
        RET
_parseError:
        LD A, 1
        RET
ENDP

PROC
parseByteDec:
        RET
ENDP

; parses a double byte - four hex digits
; IX: null-terminated string containing the double byte digits
; result in HL
; parse errors reported in A
PROC
parseDByte:
        CALL isDByteStr
        CP 0
        JR Z, _parseError
        LD A, (IX + 0)
        CALL hexDigit2nibble
        SLA A
        SLA A
        SLA A
        SLA A
        LD B, A
        LD A, (IX + 1)
        CALL hexDigit2nibble
        OR B
        LD B, A
        LD A, (IX + 2)
        CALL hexDigit2nibble
        SLA A
        SLA A
        SLA A
        SLA A
        LD C, A
        LD A, (IX + 3)
        CALL hexDigit2nibble
        OR C
        LD C, A
        PUSH BC
        POP HL
_parseOk:
        LD A, 0
        RET
_parseError:
        LD A, 1
        RET
ENDP

PROC
hexDigit2nibble:
        CP 3Ah
        JR C, _numbers
        JR _letters
_numbers:
        SUB 30h
        RET
_letters:
        SUB 57h
        RET
ENDP

; checks if the byte in A is between 0 and 9 or between a dn f.
; only lowercase letters are supported
; result in A
PROC
isHexDigit:
        CP 30h
        JR C, _no ; if less than '0' then it's not a hex digit
        CP 67h
        JR NC, _no ; if equal or more than 'g' then it's not a hex digit
        CP 3Ah
        JR C, _yes ; if less than ':' (which is the next ascii code after '9' then it's a hex digit
        CP 61h
        JR C, _yes ; if equal or more than 'a' then it's a hex digit
_yes
        LD A, 1
        RET
_no
        LD A, 0
        RET
ENDP

; checks if the byte in A is between 0 and 9
; result in A
PROC
isDecDigit:
        CP 30h
        JR C, _no ; if less than '0' then it's not a hex digit
        CP 3Ah
        JR C, _yes ; if less than ':' (which is the next ascii code after '9' then it's a hex digit
        JR _no
_yes
        LD A, 1
        RET
_no
        LD A, 0
        RET
ENDP

; checks if a string represents a two-byte hex value
; IX - address of the input string
; result in A: 0 - false, 1 - true
PROC
isDByteStr:
        CALL str_len
        CP 4              ; checks if the string is exactly 4 digits
        JR NZ, _parseError
        LD A, (IX+0)
        CALL isHexDigit
        CP 0
        JR Z, _parseError
        LD A, (IX+1)
        CALL isHexDigit
        CP 0
        JR Z, _parseError
        LD A, (IX+2)
        CALL isHexDigit
        CP 0
        JR Z, _parseError
        LD A, (IX+3)
        CALL isHexDigit
        CP 0
        JR Z, _parseError
        LD A, 1
        RET
_parseError:
        LD A, 0
        RET
ENDP

; checks if a string represents a one-byte hex value
; IX - address of the input string
; result in A: 0 - false, 1 - true
PROC
isByteStr:
        CALL str_len
        CP 2              ; checks if the string is exactly 2 digits
        JR NZ, _parseError
        LD A, (IX+0)
        CALL isHexDigit
        CP 0
        JR Z, _parseError
        LD A, (IX+1)
        CALL isHexDigit
        CP 0
        JR Z, _parseError
        LD A, 1
        RET
_parseError:
        LD A, 0
        RET
ENDP

PROC
isByteDecStr:
        CALL str_len
        CP 4
        LD A, 1
        RET
_parseError:
        LD A, 0
        RET
        RET
ENDP

; converts a byte to its hex representation in ASCII
; A - input byte
; result in BA
byte2asc:
        PUSH AF
        AND A         ; clear carry flag
        SRA A
        SRA A
        SRA A
        SRA A
        AND 00001111b  ; upper nibble now in A
        CALL nibble2asc
        LD B, A
        POP AF       ;
        AND 00001111b  ; lower nibble now in A
        CALL nibble2asc
        RET

; A - nibble to convert to an ASCII hex digit
; result in A
nibble2asc:
        AND A   ; clear carry flag
        CP 0Ah  ; checks if nibble is 0-9
        JR C, numbers
        AND A   ; clear carry flag
        SUB 0Ah
        ADD A, 61h ; ASCII code for 'A'
        RET
numbers:
        AND A   ; clear carry flag
        ADD A, 30h ; ASCII code for '0'
        RET



; A - the binary number to convert
; Result:
; hundreds in C
; tens in B
; units in A
PROC
bin2Bcd:
        LD B, 0
        LD C, 0
_hundreds:
        CP 100
        JR C, _tens   ; if less than 100
        SUB 100
        INC C         ; hundreds counted in C
        JR _hundreds
_tens:
        CP 10
        JR C, _units   ; if less than 10
        SUB 10
        INC B           ; tens and hundreds counted in B
        JR _tens
_units:                 ; least significant digit now in A
        RET
ENDP

; converts a bcd number stored in C, B, A to ASCII
; result in C, B, A
PROC
bcd2asc:
        PUSH AF
        LD A, C
        ADD A, 30h        ; ASCII code of the digit 0
        LD C, A
        LD A, B
        ADD A, 30h        ; ASCII code of the digit 0
        LD B, A
        POP AF
        ADD A, 30h        ; ASCII code of the digit 0
        RET
ENDP

; A - delay x10ms
delay:
        CP 0
        RET Z
        DEC A
        CALL delay10ms
        JP delay

; waits for 37us * 2.5MHz = 92 clock cycles
; which is just 16 NOPs, 4 cycles each
; plus 10 cycles for the RET
; plus 17 cycles to CALL this routine
delay37us:
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
		NOP
		NOP
		NOP
		NOP
		NOP
        RET

; waits for 1520us,
; which is 22 calls to delay37us
delay1520us:
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        RET

delay10ms:
        CALL delay1520us
        CALL delay1520us
        CALL delay1520us
        CALL delay1520us
        CALL delay1520us
        CALL delay1520us
        CALL delay1520us
        CALL delay1520us
        RET

defb "Rnd"
PROC
rnd:
        PUSH BC
        LD A, (Random)
        CP 0               ; if Random is unitialised
        JR NZ, _doRnd
        LD A, (Random + 1)  ; checking both bytes of Random for 0
        CP 0
        CALL Z, randomize  ; we initialise it
_doRnd:
        AND A ; clear carry
        LD A, (Random + 1) ; load high byte of Random in case randomize overworte it
         ; first we XOR bit 2 with bit 0
        SLA A
        SLA A
        SLA A
        SLA A
        SLA A ; bit 2 now in bit 7
        LD B, A
        SLA A
        SLA A ; bit 0 now in bit 7
        XOR B ; XORing bit 2 and 0 together
        AND 10000000b ; discarding lower bits
        LD B, A
        LD A, (Random + 1)
        SLA A  ; processing bit 3
        SLA A
        SLA A
        SLA A
        XOR B
        AND 10000000b
        LD B, A
        LD A, (Random + 1)
        SLA A ; processing bit 5
        SLA A
        XOR B
        AND 10000000b ; all bits now XORed and in bit 7
        SLA A ; moving bit 7 to carry
        LD A, (Random)
        RRA
        LD (Random), A
        LD A, (Random + 1)
        RRA
        LD (Random + 1), A
        POP BC
        RET
ENDP


randomize:
		PUSH HL
		PUSH AF
        LD A, (NmiCount)
        CP 0
        JR Z, randomize
        LD HL, (NmiCount)
		LD (Random), HL
		POP AF
		POP HL
        RET
