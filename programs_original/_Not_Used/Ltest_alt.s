loop:	li	x1,	0x1000
	add	x2,	x1,	x1
	sw	x2,	0(x1)
	add	x2,	x2,	x1
	add	x2,	x2,	x1
	add	x3,	x1,	x1
	lw	x2,	0(x1)
	bne	x2,	x3,	loop
	beq	x2,	x3,	end
	beq	x0,	x0,	loop
end:	wfi
