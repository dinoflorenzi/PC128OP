 bra start
 bra hide
sprite fcb $2a,$5f   ;address var A%
xhxl fcb $2b,$00     ;address var X%
yhyl fcb $2b,$07     ;address var Y%
bitoffset fcb $00     ;
oldoffset fcb $00,$00
offset fcb $00,$00
sx fcb $03             ; size x in char 
sy fcb $10             ; size y in pixel
ix fcb $00             ; x counter
iy fcb $00             ; y counter
sxneg fcb $00      ; newline offset
regs fcb $00,$00,$00,$00   
start
 leax regs,pcr
 sts ,x
 stu 2,x
 ;-------------------------------
 leax [yhyl,pcr]
 lda 1,x
 ldb #$a0       ;calcolo offset da y,x
 mul
 lslb
 rola
 leax [xhxl,pcr]
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
 ldx [,x]
 ldd ,x
 std oldoffset,pcr  
 ldd offset,pcr
 std ,x++
 ldd ,x++                     ; sx
 std sx,pcr
 std ix,pcr
 nega
 adda #40
 sta sxneg,pcr
 ldy oldoffset,pcr
 ldu offset,pcr
 ldb bitoffset,pcr
 pshs x
;sync2
; lda $a7e7
; anda #$80
; cmpa #$80
; bne sync2
 lda $a7c0
 anda #$fe
 pshs a
 ora #$01
 pshs a
sync
 lda $a7e7
 anda #$80
 bne sync
 cmpy #$ffff
 beq paste
loop                   ; routine di ripristino
 lda ,s       
 sta $a7c0   ; change video page
 lda ,x+      ;get  old point
 sta ,y      ;restore old point
 lda 1,s
 sta $a7c0    ; change video page
 lda ,x+      ;get  old point
 sta ,y+      ;restore old point
 dec ix,pcr
 bne loop
 lda sx,pcr
 sta ix,pcr
 lda sxneg,pcr
 leay a,y
 dec iy,pcr
 bne loop
 lda sy,pcr
 sta iy,pcr
 bra skip
paste
 lda sx,pcr
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
 ldy 2,s
loop2                   ; routine di piazzamento
 lda ,s
 sta $a7c0     ; change video page
 lda ,u           ;get new point
 sta ,y+        ;store new point
 lda b,x       ;get spr point
 leax +8,x     ;point to spr data pg2
 ora b,x         ;or with pg2
 leax -8,x    ;point to spr data pg1
 coma          
 pshs a       ; ****
 anda ,u
 sta ,u        ;mask new point
 lda b,x      ;get spr point
 ora ,u        ;or with dest point
 sta ,u        ;paste spr point
 leax +8,x 
 lda 2,s
 sta $a7c0     ; change video page
 lda ,u           ;get new point
 sta ,y+        ;store new point
 puls a         ;valore ****
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
 dec iy,pcr
 bne loop2
exit
 lds regs,pcr
 ldu regs+2,pcr
 rts
