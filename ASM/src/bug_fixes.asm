ladder_softlock_hook:
    or      at, t8, v0 ; at will be non-zero if either unk_6AD or v0 (temp) is non-zero
    jr ra
    lw      t8, 0x066C(s0) ; replaced code

volvagia_softlock_hook:
    lh      t6, 0x022E(s3)      ; replaced code, load work[BFD_INVINC_TIMER]
    lbu     at, 0x00AF(s3)      ; actor.colChkInfo.health
    slti    at, at, 1           ; set at if health is <=0
    jr ra
    or      t6, t6, at          ; t6 will be non-zero if work[BFD_INVINC_TIMER]>0 or health is <=0
