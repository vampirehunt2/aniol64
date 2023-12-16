STR s "test" %test string
ARR a 4
ARR b 4

i<-0
WHILE i<4
    a[i]<-i
    b[i]<-i*10
    i<-i+1
    LOOP

i<-0
WHILE i<4
    a[i]<-a[i]+b[i]
    i<-i+1
    LOOP

STOP
END