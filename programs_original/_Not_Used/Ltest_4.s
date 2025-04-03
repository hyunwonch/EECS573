	li	x1,	0x1000
	li	x2,	0x04
	li	x3,	0x08
loop:	add	x1,	x1,	x2
	sw	x3,	0(x1)
	addi	x1,	x1,	0
	addi	x3,	x3,	-1
	add	x4,	x3,	0
	lw	x3,	0(x1)
	sw	x4,	0(x1)
	lw	x3,	0(x1)
	bne	x3,	x0,	loop
	wfi

