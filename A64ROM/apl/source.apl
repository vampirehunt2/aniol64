UserCall(x<-1, y<-2)
WriteS "success"
HALT

PROC UserCall
    Write x+y
RET

END