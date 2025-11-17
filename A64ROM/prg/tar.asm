; tape archiver program


TarTest: defb "Hello from tape", 0

tar_main:
    CALL cas_init
    LD IX, TarTest
.loop:
    LD A, (IX)
    CP 0
    RET Z
    CALL dart_putChar
    JR .loop
    RET

