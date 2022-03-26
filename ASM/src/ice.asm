;;;serenade_cs_hook:
;;;    addiu   sp, sp, -0x24
;;;    sw      t2, 0x10 (sp)
;;;    sw      a0, 0x14 (sp)
;;;    sw      v1, 0x18 (sp)
;;;    sw      ra, 0x1C (sp)
;;;    ;;sw      ra, 0x10 (sp)
;;;    jal     0x0006FDCC
;;;    nop

;;;    lh      t2, triforce_hunt_enabled
;;;    addi    at, zero, 2
;;;    bne     t2, at, @@return
;;;    lw      a0, 0x18 (sp)
;;;    jal     warp_to_credits
;;;    nop

;;;@@return:
;;;    lw      t2, 0x10 (sp)
;;;    lw      a0, 0x14 (sp)
;;;    lw      v1, 0x18 (sp)
;;;    lw      ra, 0x1C (sp)
;;;    ;;lw      ra, 0x10 (sp)
;;;    jr      ra
;;;    addiu   sp, sp, 0x24

;;;setup_serenade_action_hook:
;;;    addiu   sp, sp, -0x14
;;;    sw      ra, 0x14 (sp)
;;;    jal     0x00020EB4
;;;    nop
;;;    lw      ra, 0x14 (sp)
;;;    jr ra
;;;    addiu   sp, sp, 0x14


;;;EnXc_Init_hook:
;;;    lui     a2, 0x8002
;;;    jr      ra
;;;    addiu   a2, a2, 0xEFF4

EnXc_Update_hook:
    addiu   sp, sp, -0x28
    sw      ra, 0x24 (sp)
    sw      v0, 0x20 (sp)
    sw      v1, 0x1C (sp)
    sw      a0, 0x18 (sp)
    sw      a1, 0x14 (sp)

    lhu     t6, triforce_hunt_enabled
    addiu   at, zero, 2
    bne     t6, at, @@update_return

    lh      t6, 0x001C (A0) ; load shiek type
    addiu   at, zero, 0x0008 ; serenade type
;    addiu   at, zero, 0x0006 ; minuet type
    bne     t6, at, @@update_return ; return if not right sheik
    nop
    lui     v0, 0x8012
    addiu   v0, v0, 0xA5D0
    lhu     t6, 0xEDE (v0) ; gSaveContext.eventChkInf[5]
    andi    t6, t6, 0x0004 ; 4 for serenade
;    andi    t6, t6, 0x0001 ; 1 for minuet
    beq     t6, zero, @@update_return
    nop

    jal     0x8009CB08 ; Gameplay_InCsMode
    or      a0, a1, zero
    bne     v0, zero, @@update_return ; return if in Cs mode
    nop

    lui     a0, 0x8012
    addiu   a0, a0, 0xA5D0
    lbu     t6, 0xB2 (a0)
    andi    t6, t6, 1
    beq     t6, zero, warp_to_credits
    nop


@@update_return:
    lw      v1, 0x1C (sp)
    lw      a1, 0x14 (sp)
    lw      a0, 0x18 (sp)    
    jalr    v1, ra ; needs to be backwards
    lw      v0, 0x20 (sp)

    lw      ra, 0x24 (sp)
    jr ra
    addiu   sp, sp, 0x28