 bra start
sprite fcb $0f,$a0            ;data pointer
sx fcb $02                    ;size x
sy fcb $08                     ;size y
sxn fcb $00                 ;size x neg               
ix fcb $00                    ;index x
iy fcb $00                    ;index y
ib fcb $07                   ;index bit
pg fcb $02                  ;index pag
offset fcb $00,$00            ; x,y
regs fcb $00,$00,$00,$00
start
 sts regs,pcr
 stu regs+2,pcr
 lda sx,pcr
 sta ix,pcr
 nega
 sta sxn,pcr
 lda sy,pcr
 sta iy,pcr
 lda $a7c0
 ora #$01
 sta $a7c0
 leax offset,pcr
 lda 1,x
 ldb #40
 mul
 addd ,x
 tfr d,y
 pshs y
 leax sprite,pcr     ;punta dati sprite
 ldx ,x
 lda #$ff
 sta ,x+
 sta ,x+
 lda sx,pcr
 sta ,x+
 lda sy,pcr
 sta ,x+
loop2            
 lda ,y+
 sta ,x+       
 dec ix,pcr       
 bne loop2
 lda sx,pcr
 sta ix,pcr
shift
 ldb sxn,pcr
 lda b,x
 rora
 sta ,x+
 dec ix,pcr
 bne shift
 lda sx,pcr
 sta ix,pcr
 andcc #$fe
 dec ib,pcr
 bne shift
 lda #7
 sta ib,pcr
 lda sx,pcr
 nega
 leay a,y
 leay 40,y
 dec iy,pcr
 andcc #$fe
 bne loop2
 lda sy,pcr
 sta iy,pcr
 lda $a7c0
 anda #$fe
 sta $a7c0
 puls y
 dec pg,pcr
 bne loop2
exit
 lda #2
 sta pg,pcr
 lds regs,pcr
 ldu regs+2,pcr
 rts
 