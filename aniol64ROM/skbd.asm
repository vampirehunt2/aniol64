;----------------------------------------------------
; Project: aniol64.zdsp
; File: skbd
; Date: 4/5/2022 12:55:12
; Simple Keyboard driver
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------

SKEYCODE_BASE_ADDR equ 1000h
SKBD_PORT0 equ 10110001b
SKBD_PORT1 equ 10110010b
SKBD_PORT2 equ 10110100b
SKBD_PORT3 equ 10111000b
SKbdEnabled equ 8013h

PROC
defb "handleSKbdNmi"
handleSKbdNmi:
        PUSH BC            ; save register state
        PUSH AF
        CALL skbd_scan     ; read all the pressed keys from the matrix
        CP 0               ; check if any key is pressed
        JR Z, _notPressed  ; if not, jump down
        LD A, (SKbdEnabled); check if the keyboard is currently enabled...
        CP FALSE           ;... meaning if there was a notPressed condition since the last key press
        JR Z, _end         ; if not, i.e the same key as before is still pressed, exit to avoid double reads
        LD A, B            ; load the scancode from B
        CALL skbd_2asc     ; convert the scancode to ASCII code
        LD (KbdBuff), A    ; save the scancode in the keyboard buffer, to be read by getChar
        LD A, FALSE
        LD (SKbdEnabled), A ; disable the keyboard to avoid double reads
        JR _end
_notPressed:
        LD A, TRUE          ; no key is pressed...
        LD (SKbdEnabled), A ;...so we can enable the keyboard again
_end:
        POP AF
        POP BC              ; restore register state
        RETN
ENDP


PROC
; scans for keys pressed and returns the scancode
; resulting scancode in B
; non-zero value in A if a key waw pressed, other than just the modifier keys
defb "skbd_scan"
skbd_scan:
        PUSH DE          ; save register state
        PUSH HL
        LD C, SKBD_PORT2 ; starting in row 2, where the modifier keys are
        IN A, (C)        ; read from row 2
        LD B, A          ; save the scancode in B for later
        AND 11000000b   ; check if SHIFT or ALT are pressed
        SRL A           ; move SHIFT and ALT to D5 and D5, respectively
        LD D, A         ; save the SHIFT and ALT in D
        LD A, B         ; restore scancode from B
        AND 00111111b   ; remove SHIFT and ALT information
        CP 0
        JP NZ, _process  ; if there's anything pressed, other than a modifier, process it
        LD C, SKBD_PORT0
        IN A, (C)        ; read from row 0
        CP 0
        JP NZ, _process  ; if there's anything pressed, process it
        LD C, SKBD_PORT1
        IN A, (C)        ; read from row 1
        CP 0
        JP NZ, _process  ; if there's anything pressed, process it
        LD C, SKBD_PORT3
        IN A, (C)        ; read from row 3
        CP 0
        JP NZ, _process  ; if there's anything pressed, process it
        JP _end
_process:
        LD B, 0          ; initialise the column counter
        LD E, 00000001b
        LD H, A
_loopCol:                ; B will contain the index of the set bit (i.e. index of pressed key)
        AND E            ; note: only the first key pressed in a given row is processed
        CP 0
        JR NZ, _endLoop  ; check if given bit is set
        INC B            ; increment the loop counter
        SLA E            ; move to the next bit (next column in the row)
        LD A, H
        JR _loopCol
_endLoop:
        LD A, C          ; load the port number to A
        CP SKBD_PORT0
        JR Z, _row0
        CP SKBD_PORT1
        JR Z, _row1
        CP SKBD_PORT2
        JR Z, _row2
        CP SKBD_PORT3
        JR Z, _row3
_row0:                    ; set row number on D4-D3
        LD A, 00000000b
        JR _complete
_row1:
        LD A, 00001000b
        JR _complete
_row2:
        LD A, 00010000b
        JR _complete
_row3:
        LD A, 00011000b
        JR _complete
_complete:
        OR B              ; add column number on D2-D0, this was calculated in _loopCol
        OR D              ; add the modifier keys on D6-D5
        LD B, A           ; store the scancode in B
        LD A, TRUE        ; indicate that a key was pressed
_end:
        POP HL
        POP DE            ; restore register state
        RET
ENDP

PROC
; converts scancode to ASCII code
; result in A
skbd_2asc:
        RET
ENDP
