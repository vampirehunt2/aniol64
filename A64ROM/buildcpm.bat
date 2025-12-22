cd %ANIOL_HOME%
call build.bat
cd ..\cpm2-asm\
call .\build.bat

rem include cpm in the output file
cd ..
C:\8bit\vDos\vdos
cd %ANIOL_HOME%