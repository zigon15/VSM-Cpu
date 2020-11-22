#include "CPU1.cpu"

#addr 0x00
.loop:

.Addition:
ADD 32
LIB 10
JMPL .Addition

.Subtract:
SUB 32
LIB 0
JMPG .Subtract

LIC 2047


#addr 32
#d16 1    ;address 32
