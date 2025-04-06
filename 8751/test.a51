;
$DATE (24/11/2023)
$TITLE ( )
$PAGELENGTH(56)
$PAGEWIDTH(150)
$DEBUG
$XREF
$NOLIST
$MOD51
$LIST
;

; 32 bytes of rythm pattern: 
; 16 bytes for the main pattern
source EQU 40h 


; 16 bytes for the fill pattern
target EQU 50h 


; rotates an 8x8 bit array
rotate:
    mov r1, #target
    mov r2, #00000001b
    mov r4, #0
rt1:
    mov r6, #0
    mov r0, #source
    mov r3, #00000001b
    mov r5, #0
rt2:
    mov a, @r0
    anl a, r2
    jnz rtsetbit
    jmp rtcont
rtsetbit:
    mov a, r6
    orl a, r3 
    mov r6, a
rtcont:
    mov a, r3
    clr c
    rlc a
    mov r3, a
    inc r0
    inc r5
    cjne r5, #8, rt2
    ;
    mov a, r2
    clr c
    rlc a
    mov r2, a
    mov a, r6
    mov @r1, a
    inc r1
    inc r4
    cjne r4, #8, rt1
    ret

 END
    
    
    
       
