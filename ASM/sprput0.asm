 pshs u,x,y,dp,d,cc
 ldu #$9fff
 bra main
sprlist fcb $62,$00
collis fcb $00
main
 orcc #$50
  ;                ripristino  sfondo
 clr collis,pcr
 ldx sprlist,pcr
 pshu x
loop2
 ldy ,u
 ldy ,y
 cmpy #0
 beq exit2
 leay 4,y             ; skip to old screen addr
 ldx ,y++          ; get old screen addr
 ldd ,y++        ; dx - size sprite
 pshu d
 pshu d
 cmpx #$ffff
 beq exit
 leay 1,y
 ldb #40
 subb 2,u
loop
 lda $a7c0
 ora #$01
 sta $a7c0
 lda ,y+
 sta ,x
 lda $a7c0
 anda #$FE
 sta $a7c0
 lda ,y+
 sta ,x+
 dec 1,u
 beq exit
 dec ,u
 bne loop
 lda 2,u
 sta ,u
 leax b,x
 bra loop
exit
 leau 4,u
 inc 1,u
 inc 1,u
 bra loop2
exit2
 leau 2,u
; salvataggio nuovo sfondo
 ldx sprlist,pcr
 pshu x
loop2A
 ldy ,u
 ldy ,y
 cmpy #0
 beq exit2A
 ldx ,y++
 ldd ,x      ; y  coords (pixels)
 lda #40
 mul
 tfr d,x
 pshu x
 ldx ,y++
 ldd ,x        ; x coords (chars)
 pulu x
 abx             ; start screen addr
 stx ,y++       ;store new addr
 ldd ,y++        ; dx - size sprite
 pshu d
 pshu d
 lda ,y+           ;n frame, if 0
 lbeq clraddr      ;skip save background
 ldb #40
 subb 2,u
loopA
 lda $a7c0
 ora #$01
 sta $a7c0
 lda ,x
 sta ,y+
 lda $a7c0
 anda #$FE
 sta $a7c0
 lda ,x+
 sta ,y+
 dec 1,u
 beq exitA
 dec ,u
 bne loopA
 lda 2,u
 sta ,u
 leax b,x
 bra loopA
exitA
 leau 4,u
 inc 1,u
 inc 1,u
 bra loop2A
exit2A
 leau 2,u
 ;                 disegno sprite 
 ldx sprlist,pcr
 pshu x
loop2B
 lsl collis,pcr
 ldy, u
 ldy ,y
 cmpy #0
 beq exit2B
 leay 4,y
 ldx ,y++         ; carica start screen address
 ldd ,y++        ; dx - size sprite
 pshu d
 pshu d
 lda ,y+         ;read n frame 
 beq exitB    ;skip sprite draw if 0
selframe
 leay b,y
 leay b,y
 deca
 bne selframe
 ldb #40
 subb 2,u
loopB
 lda $a7c0
 ora #$01
 sta $a7c0
 lda ,x
 anda ,y
 beq skip
 ;                 collision check
 lda collis,pcr
 ora #1
 sta collis,pcr
skip
 lda ,x
 ora ,y+
 sta ,x
 lda $a7c0
 anda #$FE
 sta $a7c0
 lda ,y+ 
 sta ,x+
 dec 1,u
 beq exitB
 dec ,u
 bne loopB
 lda 2,u
 sta ,u
 leax b,x
 bra loopB
exitB
 leau 4,u
 inc 1,u
 inc 1,u
 bra loop2B
clraddr          ;clear old addr if nframe=0
 ldd #$ffff
 std -5,y
 lbra exitA
exit2B
 puls u,x,y,dp,d,cc
 rts
 fcb $01,$01
 fcb $01,$01
