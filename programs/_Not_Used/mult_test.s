li x1, 0x8
li x2, 0x8
li x3, 0xa
li x4, 0x1
mul x5, x1, x2
mul x6, x3, x4
addi x5, x5, 1
mul x10, x5, x6
add x10, x10, x5
wfi

