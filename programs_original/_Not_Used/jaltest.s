data = 0x3E80

    li	x30, 0
    li	x1, 0
    li	x2, 1
B0:	slli	x21,	x2,	0 #
    or	x30,	x21,	x30 #
    j   bad

bad:    li x0, 0xbeef
    li x0, 0xbeef
    li x0, 0xbeef
    li x0, 0xbeef
    wfi

    wfi
    wfi