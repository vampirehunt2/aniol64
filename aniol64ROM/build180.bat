echo %ANIOL_HOME%
del %ANIOL_HOME%\aniol180.bin
del %ANIOL_HOME%\aniol180.sld
c:\8bit\sjasmplus-1.20.2.win\sjasmplus.exe --sym=symbols.txt  --raw=%ANIOL_HOME%\aniol180.bin --sld=%ANIOL_HOME%\aniol180.sld --fullpath %ANIOL_HOME%\aniol180.asm

pause