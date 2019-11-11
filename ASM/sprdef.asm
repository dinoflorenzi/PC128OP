 bra start
sprite fcb $00,$00
upsx fcb 0,0            ;y1,x1
dx fcb 10
dy fcb 10
tx fcb 00
ty fcb 00
reg fcb 0,0
flags fcb $01
start
 leax reg,pcr
 sts ,x
 leax flags,pcr
 lda ,x
 leax upsx,pcr   ;-------------------------------
 ldd ,x
 pshs b
 ldb #$a0       ;calcolo offset da y,x
 mul
 tfr d,x
 puls b
 abx
 tfr x ,y             ;------------------------------
 leax sprite,pcr     ;punta dati sprite
 ldx ,x
 lda ,x+           ;carica numero di pixel
 sty ,x             ;salva offset
 tfr x,y
 leax 2,x
 ldd #0
loop
 pshs d,y
 addd ,y    ;somma l'offset
 pshs d
 bitb #%00000010
 beq pag1
pag0            ;pagina 0
 lda $a7c0
 anda #$fe
 sta $a7c0
 bra exit
pag1            ;pagina 1
 lda $a7c0
 ora #$01
 sta $a7c0
exit
 puls d
 pshs d
 lsra
 rorb
 lsra
 rorb
 tfr d,y
 puls d
 bitb #%00000001
 beq nib1
nib2             ;nibble 2    0x
 ldb ,y
 andb #$0f
 cmpb #00
 beq exit2
 pshs x
 leax sprite,pcr
 ldx ,x
 inc ,x
 puls x
 leax 2,x
 stb ,x+
 puls d
 std -3,x
 pshs d
 bra exit2
nib1                  ;nibble 1     x0
 ldb ,y                
 lsrb
 lsrb
 lsrb
 lsrb
 andb #$0f
 cmpb #00
 beq exit2
 pshs x
 leax sprite,pcr
 ldx ,x
 inc ,x
 puls x
 leax 2,x
 stb ,x+
 puls d
 std -3,x
 pshs d
exit2
 pshs x
 leax upsx,pcr
 lda 2,x
 inc 4,x
 cmpa 4,x
 bne xinc
 lda #0
 sta 4,x
 lda 3,x
 inc 5,x
 cmpa 5,x
 bne yinc
 lda #0
 sta 5,x
 leax sprite,pcr
 ldx ,x
 leax 1,x
 ldy #$ffff
 sty ,x
 leax reg,pcr
 lds ,x
 rts
xinc
 puls x
 puls d,y
 pshs x
 tfr d,x
 leax 1,x
 tfr x,d
 puls x
 lbra loop
yinc
 puls x
 puls d,y
 pshs x
 leax upsx,pcr
 lda 5,x
 ldb #$a0
 mul
 puls x
 lbra loop