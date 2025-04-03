	data = 0x1000	
	li	x1,	data
	li	x2,	3
	sw	x2,	0(x1)
	li	x2,	0
	lw	x2,	0(x1)
	add	x3,	x2,	x2
	wfi
