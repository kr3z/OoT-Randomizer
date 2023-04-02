ladder_softlock_hook:
    lui     t1, 1
    sll     t5, t1, 5 ; PLAYER_STATE1_21 
    and     t5, t5, t2
    beq     t5, zero, @@return ; not in climbing state

    lw      t4, 0x0664(s0)  ; load func_674 to t4
    ;lui     t5, 0x803a      ; load the address of func_8084C5F8
    ;addiu   t5, t5, 0x3024
    la      t5, GLOBAL_CONTEXT
    addu    t5, t5, t1 
    lw      t5, 0x1D40(t5); loads address of Player_UpdateCommon
    addiu   t5, t5, 0x35C8 ; address of func_8084C5F8

    beq     t4, t5, @@return; func_674 is func_8084C5F8, load t2 so that the state check fails
    lui     t2, 0x0420
    lw      t2, 0x066c(s0)  ; func_674 is not func_8084C5F8, load stateFlags1 normally

@@return:
    jr ra
    addiu   t3, $zero, 0x0003 ; replaced code

ladder_softlock_but_different_hook:
    sll     t0, t9, 8           ; replaced code
    blt     t0, zero, @@return  ; return if stateFlags1 & PLAYER_STATE1_23
    lbu     t9, 0x069D(s0)
    addiu   at, zero, 3
    bne     t9, at, @@return    ; return of unk_6AD is not 3
    lui     at, 1
    la      t9, GLOBAL_CONTEXT
    addu    t9, t9, at 
    lw      t9, 0x1D40(t9)      ; loads address of Player_UpdateCommon
    addiu   t9, t9, 0x35C8      ; address of func_8084C5F8
    lw      at, 0x0664(s0)      ; load func_674 to at
    bne     t9, at, @@return    ; return if func_674 is not func_8084C5F8
    nop
    lui     t0, 0x8000 ; set t0 to a negative value so the branch fails after returning

@@return:
    jr ra
    nop

ladder_softlock_but_third_hook:
    bne     v0, zero, @@return
    or      at, zero, v0

    addiu   at, zero, 3
    bnel    at, t8, @@return    ; if unk_6AD is not 3, restore v0 value to at
    or      at, zero, v0
    addiu   at, zero, 0xFFFF    ; otherwise, set at to -1

@@return:
    jr ra
    lw      t8, 0x066C(s0) ; replaced code

volvagia_softlock_hook:
    lbu     t6, 0x00AF(s3)      ; actor.colChkInfo.health
    slti    t6, 1               ; set t6 if health is <=0
    beql    t6, zero, @@return  ; if health>0, load work[BFD_INVINC_TIMER] normally
    lh      t6, 0x022E(s3)      ; replaced code

@@return:
    jr ra                       ; if health<=0 t6 is set to prevent collision check
    nop
    

weirdshot_crash_hook:
    slti    t0, t1, 9           ; set t0 if eyeIndex is a valid index
    bne     zero, t0, @@mouth
    sra     t4, v0,  4          ; load mouthIndex (replaced code)

    add     t1, zero, zero      ; set eyeIndex = 0

@@mouth:
    slti    t0, t4, 5           ; set t0 if mouthIndex is a valid index
    bne     zero, t0, @@return
    nop

    add     t4, zero, zero      ; set mouthIndex = 0

@@return:
    jr      ra
    nop
    