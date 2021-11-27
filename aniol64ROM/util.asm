;----------------------------------------------------
; Project: aniol64.zdsp
; File: util.asm
; Date: 10/26/2021 17:23:49
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------


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

; parses a double byte - four hex digits
; IX: null-terminated string containing the double byte digits
; result in HL
; parse errors reported in A
defb "parseDByte"
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

PROC
isDByteStr:
        PUSH IX
        CALL str_len
        POP IX
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

; waits for 37us * 1,8432MHz = 69 clock cycles
; which is just 11 NOPs, 4 cycles each
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
        RET

; waits for 1520us,
; which is 22 calls to lcd_delay37us
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
