	li	x1,	0
	li	x2,	0x1000
	li	x3,	0x01
	li	x4,	0x02
	bne	x1,	x1,	END
	beq	x1,	x1,	RUN
END:	wfi
RUN:	sw	x3,	0(x2)
	beq	x1,	x1,	func
	lw	x1,	0(x2)
	lw	x1,	0(x2)
	lw	x1,	0(x2)
	lw	x1,	0(x2)
func:	add	x1,	x1,	x1
	beq	x0,	x1,	END
