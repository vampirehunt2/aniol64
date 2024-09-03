echo %ANIOL_HOME%
del %ANIOL_HOME%\aniol64.bin
del %ANIOL_HOME%\aniol64.sld
c:\8bit\sjasmplus-1.20.2.win\sjasmplus.exe --sym=symbols.txt  --raw=cpm22.bin --sld=cpm.sld --fullpath cpm22.z80

rem pause