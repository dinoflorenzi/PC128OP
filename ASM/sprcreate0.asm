 bra skipdata
sizex fcb $01
size fcb $08
nframes fcb $04
sprite fcb $2a,$5f
skipdata
 orcc #$50
 pshs u,x,y,d,dp,cc
 ldu #$9fff
 leax sprite,pcr     ;punta dati sprite
 ldx ,x
 ldx ,x
 ldy #0
 ldd #$2b07
 std, x++
 ldd #$2b00
 std, x++
 ldd #$ffff
 std, x++
 lda sizex,pcr
 sta ,x+
 pshu a
 lda size,pcr
 sta ,x+
 pshu a
 ldb nframes,pcr
 stb ,x+
 leax a,x
 leax a,x
 ldb #40
 subb sizex,pcr
 lda #1
 pshu a
loop
 lda $a7c0
 ora #$01
 sta $a7c0
 lda ,y
 sta ,x+
 lda $a7c0
 anda #$FE
 sta $a7c0
 lda ,y+
 sta ,x+
 dec 1,u
 beq exit
 dec 2,u
 bne loop
 leay b,y
 lda sizex,pcr
 sta 2,u
 bra loop
exit
 tfr d,y
 lda size,pcr
 sta 1,u
 lda sizex,pcr
 sta 2,u
 ldb ,u
 mul
 exg d,y
 inc ,u
 lda nframes,pcr
 cmpa ,u 
 bhs loop
 tfr x,y
 leax sprite,pcr
 ldx ,x
 sty ,x
 puls u,x,y,d,dp,cc
 andcc #$af
 rts