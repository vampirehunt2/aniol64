; Signed 16-bit multiply: HL * BC → HL
; Carry flag set if overflow, clear otherwise
; device NOSLOT64K 

test_main:
    CALL cmd_bat
    RET


/*     LD HL, 1
    LD BC, 65535
    CALL u16_mul
    HALT

DIVBY0 equ 1
OVERFLOW equ 2
FORMATERR equ 3
OK equ 0

u16_mul:                          
    PUSH HL
    POP DE
    LD HL, 0
    LD A, 16
.loop:
    ADD HL,HL
    JR C, .overflow    ; carry out of HL → overflow
    RL E
    RL D
    JR NC, .noMul
    ADD HL,BC
    JR NC, .noMul
    INC DE                         ; This instruction (with the jump) is like an "ADC DE,0"
.noMul:
    DEC A
    JR NZ, .loop
    LD A, OK
    RET
.overflow:
    LD A, OVERFLOW
    RET


; divides two unsigned 16-bit integers
; arguments in HL and BC
; division result in DE
; mod result in HL
; errors reported in A
u16_div:
    LD A, B         ; checking if it's not a division by zero
    OR C
    JR NZ, .cont
    LD A, DIVBY0
    RET
.cont:
    PUSH HL
    PUSH BC
    POP DE
    POP BC
    LD HL,0
    LD A,B
    LD B,8
.loop1:
    RLA
    ADC HL,HL
    SBC HL,DE
    JR NC, .noAdd1
    ADD HL,DE
.noAdd1:
    DJNZ .loop1
    RLA
    CPL
    LD B,A
    LD A,C
    LD C,B
    LD B,8
.loop2:
    RLA
    ADC HL,HL
    SBC HL,DE
    JR NC, .noAdd2
    ADD HL,DE
.noAdd2:
    DJNZ .loop2
    RLA
    CPL
    LD B,C
    LD C,A
    PUSH BC
    POP DE
    RET */