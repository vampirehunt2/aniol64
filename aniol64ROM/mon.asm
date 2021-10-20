;----------------------------------------------------
; Project: aniol64.zdsp
; File: mon.asm
; Date: 9/22/2021 13:36:12
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
        CALL hex2asc
        LD (IX+1), B
        LD (IX+2), C
        LD (IX+3), D
        LD (IX+4), E
        LD (IX+5), 0
        RET

; converts a byte to its hex representation in ASCII
; B - input byte
; result in CD
hex2asc:
        LD A, B
        AND A         ; clear carry flag
        RRA
        RRA
        RRA
        RRA           ; upper nibble now in A
        CALL nibble2asc
        LD C, A
        LD A, B       ;
        AND 00001111  ; lower nibble now in A
        CALL nibble2asc
        LD D, A
        RET

; A - nibble to convert to an ASCII hex digit
; result in A
nibble2asc:
        AND A   ; clear carry flag
        CP 0Ah  ; checks if nibble is 0-9
        JR C, numbers
        AND A   ; clear carry flag
        SUB 0Ah
        ADD A, 41h ; ASCII code for 'A'
        RET
numbers:
        AND A   ; clear carry flag
        ADD A, 30h ; ASCII code for '0'
        RET




