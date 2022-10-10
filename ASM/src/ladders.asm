ladder_softlock_hook:
    lw      t4, 0x0664(s0)  ; load func_674 to t4
    lui     t5, 0x803a      ; load the address of func_8084C5F8
    addiu   t5, t5, 0x3024
    beq     t4, t5, @@return; func_674 is func_8084C5F8, load t2 so that the state check fails
    lui     t2, 0x0420
    lw      t2, 0x066c(s0)  ; func_674 is not func_8084C5F8, load stateFlags1 normally

@@return:
    jr ra
    nop