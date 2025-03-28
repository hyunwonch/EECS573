    li a0, 12
    li a2, 342
    li sp, 2048
    addi sp, sp, 4
    add a0, a2, a0
    add a0, a2, a0
    sw a0, 0(sp)
    add a0, a2, a0
    add a0, a2, a0
    add a0, a2, a0
    lw a0, 0(sp)
    sub a0, a2, a0
    wfi
