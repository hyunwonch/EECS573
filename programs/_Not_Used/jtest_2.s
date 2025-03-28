    data = 0x6789
    li	x6, 0
    li	x2, data
    li  x31, 0x0a
loop:	mul	x3,	x6,	x31
    sw	x3, 0(x2)
    lw	x4, 0(x2)
    sw	x4, 0x100(x2)
    addi	x2,	x2,	0x8 #
    addi	x6,	x6,	0x2 #
    slti	x5,	x6,	10 #
    bne	x5,	x0,	loop #
    wfi