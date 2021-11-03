;----------------------------------------------------
; Project: aniol64.zdsp
; File: clk.asm
; Date: 10/30/2021 17:44:36
;
; Created with zDevStudio - Z80 Development Studio.
;
; handles the DS1244 Phantom clock
;----------------------------------------------------

ClkScratchpad equ 8008h
ClkData equ 8009h
CLKMASK equ 00000001b

; Phantom clock recognition sequence
PhantomSeq: defb 0C5h, 03Ah, 0A3h, 05Ch, 0C5h, 03Ah, 0A3h, 05Ch, 0

; initiates the phantom clock mode
clk_on:
        LD BC, PhantomSeq
        LD DE, ClkScratchpad
        LD A, (DE)      ; any read operation will reset the
                        ; recognition register pointer
                        ; and therefore allow to initiate the
                        ; phantom clock recognition sequence of the DS1244
clk_onLoop:
        LD A, (BC)
        CP 0
        RET Z
        LD (DE), A
        SRA A
        LD (DE), A
        SRA A
        LD (DE), A
        SRA A
        LD (DE), A
        SRA A
        LD (DE), A
        SRA A
        LD (DE), A
        SRA A
        LD (DE), A
        SRA A
        LD (DE), A
        INC BC
        JP clk_onLoop

; writes 8 bytes of clock data from addresses wtarting with CLKDATA
; to a DS1244
clk_write:
        LD H, 8         ; loop counter
        LD BC, ClkData
        LD DE, ClkScratchpad
clk_writeLoop:
        LD A, (BC)
        LD (DE), A
        SRA A
        LD (DE), A
        SRA A
        LD (DE), A
        SRA A
        LD (DE), A
        SRA A
        LD (DE), A
        SRA A
        LD (DE), A
        SRA A
        LD (DE), A
        SRA A
        LD (DE), A
        INC BC
        DEC H   ; if we managed to write 8 bytes
        RET Z   ; then return from the subroutine
        JP clk_writeLoop        ; otherwise write next byte
        RET

; reads clock data from a DS1244 and puts it in 8 bytes starting with address CLKDATA
; must be preceded with clk_on
clk_read:
        LD BC, ClkData
        LD DE, ClkScratchpad
        LD A, 8 ; loop counter
clk_readLoop:
        PUSH AF
        CALL clk_readByte
        POP AF
        DEC A
        RET Z
        INC BC
        JP clk_readLoop

; Reads D0 8 times from a DS1244 and composes a byte out of the 8 reads
clk_readByte:
        LD H, 00000001b
clk_nextBit:
        LD L, H
        LD A, (DE)
        AND CLKMASK  ; clear all but D0
clk_shiftBits:
        SRA L           ; using L as loop counter
        JR Z, clk_storeBit ; when L has shifted all the way to zero, loop ends
        SLA A              ; while looping, A is shifted till the correct bit is set
        JP clk_shiftBits
clk_storeBit:
        LD L, A         ; shifting registers around
        LD A, (BC)      ; get previoud value stored
        OR L            ; add the newly read bit to it
        LD (BC), A      ; store the new value
        AND A           ; clear carry
        SLA H
        RET C           ; we stored all 8 bits
        JP clk_nextBit



