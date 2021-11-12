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
        CALL hex2asc
        LD (IX+1), B
        LD (IX+2), C
        LD (IX+3), D
        LD (IX+4), E
        LD (IX+5), 0
        RET

; converts a byte to its hex representation in ASCII
; A - input byte
; result in DE
hex2asc:
        PUSH AF
        AND A         ; clear carry flag
        SRA A
        SRA A
        SRA A
        SRA A          ; upper nibble now in A
        CALL nibble2asc
        LD D, A
        POP AF       ;
        AND 00001111b  ; lower nibble now in A
        CALL nibble2asc
        LD E, A
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
