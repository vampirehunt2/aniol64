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
EOSSB       equ 0F3h        ; End Of Screen, Stop Buffering


; port numbers ***********************************************************************************
CRT_PARAM  equ 00000000b    ; the parameter register of the 8276
CRT_CMD    equ 00000001b    ; the command register of the 8276
CRT_STATUS equ 00000001b    ; the status register of the 8276 
                            ; same address as command register,
                            ; but read from rather than written to 
CRT_BUFF   equ 01000000b    ; buffer select for the 8276 

; screen composition ****************************************************************************

LINE_LEN    equ 80          ; number of character in a row
LINE_NUM    equ 25          ; number of visible rows
                            ; there are 30 rows in the visible region, 
                            ; but we only have enough RAM to use 25
SCREEN_SIZE equ LINE_LEN * LINE_NUM ; size of the Screen memory, 
                            ; ignoring the unused lines in the visible region
                            ; extra line used for the front porch


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

; B7    non-spaced rows
; B6:0  80 characters per row 
SCREEN_COMP_BYTE1 equ 00000000b + 79   

; B7:6  2 rows of vertical retrace
; B5:0  31 rows per frame
;       30 display rows and one for the front porch               
SCREEN_COMP_BYTE2 equ 01000000b + 30     
                            
; B7:4  underline in last line (doesn't matter, we're not using underline)
; B3:0  16 lines per row
SCREEN_COMP_BYTE3 equ 0FFh  

; B7    Non-offset mode for addressing the character generator
; B5:4  Blinking reverse video block cursor
; B3:0  20 character-long horizontal retrace 
SCREEN_COMP_BYTE4 equ 01001001b           


; memory map **************************************************************************************
ROM         equ 0000h
RAM         equ 8000h           ; beginning of RAM
RAM_SIZE    equ 2048
STACK       equ RAM + RAM_SIZE  ; top of RAM


; variables for the program ***********************************************************************
CharFeed   equ RAM + 00h    ; pointer into the screen memory 
                            ; indicating next character to be fed to the 8276
                            ; 2 bytes

CursorAddr  equ RAM + 02h   ; pointer into the screen memory
                            ; indicating the position at which next character
                            ; is to be inserted from the UART
                            ; 2 bytes
CurrLine    equ RAM + 04h   ; current screen line

Screen      equ RAM + 10h   ; screen memory


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
    XOR A
    LD (CurrLine), A
    EI
    RET

; RST 7.5 responds to the Buffer Ready signal from the 8276
; it sends one row of character data, incrementing HL each time
; the loop is completely unrolled for performance
 ds RST75 - $, 0
printLine:
    LD A, (CurrLine)
    CP LINE_NUM
    JP NZ, .cont
    LD A, EOSSB
    OUT (CRT_BUFF), A
    JP .end
.cont:
    INC A
    LD (CurrLine), A
    ; repeat 80 times
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
    ; done with 80 iterations
.end:
    LD A, R75   ; reset the interrupt flip-flop
 db SIM         ; Z80 assembler doesn't recognise the SIM instruction
    EI
    RET

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

    ; load cursor
 ;   LD A, CRT_CURSOR
 ;   OUT (CRT_CMD), A
 ;   XOR A                       ; LD A, 0
 ;   OUT (CRT_PARAM), A
 ;   OUT (CRT_PARAM), A
    
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

; handle the 8276 vertical retrace interrupt
handleInt:


; main program loop
; TODO: 
; queries the 8251 for new characters received
; and puts them into the screen memory - if they're characters
; or processes them - if they're escape codes.
main:
    HALT
    JP main


 ds 2048 - $, 0
TEST_SCREEN:
 db "12345678901234567890123456789012345678901234567890123456789012345678901234567890"
 db "0        1         2         3         4         5         6         7         8"                       
 db "test1test2test3test4test5test6test7test8test1test2test3test4test5test6test7test8"
 db "iv                                                                            iv"
 db "v                                                                              v"
 db "vi                                                                            vi"
 db "vii                                                                          vii"
 db "viii                     This is a test screen                              viii"
 db "ix                                                                            ix"
 db "x                                                                              x"
 db "xi           ######                                                           xi"
 db "xii          #....#       #########################                          xii"
 db "xiii         #.<..#########.........../.........#.#                         xiii"
 db "xiv          #....+......./...........###########.#                          xiv"
 db "xv           ##############...........#         #.#                           xv"
 db "xvi                       #...........#         #.#                          xvi"
 db "xvii                      #...........#         #+###############           xvii"
 db "xviii                     ###########+#         #...............#          xviii"
 db "xix                                 #.#         #...............#            xix"
 db "xx                 ########         #.#         #...............#             xx"
 db "xxi                #      #         #.#         #...............#            xxi"
 db "xxii               #      ###########.###########............>..#           xxii"
 db "xxiii              #      +.....................................#          xxiii"
 db "xxiv               ##############################################           xxiv"
 db "xxv                                                                          xxv" 
 db "xxvi                                                                        xxvi" 
 db "xxvii                                                                      xxvii" 
 db "xxviii                                                                    xxviii" 
 db "xxix                                                                        xxix" 
 db "xxx xxx xxx xxx xxx xxx xxx xxx xxx xxx xxx xxx xxx xxx xxx xxx xxx xxx xxx  xxx" 


