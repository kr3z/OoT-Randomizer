serenade_cs_hook:
    addiu   sp, sp, -0x24
    sw      t2, 0x10 (sp)
    sw      a0, 0x14 (sp)
    sw      v1, 0x18 (sp)
    sw      ra, 0x1C (sp)
    ;;sw      ra, 0x10 (sp)
    jal     0x0006FDCC
    nop

    lh      t2, triforce_hunt_enabled
    addi    at, zero, 2
    bne     t2, at, @@return
    lw      a0, 0x18 (sp)
    jal     warp_to_credits
    nop

@@return:
    lw      t2, 0x10 (sp)
    lw      a0, 0x14 (sp)
    lw      v1, 0x18 (sp)
    lw      ra, 0x1C (sp)
    ;;lw      ra, 0x10 (sp)
    jr      ra
    addiu   sp, sp, 0x24