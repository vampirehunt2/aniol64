;
$DATE (02/03/2025)
$TITLE ( )
$PAGELENGTH(56)
$PAGEWIDTH(150)
$DEBUG
$XREF
$NOLIST
$MOD51
$LIST
;


; index of the next note to play    
currnote EQU 32   

; currently selected instrument index
currinst EQU 33

; pattern offset. used for programming
; 0 for the first half of the pattern
; 8 for the second half of the pattern
pattoffs EQU 34

; source address for matrix rotation
source EQU 35

; target address for matrix rotation
target EQU 36

; 16 bytes for the rythm pattern
pattern EQU 48  


                    

jmp main


; address 0003h 
; interrupt INT 0 handling routine
jmp handlint


main:
; init code goes here
    mov P1, #00000011b     ; disable all button buffers and LED latches         
    mov IE, #10000001b     ; enable external interrupt INT0
    mov TCON, #00000001b   ; set INT0 to be edge-triggerred
    mov currnote, #0       ; sets the note counter to the beginning of the pattern
    call clrpatt
    
    

    
    
; this routine scans all the rythm input buttons
; buttons are connected to P0
; LEDs are also connected to P0
; gate latch is also connected to P0
; buttons 0-7 are scanned with P1.0
; buttons 8-15 are scanned with P1.1
; LEDs 0-7 are latched with P1.2
; LEDs 8-15 are latched with P1.3
; gate latch is written to with P1.4
; instrument selector is connected to P2
mainloop:
    call getinst        ; first, check the currently selected instrument
    call scan07
    call leds07
    call scan815
    call leds815
    jmp mainloop       ; loop
    
    

clrpatt:
    mov r0, #pattern
    mov r1, #32
cploop:
    mov @r0, #0
    dec r1
    jnz cploop 
    ret
    

leds07:
    mov a, #pattern
    add a, currinst
    mov r0, a
    mov a, @r0
    mov P0, a
    setb P1.2
    nop
    clr P1.2
    ret
    
    
    
leds815:
    mov a, #pattern + 8
    add a, currinst
    mov r0, a
    mov a, @r0
    mov P0, a
    setb P1.3
    nop
    clr P1.3
    ret
    

  

; scans buttons 0-7
; result in a
scan07:
    clr P1.0                ; enable the button 0-7 buffer
    mov pattoffs, #0
    mov source, #pattern
    mov target, #pattern + 16
    jmp scan

; scans buttons 8-15
; result in a
scan815:
    clr P1.1                ; enable the button 8-15 buffer
    mov pattoffs, #8
    mov source, #pattern + 8
    mov target, #pattern + 24
;   jmp scan                ; redundant jump, falling through to scan
    
scan:
    mov a, #pattern
    add a, pattoffs
    add a, currinst
    mov r0, a
    mov a, P0               ; read in the state of the buttons
    jz scanend              ; check if any buttons pressed, inf not, end routine
    mov r1, a               ; save pressed buttons in r1
scanloop:
    mov a, P0               ; wait until the button is depressed (for debouncing)
    jnz scanloop
    mov a, r1               ; restore pressed buttons from r1
    xrl a, @r0              ; flip the relevant bit in the note pattern
    mov @r0, a              ; store the note pattern with the bot flipped
    call rotate             ; generate note pattern from the rythm pattern
scanend:
    setb P1.0               ; disable both input buffers
    setb P1.1
    ret  
    
; returns the leds for the current instrument in a
getleds:
    mov a, #pattern
    add a, pattoffs
    add a, currinst
    mov r0, a
    mov a, @r0
    ret
    
; encode instrument
; instrument selector is connected to P2    
getinst:
    mov a, P2
    mov r2, a
    mov r0, #00000001b
    mov r1, #0
eiloop:
    anl a, r0
    jnz eiend
    inc r1
    clr c
    mov a, r2
    rlc a
    mov r2, a
    jmp eiloop
eiend:
    mov currinst, r1
    ret
    
    
; rotates an 8x8 bit array
rotate:
    mov r1, target
    mov r2, #00000001b
    mov r4, #0
rt1:
    mov r6, #0
    mov r0, source
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
    
    
; interrupt handling
handlint:
    push psw
    push acc
    mov a, r0
    push acc
    call play
    pop acc
    mov r0, a
    pop acc
    pop psw
      
     
; play a note from the pattern
play:
    mov a, #pattern + 16; load the beginning of the rotated pattern to a
    add a, currnote     ; point a to the current note in the pattern
    mov r0, a           ; point r0 to the current note in the pattern
    mov a, @r0          ; load the curent pattern step to a
    mov P0, a           ; write out the current pattenr step to P0
    setb P1.4           ; toggle the gathe latch clock
    nop
    clr P1.4
    anl a, #10000000b   ; check if reached the end of the pattern
    jnz pattend         ; if so, end the pattern
    mov a, currnote     ; move to the next note in the pattern
    inc a
    mov currnote, a
    subb a, #16         ; check if reached the last note of the pattern
    jz pattend          ; if so, end the pattern
    ret
pattend:
    mov currnote, #0    ; reset current note to the beginning of the pattern
    ret
    
END
