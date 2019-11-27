 bra getscr
 bra putscr
destptr fcb $2a,$5f
regs fcb $00,$00
getscr
 sts regs,pcr
 leax destptr,pcr
 ldx ,x
 ldx ,x
 leax 2,x
 lda #2
 pshs a
 ldb #$ff
 ldy #0
 lda $a7c0
 ora #$01
 sta $a7c0
loop
 lda ,y+
 sta ,x+
 clr ,x
 cmpy #$1f41
 beq  exit3
count
 inc ,x
 cmpb ,x
 beq subr
 cmpy #$1f41
 beq  exit
 cmpa ,y+
 beq count
 leay -1,y
 leax 1,x
 bra loop
exit
 leax 1,x
exit3
 lda $a7c0
 anda #$fe
 sta $a7c0
 ldy #0
 dec ,s
 bne loop
 puls a
 leay destptr,pcr
 ldy ,y 
 stx ,y
 lds regs,pcr
 rts
subr
 leax 1,x
 bra loop
putscr  ;*****************************
 sts regs,pcr
 leax destptr,pcr
 ldx ,x
 ldx ,x
 leax 2,x
 lda #2
 pshs a
 ldy #0
 lda $a7c0
 ora #$01
 sta $a7c0
loop2
 lda ,x+
 ldb ,x+
loop3
 sta ,y+
 cmpy #$1f41
 beq exit2
 decb
 bne loop3
 bra loop2
exit2
 ldy #0
 lda $a7c0
 anda #$fe
 sta $a7c0
 dec ,s
 bne loop2
 puls a
 leax -1,x
 leay destptr,pcr
 ldy ,y 
 stx ,y
 lds regs,pcr
 rts
 