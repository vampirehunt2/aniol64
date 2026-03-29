; Signed 16-bit multiply: HL * BC → HL
; Carry flag set if overflow, clear otherwise
 device NOSLOT64K 

test_main:
    LD DE, 100
    LD BC, 15
;
; Multiply 16-bit values (with 16-bit result)
; In: Multiply BC with DE
; Out: HL = result
;
Mult16:
    ld a,b
    ld b,16
Mult16_Loop:
    add hl,hl
    sla c
    rla
    jr nc,Mult16_NoAdd
    add hl,de
Mult16_NoAdd:
    djnz Mult16_Loop
    ret
