	li	x1,	0x1000
	li	x2,	0x04
	sw	x2,	0(x1)
	addi	x1,	x1,	4
	addi	x2,	x2,	1
	sw	x2,	0(x1)
	addi	x2,	x2,	1
	addi	x1,	x1,	4
	sw	x2,	0(x1)
	li	x3,	0x08
	wfi
