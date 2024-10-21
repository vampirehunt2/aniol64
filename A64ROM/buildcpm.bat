echo %ANIOL_HOME%
cd %ANIOL_HOME%
del aniol64.bin
del aniol64.sld
c:\8bit\sjasmplus-1.20.2.win\sjasmplus.exe --sym=symbols.txt  --raw=aniol64.bin --sld=aniol64.sld --fullpath aniol64.asm

rem include cpm in the output file
cd ..
vdos
cd %ANIOL_HOME%

pause