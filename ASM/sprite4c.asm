 bra start
 bra hide
sprite fcb $2a,$5f
xhxl fcb $2b,$00
yhyl fcb $2b,$07
bitoffset fcb $00
oldoffset fcb $00,$00
offset fcb $00,$00
sx fcb $03
sy fcb $10
sxneg fcb $00
ix fcb $00
iy fcb $00
regs fcb $00,$00,$00,$00
start
 leax regs,pcr
 sts ,x
 stu 2,x
 leax yhyl,pcr   ;-------------------------------
 ldx ,x
 lda 1,x
 ldb #$a0       ;calcolo offset da y,x
 mul
 lslb
 rola
 leax xhxl,pcr
 ldx ,x
 addd ,x
 pshs d
 lsr ,s
 ror 1,s
 lsr ,s
 ror 1,s
 lsr ,s
 ror 1,s
 lda #0
 andb #$07
 stb bitoffset,pcr   ; salva bitoffset
 puls d
 bra draw
hide
 ldd #$ffff
draw
 std offset,pcr         ;carica nuova pos
 leax sprite,pcr     ;punta dati sprite
 ldx ,x
 ldx ,x
 ldd ,x
 std oldoffset,pcr
 ldd offset,pcr
 std ,x++
 lda ,x+                     ; sx
 sta sx,pcr
 sta ix,pcr
 nega
 sta sxneg,pcr
 nega 
 ldb ,x+                    ;sy
 stb sy,pcr
 stb iy,pcr
 ldy oldoffset,pcr
 ldu offset,pcr
 ldb bitoffset,pcr
 pshs x
;sync2
; lda $a7e7
; anda #$80
; cmpa #$80
; bne sync2
sync
 lda $a7e7
 anda #$80
 bne sync
 cmpy #$ffff
 beq paste
loop                   ; routine di ripristino
 lda $a7c0
 ora #$01
 sta $a7c0
 lda ,x+      ;get  old point
 sta ,y      ;restore old point
 lda $a7c0     
 anda #$fe
 sta $a7c0
 lda ,x+      ;get  old point
 sta ,y+      ;restore old point
 dec ix,pcr
 bne loop
 lda sx,pcr
 sta ix,pcr
 lda sxneg,pcr
 leay a,y
 leay 40,y
 dec iy,pcr
 bne loop
 lda sy,pcr
 sta iy,pcr
 bra skip
paste
 ldb sy,pcr
 mul
 lslb
 rola
 leax d,x
 ldb bitoffset,pcr
skip
 ldu offset,pcr
 cmpu #$ffff
 beq exit
 puls y
loop2                   ; routine di piazzamento
 lda $a7c0
 ora #$01
 sta $a7c0
 lda ,u           ;get new point
 sta ,y+        ;store new point
 lda b,x       ;get spr point
 leax +8,x     ;point to spr data pg2
 ora b,x         ;or with pg2
 leax -8,x    ;point to spr data pg1
 coma          
 anda ,u
 sta ,u        ;mask new point
 lda b,x      ;get spr point
 ora ,u        ;or with dest point
 sta ,u        ;paste spr point
 leax +8,x 
 lda $a7c0     
 anda #$fe
 sta $a7c0
 lda ,u           ;get new point
 sta ,y+        ;store new point
 lda b,x       ;get spr point
 leax -8,x     ;point to spr data pg1
 ora b,x         ;or with pg1
 leax +8,x    ;point to spr data pg2
 coma          
 anda ,u
 sta ,u        ;mask new point
 lda b,x      ;get spr point
 ora ,u        ;or with dest point
 sta ,u+        ;paste spr point
 leax +8,x
 dec ix,pcr
 bne loop2
 lda sx,pcr
 sta ix,pcr
 lda sxneg,pcr
 leau a,u
 leau 40,u
 dec iy,pcr
 bne loop2
 lda sy,pcr
 sta iy,pcr
exit
 lds regs,pc
 ldu regs+2,pcr
 rts
