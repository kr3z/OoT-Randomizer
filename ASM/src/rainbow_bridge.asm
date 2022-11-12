rainbow_bridge:
    addiu   sp, sp, 0xFFE0
    sw      ra, 0x18(sp)

    ; RAINBOW_BRIDGE_CONDITION
    ; 0x01 - forest medallion
    ; 0x02 - fire medallion
    ; 0x04 - water medallion
    ; 0x08 - spirit medallion
    ; 0x10 - shadow medallion
    ; 0x20 - light medallion
    ; 0x40 - dungeons flag
    ; 0x80 - light arrows
    ; 0x0100 - ice arrows
    ; 0x0200 - double defense
    ; 0x0400 - Nayru's love
    ; 0x0800 - 
    ; 0x1000 - 
    ; 0x2000
    ; 0x4000
    ; 0x8000
    ; 0x010000
    ; 0x020000
    ; 0x040000 - kokiri emerald
    ; 0x080000 - goron ruby
    ; 0x100000 - zora sapphire
    ; 0x200000 - Stone of Agony

    ; RAINBOW_BRIDGE_COUNT
    ; 0x07 - medallion count
    ; 0x18 - stone count
    ; 0x0f - dungeon count
    ; 0x03e0 - heart count
    ; 0x0ffc00 - token count

    ; v0 quest status
    ; t0 bridge count
    ; t1 bridge condition
    ; t2 - return condition
    ; t4 counter
    ; t5 target count

; initialize some registers
    lw        t1, RAINBOW_BRIDGE_CONDITION
    lw        t0, RAINBOW_BRIDGE_COUNT
    and       t4, zero, zero ; set our counter to 0

    andi      at, t1, 0x40 ; pull out dungeons flag
    bgtzl     at, @@dungeon_rewards ; skip medallions/stones check
    addiu     t6, zero, 0x1 ; set t6 to 1

;medallions
    andi      t5, t0, 0x7 ; medallion count
    sub       at, t5, t6 ; subtract 1 from medallion count
    bgezal    at, @@countbits ; only branch if medallion count > 0
    andi      t2, v0, 0x3F ; obtained medallions
    

;stones
    lui       t2, 0x1C ; bit mask for stones
    andi      t5, t0, 0x18 ; stone count
    srl       t5, t5, 3
    sub       at, t5, t6 ; subtract 1 from stone count
    bgezal    at, @@countbits ; only branch if stone count > 0    
    and       t2, v0, t2 ; obtained stones
    
    beq       zero, zero, @@afterdungeons ; skip over dungeons
    nop

@@countbits:
    andi      at, t2, 0x1 ; extract rightmost bit of t2
    srl       t2, t2, 1 ; shift t3 right and loop
    bgtz      t2, @@countbits
    addu      t4, t4, at 
    sltu      at, t4, t5 ; if count < target
    bgtz      at, @@return; fail and return
    nop

    jr ra ; otherwise return successfully
    nop

@@dungeon_rewards:
    lui       t2, 0x1C
    addiu     t2, t2, 0x3F ; bit mask for dungeon rewards
    andi      t5, t0, 0xf ; dungeon count
;    jal       @@countbits
    sub       at, t5, t6 ; subtract 1 from dungeon count
    bgezal    at, @@countbits ; only branch if dungeon count > 0
    and       t2, v0, t2 ; obtained rewards

@@afterdungeons:
    ; 0x03e0 - heart count
    ; 0x0ffc00 - token count
    andi      t5, t0, 0x03e0 ; heart count
    srl       t5, t5, 1 ; heart count * 0x10
    lh        t7, 0x2E(a3) ; Heart Containers * 0x10
    sltu      t4, t7, t5

    srl       t5, t0, 10
    andi      t5, t5, 0x03FF ; token count
    lh        t7, 0xD0(a3) ; Gold Skulltulas
    sltu      at, t7, t5
    addu      t4, t4, at

    bgtz      t4, @@fail ; if t4>0, either hearts or tokens failed
    nop

    lui       at, 0x3C
    addiu     at, at, 0x3F ; load 0x3C003F into at
    and       t2, v0, at ; obtained quest items

    lbu       t7, 0x84(a3) ; Light arrow slot
    addiu     t5, zero, 0x12 ; light arrow item id
    sltu      t4, t7, t5
    sltu      at, t2, t5
    addu      t4, t4, at ; t4 is 0 if we have light arrows
    sltiu     at, t4, 1 
    sll       at, at, 7 ; shift to 0x80
    or        t2, t2, at

    lbu       t7, 0x7E(a3) ; Ice arrow slot
    addiu     t5, zero, 0x0c ; ice arrow item id
    sltu      t4, t7, t5
    sltu      at, t2, t5
    addu      t4, t4, at ; t4 is 0 if we have ice arrows
    sltiu     at, t4, 1
    sll       at, at, 8 ; shift to 0x100
    or        t2, t2, at

    lbu       t7, 0xCF(a3) ; Doube Defense hearts
    sltiu     t5, t7, 1 ; set if no double defense
    sltiu     at, t5, 1 
    sll       at, at, 9 ; shift to 0x200
    or        t2, t2, at

    lbu       t7, 0x85(a3) ; nayrus slot
    addiu     t5, zero, 0x13 ; nayrus item id
    sltu      t4, t7, t5
    sltu      at, t2, t5
    addu      t4, t4, at ; t4 is 0 if we have nayrus
    sltiu     at, t4, 1
    sll       at, at, 10 ; shift to 0x400
    or        t2, t2, at

    ;0x3C07Bf
    lui       at, 0xFFFF
    addiu     at, at, 0xFFBF
    and       at, at, t1 ; bride condition minus dungeon flag
    and       t2, t2, at 
    beq       t2, at, @@return
    nop

@@fail:
    addiu     t2, zero, 1   
    and       at, zero, zero    ; set at and t2 to be different

@@return:
    lw      ra, 0x18(sp)
    addiu   sp, sp, 0x20
    jr ra
    nop
