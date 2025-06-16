PROC DrawRm
  IF i=skipCell: RET;
  ry<-roomY[i]
  WHILE ry<=roomY[i]+roomH[i]
    rx<-roomX[i]
    GotoXY rx, ry
    WHILE rx<=roomX[i]+roomW[i]
      c<-'.
      IF (rx=roomX[i])|(rx=roomX[i]+roomW[i]: c<-'#;
      IF ry=roomY[i]: c<-'#;
      IF ry=roomY[i]+roomH[i]: c<-'#;
      PutChar c
      rx<-rx+1
    LOOP
    ry<-ry+1
  LOOP
RET

END