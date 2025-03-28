addi x1, x0, 1
addi x2, x1, 1
addi x3, x2, 1
addi x4, x3, 1
lw	x4, 0(x2)
addi x5, x3, 1
addi x6, x5, 1
addi x7, x6, 5
mul x7, x6, x7
mul x7, x6, x7
lw	x6, 0(x7)
lw	x7, 0(x6)
lw	x8, 0(x6)
lw	x9, 0(x6)
addi x1, x0, 1
addi x2, x1, 1
addi x3, x2, 1
addi x4, x3, 1
addi x5, x3, 1
addi x7, x3, 1
wfi