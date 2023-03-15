echo %ANIOL_HOME%
del %ANIOL_HOME%\aniol64.bin
del %ANIOL_HOME%\aniol64.sld
c:\8bit\sjasmplus-1.20.2.win\sjasmplus.exe --raw=%ANIOL_HOME%\aniol64.bin --sld=%ANIOL_HOME%\aniol64.sld --fullpath %ANIOL_HOME%\aniol64.asm

pause