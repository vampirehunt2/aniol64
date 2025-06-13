% Vampire Hunt for the A64
ARR cellX 6
ARR cellY 6
ARR roomX 6
ARR roomY 6
ARR roomW 6
ARR roomH 6
ARR roomC 6 % whether the room is connected.

HideCursor 
Poke $8013,0 %echo off

FOR i<-0,i<3
  Rnd(10) % rotate the RNG
NEXT

InitCls
ClrScr
InitRms
DrawRms
Connect
PutDoor


STOP

% initialise cells
PROC InitCls
  cellX[0]<-0
  cellX[1]<-MaxX()/3
  cellX[2]<-2*MaxX()/3
  cellX[3]<-0
  cellX[4]<-MaxX()/3
  cellX[5]<-2*MaxX()/3
  cellY[0]<-0
  cellY[1]<-0
  cellY[2]<-0
  cellY[3]<-MaxY()/2
  cellY[4]<-MaxY()/2
  cellY[5]<-MaxY()/2
  skipCell<-Rnd(8)
RET
  
% initialise rooms
PROC InitRms
  FOR i<-0, i<6
    roomW[i]<-Rnd(MaxX()/3-4)+4
    roomX[i]<-Rnd(MaxX()/3-roomW[i])
    roomH[i]<-Rnd(MaxY()/2-4)+4
    roomY[i]<-Rnd(MaxY()/2-roomH[i])
    roomX[i]<-roomX[i]+cellX[i]
    roomY[i]<-roomY[i]+cellY[i]
    roomC[i]<-0
  NEXT
RET
  
% draw rooms
PROC DrawRms
  FOR i<-0, i<6
    DrawRm
  NEXT
RET
  
%draw the room with index i
PROC DrawRm
  IF i=skipCell: RET;
  ry<-roomY[i]
  WHILE ry<=roomY[i]+roomH[i]
    rx<-roomX[i]
    GotoXY rx, ry
    WHILE rx<=roomX[i]+roomW[i]
      c<-'.
      IF (rx=roomX[i])|(rx=roomX[i]+roomW[i]): c<-'#;
      IF ry=roomY[i]: c<-'#;
      IF ry=roomY[i]+roomH[i]: c<-'#;
      PutChar c
      rx<-rx+1
    LOOP
    ry<-ry+1
  LOOP
RET

% connect rooms
PROC Connect
  conectd<-1
  r0<-Rnd(6)
  roomC[r0]<-1
  WHILE conectd<6
    r1<-Rnd(6-conectd)
    i<-0
    j<-0
    WHILE (j<r1)|(roomC[i]=1)
      IF roomC[i]=0: j<-j+1;
      i<-i+1
    LOOP
    r1<-i
    ConnRms
    conectd<-conectd+1
    roomC[r1]<-1
    r0<-r1
  LOOP
RET

% connects two rooms, r0 and r1
PROC ConnRms
  prev<-0
  i<-r0
  PtInRm
  x0<-x
  y0<-y
  i<-r1
  PtInRm
  x1<-x
  y1<-y
  sx<-1
  sy<-1
  IF x1<x0: sx<-(-1);
  IF y1<y0: sy<-(-1);
  x<-x0
  y<-y0
  WHILE x<>x1
    GotoXY x,y
    c<-GetChar()
    IF c='#
      IF (prev='+)|(prev='.)
        c<-'.
      ELSE 
        c<-'+
      ENDIF
    ENDIF
    IF c=0: c<-'%;
    GotoXY x,y
    PutChar c
    prev<-c
    x<-x+sx
  LOOP
  WHILE y<>y1
    GotoXY x,y
    c<-GetChar()
    IF c='#
      IF (prev='+)|(prev='.)
        c<-'.
      ELSE 
        c<-'+
      ENDIF
    ENDIF
    IF c=0: c<-'%;
    GotoXY x,y
    PutChar c
    prev<-c
    y<-y+sy
  LOOP
RET

PROC PutDoor
  i<-Rnd(6)
  PtInRm
  GotoXY x,y
  PutChar '>
RET


% random point in room i
% result in x, y
PROC PtInRm
  x<-Rnd(roomW[i]-2)+roomX[i]+1
  y<-Rnd(roomH[i]-2)+roomY[i]+1 
RET

END