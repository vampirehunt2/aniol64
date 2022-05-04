;----------------------------------------------------
; Project: aniol64.zdsp
; File: aniol64.asm
; Date: 4/26/2022 18:42:17
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------


org 0000h
        LD SP, RAMTOP   ; initialise stack pointer to the top of available RAM
        IM 2            ; set interupt mode to 2
        LD A, 01h       ; higher byte of the interrupt vector table
        LD I, A         ; set the vector table address
        EI              ; enable interrupts
        JP boot         ; jump over the interrupt handlers for NMI and mode 1 INT

org 0038h
        ; respond to mode 1 interrupt
        EX AF, AF'       
        EXX
        CALL handleInt 
        EXX
        EX AF, AF'		
        EI
        RETI

org 0066h
        ; NMI handler
        PUSH AF
        CALL handleNmi
        POP AF
        EI
        RETN

org 0100h
        ; interrupt vector table
        KeyClickHandler: defb 38h, 00h ; we're pointing back at the mode 1 INT handler
                                        ; so that the routine works for both mode 1 and 2
                                        ; note, low order byte goes first


Aniol: defb   "               _ANIOL640_               ", 0
RAMTOP equ 0BFFFh
TestAddr equ 8000h  		; points to the beginning of RAM
ClkScratchpad equ 8008h
ClkData equ 8009h
KbdBuff equ 8012h         	; a 1-byte buffer
LcdBuff equ 8020h          	; 20 byte long buffer + 1 byte for the trailing 0
NmiCount equ 8035h
MonCurrAddr equ 8036h
Random equ 8038h
Banks equ 8039h
VgaCurX equ 8040h
VgaCurY equ 8041h
LineBuff equ 8100h
PROGRAM_DATA equ 8200h

Ready: defb     "Ready", 0
Hello: defb     "Hello", 0
Prompt: defb    ">", 0
NvRamOk: defb   "NVRAM OK", 0
NvRamNok: defb  "NVRAM Error", 0

boot:
        LD A, 1
        CALL setRomBank
        LD A, 1
        CALL setRamBank

        ; init LCD
        CALL lcd_init

        ; init the keyboard buffer to avoid a bogus character during the first read
        LD A, 0
        LD (KbdBuff), A

        ; greetings
        LD IX, Aniol
        CALL lcd_wriStr

        ; check for NVRAM
        CALL lcd_gotoLn2
        CALL memTest ; returns result in A
        CP 0
        JR Z, memTestOk
        LD IX, NvRamNok
        JP printMemTest
memTestOk:
        LD IX, NvRamOk
        JP printMemTest
printMemTest:
        CALL lcd_wriStr
        CALL lcd_gotoLn3
        LD IX, Ready
        CALL lcd_wriStr
        CALL lcd_gotoLn4
        CALL bzr_beep
        LD A, 50
        CALL delay
        CALL bzr_beep
        LD A, 50
        CALL delay
        CALL bzr_beep
        ;CALL snd_init

        ; wait for user input from here on in
        CALL cmd_main
loop:
        HALT
        JP loop

include util.asm
include bzr.asm
include mon.asm
include str.asm
include mem.asm
include cmd.asm
include lcd.asm
;include vga.asm
include kbd.asm ; this goes last becasue of the org 2000h inside


PROC
handleInt:
        LD A, (KbdBuff)
        CP 0                  ; checking if keyboard buffer is empty
        RET NZ                ; this is essentially software debouncing
        CALL kbd_input
        CP 08                 ; check if BACKSPACE was pressed
        JR Z, _bkspc
        CP 20h                ; checks if the key corresponds to a control character
        JR C, _noEcho         ; skip echo if less
        CALL lcd_putChar      ; echo the character to screen, but don't remove it from the keyboard buffer
_noEcho:
        CALL bzr_click
        RET
_bkspc:
        CALL lcd_cursorLShift  ; TODO: check if you're already in the beginning of line
        LD A, ' '
        CALL lcd_putChar
        CALL lcd_cursorLShift
        JR _noEcho
ENDP

PROC
handleNmi:
        LD A, (NmiCount)
        INC A
        LD (NmiCount), A
        RET
ENDP

