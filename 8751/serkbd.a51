;
$DATE (11/01/2024)
$TITLE ( )
$PAGELENGTH(56)
$PAGEWIDTH(150)
$DEBUG
$XREF
$NOLIST
$MOD51
$LIST
;

scancode EQU 100            ; arbitrary iram location
DB 0


MAIN:
    call INITSER
MAINLOOP:
    call GETSCNCD
    call SCN2ASC
    call SENDCHAR
    jmp MAINLOOP
    
    
; initialises the serial port
INITSER:
    ; configure the UART
    mov SCON, #01000000b    ; mode 1 (8 bit timer controlled), 
                            ; multi processor disabled
                            ; receiver disabled
    ; select the baudrate
    mov dptr, #BAUDRTS      
    mov a, P0
    anl a, #00000011b       ; mask off the bottom two bits, which represent the baudrate
    movc a, @a + dptr
    mov TH1, a              ; set the counter
    
    ; configure the timer
    mov TMOD, #00100000b    ; GATE off
                            ; timer on, counter off
                            ; mode 2 (8 bit auto-reload)
    setb TR1                ; start timer 1
    
    ret
    
    
; sends a character through the serial port
SENDCHAR:
    clr TI   
    mov SBUF, a
    jnb TI, $
    ret
    

; get scancode
; result: in a
GETSCNCD:
    call SCAN
    cjne a, #0, GETSCNCD    ; wait until no button pressed
GSCDWAIT:
    call SCAN
    cjne a, #0, GSCDFND     ; scancode found
    jmp GSCDWAIT
GSCDFND:
    mov scancode, a         ; save the scancode for later
    call DELAY
    call SCAN               ; check if the same button is still pressed
    cjne a, scancode, GSCDFND    ; this is for debouncing
    cjne a, #0, GSCEND
    JMP GETSCNCD
GSCEND:                     ; if we made it this far, this means a 
                            ; valid decoded row number is now in a
    call ENCDROW
    call ASMSCNCD
    ret
                            

; encode row
; decoded row number in a
; result in r0
ENCDROW:
    mov r0, #0
ECRWLOOP:
    clr C
    rrc a
    cjne a, #0, ECRWLOO1
    jmp ECRWEND
ECRWLOO1:
    inc r0
    jmp ECRWLOOP
ECRWEND:
    ret
    

; assembles scancode out of row, column and modifier keys
ASMSCNCD:
    mov a, r0           ; load the encoded row number to a
    clr C               ; clear carry
    rlc a               ; move the row number to bits 3-5
    rlc a
    rlc a
    orl a, r1           ; set the column number to bits 0-2
    mov r0, a
    mov a, p1           ; read the key input to extract modifier keys from it
    cpl a               ; switch to positive logic
    anl a, #01100000b   ; mask off the modifier keys
    clr C
    rlc a
    orl a, r0
    ret
    
    
; scan for a button pressed   
; return 
;   - encoded row in a in positive logic
;   - decoded number column in r1 
SCAN:
    mov r0, #01111111b      ; decoded column
    mov r1, #8              ; loop counter
SCANLOOP:
    mov p2, r0
    mov a, p1
    cpl a                   ; from now on, operate on positive logic
    anl a, #00011111b       ; mask of the modifier bits and the unused bit7
    cjne a, #0, SCANFND     ; check if any button is pressed
    setb C                  ; set carry
    mov a, r0
    rrc a   
    mov r0, a        
    djnz r1, SCANLOOP
    mov a, #0               ; no button pressed
    ret
SCANFND:
    dec r1
    ret


; converts scancode to ASCII code
; scancode in a
; result in a
SCN2ASC:
    mov dptr, #ASCII
    movc a, @a + dptr
    ret



; delays execution  
DELAY:
    mov r2, #255
DELAY2:
    mov r3, #32
DELAY3:
    djnz r3, DELAY3
    djnz r2, DELAY2    
    ret
 
    
; lookup table for baudrates  
; calculator: https://www.keil.com/products/c51/baudrate.asp  
BAUDRTS:
DB 0CEh    ; 260 baud
DB 0D5h    ; 300 baud
DB 0EFh    ; 766 baud
DB 0F5h    ; 1200 baud

    
; lookup table for converting scancodes to ASCII characters
ASCII:
        ;  m  r   c
        ;  o  o   o
        ;  d  w   l
DB '1'  ; 00-000-000
DB '2'  ; 00-000-001
DB '3'  ; 00-000-010
DB '4'  ; 00-000-011
DB '5'  ; 00-000-100
DB '6'  ; 00-000-101
DB '7'  ; 00-000-110
DB '8'  ; 00-000-111

DB 'q'  ; 00-001-000
DB 'w'  ; 00-001-001
DB 'e'  ; 00-001-010
DB 'r'  ; 00-001-011
DB 't'  ; 00-001-100
DB 'y'  ; 00-001-101
DB 'u'  ; 00-001-110
DB 'i'  ; 00-001-111

DB 'a'  ; 00-010-000
DB 's'  ; 00-010-001
DB 'd'  ; 00-010-010
DB 'f'  ; 00-010-011
DB 'g'  ; 00-010-100
DB 'h'  ; 00-010-101
DB 'j'  ; 00-010-110
DB 'k'  ; 00-010-111

DB 0    ; 00-011-000
DB 'z'  ; 00-011-001
DB 'x'  ; 00-011-010
DB 'c'  ; 00-011-011
DB 'v'  ; 00-011-100
DB 'b'  ; 00-011-101
DB 'n'  ; 00-011-110
DB 'm'  ; 00-011-111

DB 0    ; 00-100-000
DB '0'  ; 00-100-001
DB 'p'  ; 00-100-010
DB 10   ; 00-100-011
DB ' '  ; 00-100-100
DB 'l'  ; 00-100-101
DB 'o'  ; 00-100-110
DB '9'  ; 00-100-111

DB 0    ; 00-101-000
DB 0    ; 00-101-001
DB 0    ; 00-101-010
DB 0    ; 00-101-011
DB 0    ; 00-101-100
DB 0    ; 00-101-101
DB 0    ; 00-101-110
DB 0    ; 00-101-111

DB 0    ; 00-110-000
DB 0    ; 00-110-001
DB 0    ; 00-110-010
DB 0    ; 00-110-011
DB 0    ; 00-110-100
DB 0    ; 00-110-101
DB 0    ; 00-110-110
DB 0    ; 00-110-111

DB 0    ; 00-111-000
DB 0    ; 00-111-001
DB 0    ; 00-111-010
DB 0    ; 00-111-011
DB 0    ; 00-111-100
DB 0    ; 00-111-101
DB 0    ; 00-111-110
DB 0    ; 00-111-111

; SHIFT
DB '!'  ; 01-000-000
DB '"'  ; 01-000-001
DB '#'  ; 01-000-010
DB '$'  ; 01-000-011
DB '%'  ; 01-000-100
DB '&'  ; 01-000-101
DB '/'  ; 01-000-110
DB '('  ; 01-000-111

DB 'Q'  ; 01-001-000
DB 'W'  ; 01-001-001
DB 'E'  ; 01-001-010
DB 'R'  ; 01-001-011
DB 'T'  ; 01-001-100
DB '^'  ; 01-001-101
DB '~'  ; 01-001-110
DB '|'  ; 01-001-111

DB 'A'  ; 01-010-000
DB 'S'  ; 01-010-001
DB 'D'  ; 01-010-010
DB 'F'  ; 01-010-011
DB 'G'  ; 01-010-100
DB 'H'  ; 01-010-101
DB 'J'  ; 01-010-110
DB 'K'  ; 01-010-111

DB 0    ; 01-011-000
DB 'Z'  ; 01-011-001
DB 'X'  ; 01-011-010
DB 'C'  ; 01-011-011
DB 'V'  ; 01-011-100
DB 'B'  ; 01-011-101
DB 'N'  ; 01-011-110
DB 'M'  ; 01-011-111

DB 0    ; 01-100-000
DB '='  ; 01-100-001
DB 'P'  ; 01-100-010
DB ','  ; 01-100-011
DB 8    ; 01-100-100 BACKSPACE
DB 'L'  ; 01-100-101
DB 'O'  ; 01-100-110
DB ')'  ; 01-100-111

DB 0    ; 01-101-000
DB 0    ; 01-101-001
DB 0    ; 01-101-010
DB 0    ; 01-101-011
DB 0    ; 01-101-100
DB 0    ; 01-101-101
DB 0    ; 01-101-110
DB 0    ; 01-101-111

DB 0    ; 01-110-000
DB 0    ; 01-110-001
DB 0    ; 01-110-010
DB 0    ; 01-110-011
DB 0    ; 01-110-100
DB 0    ; 01-110-101
DB 0    ; 01-110-110
DB 0    ; 01-110-111

DB 0    ; 01-111-000
DB 0    ; 01-111-001
DB 0    ; 01-111-010
DB 0    ; 01-111-011
DB 0    ; 01-111-100
DB 0    ; 01-111-101
DB 0    ; 01-111-110
DB 0    ; 01-111-111

; FUNC
DB 0    ; 10-000-000
DB 0    ; 10-000-001
DB 0    ; 10-000-010
DB 0    ; 10-000-011
DB 0    ; 10-000-100
DB 0    ; 10-000-101
DB '{'  ; 10-000-110
DB '['  ; 10-000-111

DB '@'  ; 10-001-000
DB 'W'  ; 10-001-001
DB 'E'  ; 10-001-010
DB 'R'  ; 10-001-011
DB '~'  ; 10-001-100
DB 'Y'  ; 10-001-101
DB 'U'  ; 10-001-110
DB '*'  ; 10-001-111

DB '+'  ; 10-010-000
DB '-'  ; 10-010-001
DB 'D'  ; 10-010-010
DB 'F'  ; 10-010-011
DB ';'  ; 10-010-100
DB ':'  ; 10-010-101
DB 17   ; 10-010-110 UP
DB 'K'  ; 10-010-111

DB 0    ; 10-011-000
DB '<'  ; 10-011-001
DB '>'  ; 10-011-010
DB '?'  ; 10-011-011
DB '.'  ; 10-011-100
DB 18   ; 10-011-101 LEFT
DB 19   ; 10-011-110 DOWN
DB 20   ; 10-011-111 RIGHT

DB 0    ; 10-100-000
DB '}'  ; 10-100-001
DB 'P'  ; 10-100-010
DB 13   ; 10-100-011
DB 8    ; 10-100-100 BACKSPACE
DB '_'  ; 10-100-101
DB 'O'  ; 10-100-110
DB ']'  ; 10-100-111
    
END
     
