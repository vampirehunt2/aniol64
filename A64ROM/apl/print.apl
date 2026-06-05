% PRINT
% printing program 
% for the lpt printer

STR fName 13
fSize<-0
cmdLine<-$8180
lptOut<-$0078	%0111-1000b
lptIn<-$0079	%0111-1001b
mBusy<-$0001	%0000-0001b
mError<-$0002	%0000-0010b
mPaper<-$0004	%0000-0100b
mStrobe<-$8000	%1000-0000b

fName<-Tok(cmdLine)
IF !Exists(fName)
	WriteS "File not found"
	END
ENDIF

Open(fName)
WHILE !Eof()
	ChkStat
	c<-FRead()
	c<-c|mStrobe	% strobe high
	Put lptOut,c
	c<-c&!mStrobe	% strobe low
	Put lptOut,c
	c<-c|mStrobe	% strobe high
	Put lptOut,c
LOOP	
	
STOP

PROC ChkStat
	busy<-mBusy
	WHILE busy>0
		status<-Get(lptIn)
		paper<-status&mPaper
		IF paper>0
			WriteS "Out of paper"
			END
		ENDIF
		error<-status&mError
		IF error=0
			WriteS "Printer error"
			END
		ENDIF
		busy<-status&mBusy
	LOOP
RET

END