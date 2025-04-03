addi x1, x0, 1
addi x2, x1, 1
addi x3, x2, 1
addi x4, x3, 1
addi x5, x3, 1
addi x6, x3, 1
sw	x2, 0(x6)
mul x6, x1, x2
sw	x2, 0(x6)
mul x6, x1, x2
mul x6, x6, x2
sw	x3, 0(x6)
sw	x4, 0(x6)
sw	x5, 0(x6)
wfi