    data = 0x400
    stack = 0x1000
    li  x8, 1
    li  x31,    stack
    li  x2, 0x400

    li x17, 100
    jal x27, func

    sw x1, 0(x2)
    wfi

func:   beq x17, x0, return

    addi    x31,    x31,    -32
    sw  x27,    24(x31)

    sw  x17,    0(x31)
    addi    x17,    x17,    -1
    jal x27,    func
    sw  x1, 8(x31)

    lw  x27, 24(x31)
    addi    x31,    x31,    32
    jalr    x0, x27

return:
    li x1, 1
    jalr x0, x27, 0

