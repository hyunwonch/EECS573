    li	x4, 0x1000
    li	x5, 0x1008
    li	x6, 0x1010
    li	x10, 2
    li	x2, 1
    sw	x2, 0(x4)
    sw	x2, 0(x5)
loop:	lw	x2, 0(x4)
    lw	x3, 0(x5)
    addi	x10,	x10,	0x1 #
    slti	x11,	x10,	16 #
    sw	x3, 0(x6)
    addi	x6,	x6,	0x8 #
    bne	x11,	x0,	loop #
    wfi