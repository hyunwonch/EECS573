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
lw	x8, 0(x7)
addi x1, x0, 1
addi x2, x1, 1
mul x7, x7, x1
lw	x8, 0(x7)
mul x7, x7, x2
lw	x9, 0(x7)
addi x10, x7, 5
lw	x8, 0(x10)
lw	x8, 0(x8)
addi x1, x0, 1
addi x2, x1, 1
addi x3, x2, 1
addi x4, x3, 1
addi x5, x3, 1
addi x7, x3, 1
wfi