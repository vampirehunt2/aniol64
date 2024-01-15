x<-1
WHILE x<20
    d<-2
    p<-1
    WHILE d<x
        IF x\d=0
            d<-x
            p<-0
        ELSE
            d<-d+1
        ENDIF
    LOOP
    IF p=1
        Write x
        NewLn
    ENDIF
    x<-x+1
LOOP 
STOP
END
