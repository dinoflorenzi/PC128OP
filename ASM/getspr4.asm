  bra start
sprite fcb $62,$00           ;data pointer
sx fcb $03                   ;size x
sy fcb $0f                     ;size y
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
 ldb sy,pcr
 stb ,x+
 mul
 lslb
 rola
 leax d,x
loop2
 pshs x
 pshs x
loop      
 lda $a7c0
 ora #$01
 sta $a7c0
 lda ,y
 sta ,x
 lda $a7c0
 anda #$fe
 sta $a7c0
 lda ,y+
 sta 8,x
 leax 16,x       
 dec ix,pcr       
 bne loop
 lda sx,pcr
 sta ix,pcr
 puls x
 pshs x
shift
 lda ,x
 rora
 sta 1,x
 leax 16,x
 dec ix,pcr
 bne shift
 puls x
 leax 1,x
 pshs x
 lda sx,pcr
 sta ix,pcr
 andcc #$fe
 dec ib,pcr
 bne shift
 lda #7
 sta ib,pcr
 puls x
 puls x
 pshs x
 leax 8,x
 pshs x
 dec pg,pcr
 bne shift
 lda sx,pcr
 nega
 leay a,y
 leay 40,y
 puls x
 puls x
 lda sx,pcr
 ldb #$10
 mul
 leax d,x
 dec iy,pcr
 andcc #$fe
 lbne loop2
 lda sy,pcr
 sta iy,pcr
 lda #2
 sta pg,pcr
 lds regs,pcr
 ldu regs+2,pcr
 rts
 fcb $80,$80,$80,$80,$80,$80,$80,$80
 fcb $80,$80,$80,$80,$80,$80,$80,$80
 fcb $80,$80,$80,$80,$80,$80,$80,$80
 fcb $80,$80,$80,$80,$80,$80,$80,$80