; 

SND_PORT equ 01111111b ; 7Fh - sound card on the expansion port
; SND_PORT equ 11110111b ; sound card on A3

; turns off all the channels
snd_off:
		LD A, 10011111b		; latch, channel 00, volume, volume data 1111
		OUT (SND_PORT), A
		LD A, 10111111b		; latch, channel 01, volume, volume data 1111
		OUT (SND_PORT), A
		LD A, 11011111b		; latch, channel 10, volume, volume data 1111
		OUT (SND_PORT), A 
		LD A, 11111111b		; latch, channel 11, volume, volume data 1111   
		OUT (SND_PORT), A
		RET

; plays a short beep 
snd_beep:
		LD A, 10001110b 	; 8Eh - latch, channel 00, tone, data 1110
		OUT (SND_PORT), A
		LD A, 00001111b 	; 0Fh - data 001111
		OUT (SND_PORT), A
		LD A, 10010000b		; 90h - latch, channel 00, volume, data 0000
		OUT (SND_PORT), A
		LD A, 20			; 200ms delay
        CALL delay
		LD A, 10011111b		; latch, channel 00, volume data 1111
		OUT (SND_PORT), A	; turn sound off
		RET 