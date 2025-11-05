echo %ANIOL_HOME%
del %ANIOL_HOME%\test\test.bin
del %ANIOL_HOME%\test\test.sld
c:\8bit\sjasmplus-1.20.2.win\sjasmplus.exe --sym=symbols.txt  --raw=%ANIOL_HOME%\test\test.bin --sld=%ANIOL_HOME%\test\test.sld --fullpath %ANIOL_HOME%\test\testclrvga.asm
