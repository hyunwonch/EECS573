    data = 0x1000
    li	x6, 0
    li	x2, data
    li  x31, 0x0a

    sw  x31, 0(x2)
    lw	x6, 0(x2)
    sw	x6, 0x100(x2)

    sw  x31, 0x08(x2)
    lw	x6, 0x08(x2)
    sw	x6, 0x108(x2)

    sw  x31, 0x10(x2)
    lw	x6, 0x10(x2)
    sw	x6, 0x110(x2)

    sw  x31, 0x18(x2)
    lw	x6, 0x18(x2)
    sw	x6, 0x118(x2)

    sw  x31, 0x20(x2)
    lw	x6, 0x20(x2)
    sw	x6, 0x120(x2)

    sw  x31, 0x28(x2)
    lw	x6, 0x28(x2)
    sw	x6, 0x128(x2)

    sw  x31, 0x30(x2)
    lw	x6, 0x30(x2)
    sw	x6, 0x130(x2)

    sw  x31, 0x38(x2)
    lw	x6, 0x38(x2)
    sw	x6, 0x138(x2)

    sw  x31, 0x40(x2)
    lw	x6, 0x40(x2)
    sw	x6, 0x140(x2)
    
    sw  x31, 0x48(x2)
    lw	x6, 0x48(x2)
    sw	x6, 0x148(x2)

    sw  x31, 0x50(x2)
    lw	x6, 0x50(x2)
    sw	x6, 0x150(x2)

    sw  x31, 0x58(x2)
    lw	x6, 0x58(x2)
    sw	x6, 0x158(x2)
    wfi
