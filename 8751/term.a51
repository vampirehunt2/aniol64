;
$DATE (20/04/2025)
$TITLE ( )
$PAGELENGTH(56)
$PAGEWIDTH(150)
$DEBUG
$XREF
$NOLIST
$MOD51
$LIST
;

; **************************** macros ***************************************

lddptr      MACRO variable
    mov dpl, variable
    mov dph, variable + 1
ENDM


stdptr      MACRO variable
    mov variable, dpl
    mov variable + 1, dph
ENDM


; **************************** constants ***************************************

; 2k of external RAM mapped to start at 11100000-00000000
; which is E000h. 
; A12 low selects the RAM.
; high byte of the start of RAM in the memory map
RAMSTART EQU 0E0h
LINELEN EQU 80h

; An 8276 mappeding:
; #BUFFER_SELECT mapped to A15
; #CHIP_SELECT mapped to A14
; C/#P  mapped to A13
;                        AAAA
;                        1111
;                        5432
BS8276      EQU 07000h  ;01110000-00000000
COMM8276    EQU 08000h  ;10110000-00000000
PARAM8276   EQU 09000h  ;10010000-00000000

; zero-based index of the last row of the display
MAXROW      EQU 24


; **************************** variables ***************************************

; cursor coordinate
; only the column is required
; cursor only ever lives in the last row of the display
curscol     EQU 32

; 2 byte address of the start of the last line of display in memory
curstart    EQU 33

; 2 byte address of the next character to be sent to the 8276 buffer
curraddr    EQU 35

; 2 byte address of the start of the circular buffer 
; in the external RAM
bufstart    EQU 37



jmp main


; address 0003h 
; interrupt INT 0 handling routine
jmp fillbuff


initbuf:
    mov bufstart, #0
    mov bufstart + 1, #0
    mov curscol, #0
    ret

; initialises the serial port
initser:
    ; configure the UART
    mov SCON, #01000000b    ; mode 1 (8 bit timer controlled), 
                            ; multi processor disabled
                            ; receiver disabled ; TODO enable
    ; select the baudrate
    mov dptr, #BAUDRTS      
    mov a, P0
    anl a, #00000011b       ; mask off the bottom two bits, which represent the baudrate
    movc a, @a + dptr
    mov TH1, a              ; set the counter
    
    mov a, P0               
    anl a, #00001000b        ; mask off bit 3, which controls the baudrate frequency doubling
    jz initser0              ; skip the baudrate doubling if bit 3 is not set
    call dblbdrt
initser0:    
    ; configure the timer
    mov TMOD, #00100000b    ; GATE off
                            ; timer on, counter off
                            ; mode 2 (8 bit auto-reload)
    setb TR1                ; start timer 1
    
    ret
    
    
; doubles the baudrate
dblbdrt:
    mov a, PCON
    setb acc.7
    mov PCON, a
    ret  
    
    
scroll:
    mov dptr, #RAMSTART + 25 * 80
    movx a, @dptr

    ret


main:
; init code here:
    call initbuf
    call initser
; polling of the serial receiver   
loop:
    jmp loop
    

fillbuff:
    lddptr curraddr
    mov r0, #LINELEN
fbloop:
    movx a, @dptr
    movx BS8276, a ; TODO check the target address
    inc dptr
    djnz r0, fbloop
    stdptr curraddr
    reti
    
    
frameini:
    mov a, bufstart
    mov curraddr, a
    mov a, bufstart + 1
    mov curraddr + 1, a
    reti
    
; lookup table for baudrates  
; calculator: https://www.keil.com/products/c51/baudrate.asp  
BAUDRTS:
DB 0CEh    ; 260 baud
DB 0D5h    ; 300 baud
DB 0EFh    ; 766 baud
DB 0F5h    ; 1200 baud

END
    
