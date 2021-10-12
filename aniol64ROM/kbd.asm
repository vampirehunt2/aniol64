;----------------------------------------------------
; Project: aniol64.zdsp
; File: kbd.asm
; Date: 8/26/2021 14:04:35
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------

KEYCODE_BASE_ADDR equ 0400h

org KEYCODE_BASE_ADDR
	defb 71h	; 00-00-0000b	q
	defb 77h	; 00-00-0001b	w
	defb 65h	; 00-00-0010b	e
	defb 72h	; 00-00-0011b	r
	defb 74h	; 00-00-0100b	t
	defb 79h	; 00-00-0101b	y
	defb 75h	; 00-00-0110b	u
	defb 69h	; 00-00-0111b	i
	defb 6Fh	; 00-00-1000b	o
	defb 70h	; 00-00-1001b	p
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 61h	; 00-01-0000b	a
	defb 73h	; 00-01-0001b	s
	defb 64h	; 00-01-0010b	d
	defb 66h	; 00-01-0011b	f
	defb 67h	; 00-01-0100b	g
	defb 68h	; 00-01-0101b	h
	defb 6Ah	; 00-01-0110b	j
	defb 6Bh	; 00-01-0111b	k
	defb 6Ch	; 00-01-1000b	l
	defb 0Dh	; 00-01-1001b	\r
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 7Ah	; 00-10-0010b	z
	defb 78h	; 00-10-0011b	x
	defb 63h	; 00-10-0100b	c
	defb 76h	; 00-10-0101b	v
	defb 62h	; 00-10-0110b	b
	defb 6Eh	; 00-10-0111b	n
	defb 6Dh	; 00-10-1000b	m
	defb 20h	; 00-10-1001b	\s
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 31h	; 01-00-0000b	1
	defb 32h	; 01-00-0001b	2
	defb 33h	; 01-00-0010b	3
	defb 34h	; 01-00-0011b	4
	defb 35h	; 01-00-0100b	5
	defb 36h	; 01-00-0101b	6
	defb 37h	; 01-00-0110b	7
	defb 38h	; 01-00-0111b	8
	defb 39h	; 01-00-1000b	9
	defb 30h	; 01-00-1001b	0
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 2Bh	; 01-01-0000b	+
	defb 2Dh	; 01-01-0001b	-
	defb 2Ah	; 01-01-0010b	*
	defb 2Fh	; 01-01-0011b	/
	defb 3Dh	; 01-01-0100b	=
	defb 11h	; 01-01-0101b	[Up]
	defb 5Fh	; 01-01-0110b	_
	defb 5Bh	; 01-01-0111b	[
	defb 5Dh	; 01-01-1000b	]
	defb 7Fh	; 01-01-1001b	\d
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 3Ch	; 01-10-0010b	<
	defb 3Eh	; 01-10-0011b	>
	defb 3Fh	; 01-10-0100b	?
	defb 2Eh	; 01-10-0101b	.
	defb 12h	; 01-10-0110b	[L]
	defb 13h	; 01-10-0111b	[Dn]
	defb 14h	; 01-10-1000b	[R]
	defb 08h	; 01-10-1001b	\b
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 51h	; 10-00-0000b	Q
	defb 57h	; 10-00-0001b	W
	defb 45h	; 10-00-0010b	E
	defb 52h	; 10-00-0011b	R
	defb 54h	; 10-00-0100b	T
	defb 59h	; 10-00-0101b	Y
	defb 55h	; 10-00-0110b	U
	defb 49h	; 10-00-0111b	I
	defb 4Fh	; 10-00-1000b	O
	defb 50h	; 10-00-1001b	P
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 41h	; 10-01-0000b	A
	defb 53h	; 10-01-0001b	S
	defb 44h	; 10-01-0010b	D
	defb 46h	; 10-01-0011b	F
	defb 47h	; 10-01-0100b	G
	defb 48h	; 10-01-0101b	H
	defb 4Ah	; 10-01-0110b	J
	defb 4Bh	; 10-01-0111b	K
	defb 4Ch	; 10-01-1000b	L
	defb 2Ch	; 10-01-1001b	,
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 5Ah	; 10-10-0010b	Z
	defb 58h	; 10-10-0011b	X
	defb 43h	; 10-10-0100b	C
	defb 56h	; 10-10-0101b	V
	defb 42h	; 10-10-0110b	B
	defb 4Eh	; 10-10-0111b	N
	defb 4Dh	; 10-10-1000b	M
	defb 09h	; 10-10-1001b	\t
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 21h	; 11-00-0000b	!
	defb 40h	; 11-00-0001b	@
	defb 23h	; 11-00-0010b	#
	defb 24h	; 11-00-0011b	$
	defb 25h	; 11-00-0100b	%
	defb 5Eh	; 11-00-0101b	^
	defb 26h	; 11-00-0110b	&
	defb 2Ah	; 11-00-0111b	*
	defb 28h	; 11-00-1000b	(
	defb 29h	; 11-00-1001b	)
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 3Ah	; 11-01-0101b	:
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 7Bh	; 11-10-0010b	{
	defb 7Dh	; 11-10-0011b	}
	defb 7Eh	; 11-10-0100b	~
	defb 5Ch	; 11-10-0101b	\
	defb 27h	; 11-10-0110b	'
	defb 22h	; 11-10-0111b	"
	defb 3Bh	; 11-10-1000b	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;
	defb 00h	;

