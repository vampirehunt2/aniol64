; special registers of the z180

; MMU registers
CBAR    equ 3Ah         ; MMU Common/Bank Area Register
CBR     equ 38h         ; MMU Common Base Register
BBR     equ 39h         ; MMU Bank Base Register

; ASCI (UART) registers
; channel 0
CNTLA0  equ 00h         ; ASCI Control Register A, Channel 0
CNTLB0  equ 02h         ; ASCI Control Register B, Channel 0
STAT0   equ 04h         ; ASCI Status Channel 0
TDR0    equ 06h         ; ASCI Transmit Data Register Channel 0
TSR0    equ 08h         ; ASCI Receive Data Register Channel 0
