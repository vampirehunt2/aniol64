% Vampire Hunt for the A64
ARR cellX
ARR cellY 6
ARR roomX 6
ARR roomY 6
ARR roomW 6
ARR roomH 6

HideCursor
Poke $8013,0 %echo off

InitCls
ClrScr

InitRms
DrawRms


HALT

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
  
PROC InitRms
  i<-0
  WHILE i<6
    roomW[i]<-Rnd(MaxX()/3-4)+4
    roomX[i]<-Rnd(MaxX()/3-roomW[i])
    roomH[i]<-Rnd(MaxY()/2-4)+4
    roomY[i]<-Rnd(MaxY()/2-roomH[i])
    roomX[i]<-roomX[i]+cellX[i]
    roomY[i]<-roomY[i]+cellY[i]
    i<-i+1
  LOOP
RET
  
PROC DrawRms
  i<-0
  WHILE i<6
    DrawRm
    i<-i+1
  LOOP
RET
  
%draw the room with index i
PROC DrawRm
  IF i=skipCell: RET;
  rx<-roomX[i]
  WHILE rx<=roomX[i]+roomW[i]
    GotoXY rx,roomY[i]
    PutChar '#
    GotoXY rx, roomY[i]+roomH[i]
    PutChar '#
    rx<-rx+1
  LOOP
  ry<-roomY[i]
  WHILE ry<=roomY[i]+roomH[i]
    GotoXY roomX[i],ry
    PutChar '#
    GotoXY roomX[i]+roomW[i], ry
    PutChar '#
    ry<-ry+1
  LOOP
RET

% connect rooms
PROC ConnRms
  
RET

% random point in room i
PROC PtInRoom
  x<-Rnd(roomW[i]-2)+roomX[i]+1
  y<-Rnd(roomH[i]-2)+roomW[i]+1
RET



END
