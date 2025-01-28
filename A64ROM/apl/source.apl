STR sys 4

sys{0}<-$0021   %LD HL,nn
sys{1}<-$00aa
sys{2}<-$0055
sys{3}<-$00c9   %RET

WriteH Call(sys)

HALT
END
