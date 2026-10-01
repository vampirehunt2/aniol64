; Software for the 8085/8276 terminal
; written in Z80 assembly, 
; being careful to only use 8085-compatible instructions.

 device NOSLOT64K 

 ; 8085 special instructions *********************************************************************
; defines the two 8085-specific instructions
; that the Z80 assembler doesn't understand
RIM equ 020h
SIM equ 030h


; bitmasks for the SIM instruction ***************************************************************
; https://www.tutorialspoint.com/article/sim-instruction-in-8085
SOD equ 10000000b           ; serial output bit 
SOE equ 01000000b           ; serial output enabled
; bit 5 is a "don't care"
R75 equ 00010000b           ; reset RST 7.5 flip-flop
MSE equ 00001000b           ; mask set enable
M75 equ 00000100b           ; mask the RST 7.5 interrupt
M65 equ 00000010b           ; mask the RST 6.5 interrupt
M55 equ 00000001b           ; mask the RST 5.5 interrupt


; 8085 interrupt addresses ************************************************************************
RST55 equ 002Ch
RST65 equ 0034h
RST75 equ 003Ch


; Intel 8276 commands ****************************************************************************
CRT_RESET  equ 00h          ; reset command
CRT_START  equ 20h          ; start display command
CRT_STOP   equ 40h          ; stop display command
CRT_CURSOR equ 80h          ; load cursor command
CRT_EI     equ 0A0h         ; enable interrupts command
CRT_DI     equ 0C0h         ; disable interrupts command


; port numbers ***********************************************************************************
CRT_PARAM  equ 00000000b    ; the parameter register of the 8276
CRT_CMD    equ 00000001b    ; the command register of the 8276
CRT_STATUS equ 00000001b    ; the status register of the 8276 
                            ; same address as command register,
                            ; but read from rather than written to 
CRT_BUFF   equ 01000000b    ; buffer select for the 8276 


; Intel 8276 screen composition bytes ************************************************************
; according to VGA timing: http://microvga.com/vga-timing/640x480@60Hz
;
; General timing
; Screen refresh rate	60 Hz
; Vertical refresh	    31.46875 kHz
; Pixel freq.	        25.175 MHz
;
; Horizontal timing (line)
; Polarity of horizontal sync pulse is negative.
; Scanline part	Pixels	Time [µs]
; Visible area	640	    25.422045680238
; Front porch	16	    0.63555114200596
; Sync pulse	96	    3.8133068520357
; Back porch 	48	    1.9066534260179
; Whole line	800	    31.777557100298
;
; Vertical timing (frame)
; Polarity of vertical sync pulse is negative.
; Frame part	Lines	Time [ms]
; Visible area	480	    15.253227408143
; Front porch	10	    0.31777557100298
; Sync pulse	2	    0.063555114200596
; Back porch	33	    1.0486593843098
; Whole frame	525	    16.683217477656

; B7    normal rows (not spaced)
; B6:0  40 characters per row 
SCREEN_COMP_BYTE1 equ 39   

; B7:6  2 rows of vertical retrace
; B5:0  31 rows per frame
;       30 display rows and one for the front porch               
SCREEN_COMP_BYTE2 equ 01000000b + 30      
                            
; B7:4  underline in last line
; B3:0  16 lines per row
SCREEN_COMP_BYTE3 equ 0FFh  

; B7    Non-offset mode for addressing the character generator
; B5:4  Blinking reverse video block cursor
; B3:0  10 character-long horizontal retrace 
SCREEN_COMP_BYTE4 equ 01000100b           


; memory map **************************************************************************************
RAM     equ 8000h           ; beginning of RAM
STACK   equ RAM + 2048 - 1  ; top of RAM


; variables for the program ***********************************************************************
;CharFeed   equ RAM + 00h    ; pointer into the screen memory 
                            ; indicating next character to be fed to the 8276
                            ; 2 bytes

CursorAddr  equ RAM + 02h   ; pointer into the screen memory
                            ; indicating the position at which next character
                            ; is to be inserted from the UART
                            ; 2 bytes

Screen      equ RAM + 20h   ; screen memory

LINE_LEN    equ 40          ; number of character in a row
LINE_NUM    equ 30          ; number of rows
SCREEN_SIZE equ LINE_LEN * LINE_NUM ; size of the Screen memory, 
                            ; ignoring the extra line used for the front porch


; ************************************************************************************************
; ************************* Start of program *****************************************************
; ************************************************************************************************
 org 0000h  ; cold boot
    
    LD SP, STACK
    LD A, 0 | MSE | M65     ; mask RST 6.5, unmask RST 5.5 and RTS 7.5
 db SIM                     ; Z80 assembler doesn't recognise the SIM instruction
    CALL init
    EI
    JP main

; RST 5.5 interrupt controls the vertical blanking interrupt
; from the 8276
 ds RST55 - $, 0
    IN A, (CRT_STATUS)      ; clear the interrupt
    LD HL, TEST_SCREEN      ; point HL to the beginning of screen memory
    EI
    RET

; RST 7.5 responds to the Buffer Ready signal from the 8276
; it sends one row of character data, incrementing HL each time
; the loop is completely unrolled for performance
 ds RST75 - $, 0
    ;LD HL, (CharFeed)       ; load the current pointer into the screen memory
    ; repeat 40 times
    LD A, (HL)              ; load a character from the screen memory
    OUT (CRT_BUFF), A       ; send it to the 8276 buffer
    INC HL                  ; move to the next character
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL 
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL 
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL 
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL 
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL 
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL 
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL 
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL 
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL                
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL 
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL 
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL 
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL 
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL 
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL 
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL 
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL 
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL 
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL 
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL 
    LD A, (HL)              
    OUT (CRT_BUFF), A       
    INC HL
    ; done with 40 iterations
    OUT (CRT_BUFF), A ; send out the last character again. This will form the front porch
    LD A, R75   ; reset the interrupt flip-flop
 db SIM         ; Z80 assembler doesn't recognise the SIM instruction
    EI
    RET

    ; DEBUG
    ;LD A, 11110001b     ; end of row, stop loading
    ;OUT (CRT_BUFF), A
    ;OUT (CRT_BUFF), A   ; dummy character required after the end-of-row 
    ;LD (CharFeed), HL   ; store the current pointer into the screen memory
    ;EI
    ;RET
    ; /DEBUG

; initialise the hardware
init:
    CALL init8276
    CALL init8251
    RET

    
; initialise the CRT controller
init8276:
    ; set screen composition
    LD A, CRT_RESET
    OUT (CRT_CMD), A
    LD A, SCREEN_COMP_BYTE1
    OUT (CRT_PARAM), A
    LD A, SCREEN_COMP_BYTE2
    OUT (CRT_PARAM), A
    LD A, SCREEN_COMP_BYTE3
    OUT (CRT_PARAM), A
    LD A, SCREEN_COMP_BYTE4
    OUT (CRT_PARAM), A
    
    ; enable interrupts
    LD A, CRT_EI
    OUT (CRT_CMD), A
    
    ; start display
    LD A, CRT_START
    OUT (CRT_CMD), A
    RET

; initialise the UART
init8251:
    RET

; main program loop
; TODO: 
; queries the 8251 for new characters received
; and puts them into the screen memory - if they're characters
; or processes them - if they're escape codes.
main:
    HALT
    JP main

clrScr:
    PUSH HL
    PUSH BC
    PUSH AF
    LD HL, Screen
    LD BC, SCREEN_SIZE
.loop
    LD (HL), 0
    INC HL
    DEC BC
    LD A, B
    OR C
    CP 0
    JR NZ, .loop
    POP AF
    POP BC
    POP HL
    RET

scroll:
    PUSH HL
    PUSH BC
    PUSH DE
    PUSH AF
    LD HL, Screen
    LD DE, Screen + LINE_LEN
    LD BC, SCREEN_SIZE - LINE_LEN
.loop
    LD A, (DE)
    LD (HL), A
    INC HL
    INC DE
    DEC BC
    LD A, B
    OR C
    CP 0
    JR NZ, .loop
    POP AF
    POP DE
    POP BC
    POP HL
    RET

 ds 2048 - $, 0
TEST_SCREEN:
 db "0123456789012345678901234567890123456789"
 db "test1test2test3test4test5test6test7test8"
 db "2345678901234567890123456789012345678901"
 db "3456789012345678901234567890123456789012"
 db "4567890123456789012345678901234567890123"
 db "5678901234567890123456789012345678901234"
 db "6789012345678901234567890123456789012345"
 db "7890123456789012345678901234567890123456"
 db "8901234567890123456789012345678901234567"
 db "9012345678901234567890123456789012345678"
 db "0123456789012345678901234567890123456789"
 db "1234567890123456789012345678901234567890"
 db "2345678901234567890123456789012345678901"
 db "3456789012345678901234567890123456789012"
 db "4567890123456789012345678901234567890123"
 db "5678901234567890123456789012345678901234"
 db "6789012345678901234567890123456789012345"
 db "7890123456789012345678901234567890123456"
 db "8901234567890123456789012345678901234567"
 db "9012345678901234567890123456789012345678"
 db "0123456789012345678901234567890123456789"
 db "1234567890123456789012345678901234567890"
 db "2345678901234567890123456789012345678901"
 db "3456789012345678901234567890123456789012"
 db "4567890123456789012345678901234567890123"
 db "5678901234567890123456789012345678901234"
 db "6789012345678901234567890123456789012345"
 db "7890123456789012345678901234567890123456"
 db "8901234567890123456789012345678901234567"
 db "9012345678901234567890123456789012345678"
 db "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
