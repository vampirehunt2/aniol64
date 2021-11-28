;----------------------------------------------------
; Project: aniol64.zdsp
; File: mem.asm
; Date: 10/1/2021 15:20:21
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------

MemTest: defb "MemTest", 0
MemErr equ 1

; checks if NV RAM is installed
; returns 0 in C if non-volatile memory is found
; returns non-zero in A if data from previous run is not found
; this may happen if volatile RAM is installed
; or when it's the first run of the computer
memTest:
        LD IX, MemTest
        LD IY, TestAddr
        CALL str_cmp    ; checks if RAM already contains the test string
        CP 0
        RET Z           ; if test string found, return 0 in C
        LD IX, MemTest  ; otherwise copy it into the memory
        LD IY, TestAddr
        CALL str_copy
        LD A, MemErr
        RET

mem_cpy:
        RET

