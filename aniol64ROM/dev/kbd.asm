;----------------------------------------------------
; Project: aniol64.zdsp
; File: kbd.asm
; Date: 8/26/2021 14:04:35
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------



KEYCODE_BASE_ADDR equ 3700h
KBD_PORT equ 10111111b  ; BFh keyboard is selected with A6

; Converts keyboard code to ASCII code
; C - keycode to convert
; zeroes B
; result in A
kbd_keycode2ascii:
        LD HL, KEYCODE_BASE_ADDR
        LD B, 00h
        ADD HL, BC
        LD A, (HL)
        RET

; reads a keycode from the keyboard and converts to an ascii character
; then stores it in the keyboard buffer.
; To be called from interrupt routine
kbd_input:
        LD C, KBD_PORT
        IN A, (C)
        LD C, A
        CALL kbd_keycode2ascii
        LD (KbdBuff), A
        RET

; reads a single key from the buffer
kbd_readKey:
        LD A, (KbdBuff)
        CP 0
        JR Z, kbd_readKey
        PUSH AF
        LD A, 0
        LD (KbdBuff), A
        POP AF
        RET

; reads a line from keyboard
; result in LineBuff
; result is only valid until next call of kbd_readLine
; if the result needs to persist, it needs to be copied to elswhere in memory
; TODO: check for max line length (buffer overflow)
PROC
kbd_readLine:
        LD BC, LineBuff       ; point BC to the beginning of the keyboard buffer
_loop:
        CALL kbd_readKey     ; wait for a key to be pressed
        CP 13                ; check if RETURN key was pressed
        JR Z, _return
        CP 08                 ; check if BACKSPACE was pressed
        JR Z, _bkspc
        CP 20h                ; checks if the key corresponds to a control character
        JR C, _loop           ; skip if less
        LD (BC), A            ; store the character in the keyboard buffer
        INC C                 ; point BC to the new position of keyboard buffer
        JR _loop
_bkspc:
        LD A, C                ; check if line buffer not empty
        CP 0
        JR Z, _loop             ; TODO: beep if buffer is empty
        DEC C                   ; go back one character
        JR _loop
_return:
        LD A, 0                ; store end of line
        LD (BC), A
        RET
ENDP

org KEYCODE_BASE_ADDR
    defb 71h	; 00-00-000b	q
	defb 77h	; 00-00-001b	w
	defb 65h	; 00-00-010b	e
	defb 72h	; 00-00-011b	r
	defb 74h	; 00-00-100b	t
	defb 79h	; 00-00-101b	y
	defb 75h	; 00-00-110b	u
	defb 69h	; 00-00-111b	i
	defb 61h	; 00-01-000b	a
	defb 73h	; 00-01-001b	s
	defb 64h	; 00-01-010b	d
	defb 66h	; 00-01-011b	f
	defb 67h	; 00-01-100b	g
	defb 68h	; 00-01-101b	h
	defb 6Ah	; 00-01-110b	j
	defb 6Bh	; 00-01-111b	k
	defb 00h	;
	defb 00h	;
	defb 7Ah	; 00-10-010b	z
	defb 78h	; 00-10-011b	x
	defb 63h	; 00-10-100b	c
	defb 76h	; 00-10-101b	v
	defb 62h	; 00-10-110b	b
	defb 6Eh	; 00-10-111b	n
	defb 6Fh	; 00-11-000b	o
	defb 6Ch	; 00-11-001b	l
	defb 6Dh	; 00-11-010b	m
	defb 20h	; 00-11-011b	\s
	defb 0Dh	; 00-11-100b	\r
	defb 70h	; 00-11-101b	p
	defb 00h	;
	defb 00h	;
	defb 31h	; 01-00-000b	1
	defb 32h	; 01-00-001b	2
	defb 33h	; 01-00-010b	3
	defb 34h	; 01-00-011b	4
	defb 35h	; 01-00-100b	5
	defb 36h	; 01-00-101b	6
	defb 37h	; 01-00-110b	7
	defb 38h	; 01-00-111b	8
	defb 2Bh	; 01-01-000b	+
	defb 2Dh	; 01-01-001b	-
	defb 3Ah	; 01-01-010b	:
	defb 2Fh	; 01-01-011b	/
	defb 3Dh	; 01-01-100b	=
	defb 5Bh	; 01-01-101b	[
	defb 5Dh	; 01-01-110b	]
	defb 11h	; 01-01-111b	[Up]
	defb 00h	;
	defb 00h	;
	defb 3Ch	; 01-10-010b	<
	defb 3Eh	; 01-10-011b	>
	defb 3Fh	; 01-10-100b	?
	defb 2Eh	; 01-10-101b	.
	defb 12h	; 01-10-110b	[L]
	defb 13h	; 01-10-111b	[Dn]
	defb 39h	; 01-11-000b	9
	defb 5Fh	; 01-11-001b	_
	defb 14h	; 01-11-010b	[R]
	defb 08h	; 01-11-011b	\b
	defb 7Fh	; 01-11-100b	\d
	defb 30h	; 01-11-101b	0
	defb 00h	;
	defb 00h	;
	defb 51h	; 10-00-000b	Q
	defb 57h	; 10-00-001b	W
	defb 45h	; 10-00-010b	E
	defb 52h	; 10-00-011b	R
	defb 54h	; 10-00-100b	T
	defb 59h	; 10-00-101b	Y
	defb 55h	; 10-00-110b	U
	defb 49h	; 10-00-111b	I
	defb 41h	; 10-01-000b	A
	defb 53h	; 10-01-001b	S
	defb 44h	; 10-01-010b	D
	defb 46h	; 10-01-011b	F
	defb 47h	; 10-01-100b	G
	defb 48h	; 10-01-101b	H
	defb 4Ah	; 10-01-110b	J
	defb 4Bh	; 10-01-111b	K
	defb 00h	;
	defb 00h	;
	defb 5Ah	; 10-10-010b	Z
	defb 58h	; 10-10-011b	X
	defb 43h	; 10-10-100b	C
	defb 56h	; 10-10-101b	V
	defb 42h	; 10-10-110b	B
	defb 4Eh	; 10-10-111b	N
	defb 4Fh	; 10-11-000b	O
	defb 4Ch	; 10-11-001b	L
	defb 4Dh	; 10-11-010b	M
	defb 09h	; 10-11-011b	\t
	defb 2Ch	; 10-11-100b	,
	defb 50h	; 10-11-101b	P
	defb 00h	;
	defb 00h	;
	defb 21h	; 11-00-000b	!
	defb 40h	; 11-00-001b	@
	defb 23h	; 11-00-010b	#
	defb 24h	; 11-00-011b	$
	defb 25h	; 11-00-100b	%
	defb 5Eh	; 11-00-101b	^
	defb 26h	; 11-00-110b	&
	defb 2Ah	; 11-00-111b	*
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 3Ah	; 11-01-101b	:
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 7Bh	; 11-10-010b	{
	defb 7Dh	; 11-10-011b	}
	defb 7Eh	; 11-10-100b	~
	defb 5Ch	; 11-10-101b	\
	defb 27h	; 11-10-110b	'
	defb 22h	; 11-10-111b	"
	defb 28h	; 11-11-000b	(
	defb 00h	;
	defb 3Bh	; 11-11-010b	;
	defb 00h	;
	defb 00h	;
	defb 29h	; 11-11-101b	)
	defb 00h	;
	defb 00h	;

