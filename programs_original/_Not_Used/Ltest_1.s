	li	x1,	0
	li	x2,	0x1000
	li	x3,	0x8942
	li	x4,	0x724F
	sw	x1,	0(x2)
	sw	x2,	4(x2)
	sw	x3,	8(x2)
	sw	x4,	12(x2)
	lw	x5,	0(x2)
	lw	x6,	4(x2)
	sw	x6,	4(x2)
	lw	x7,	8(x2)
	lw	x8,	12(x2)
	sw	x8,	12(x2)
	wfi
