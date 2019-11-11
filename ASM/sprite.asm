 bra start
sprite fcb $00,$00
offset fcb $20,$19
flags fcb $01
start
 leax flags,pcr
 lda ,x
 lbne redraw   
move
 leax offset,pcr   ;-------------------------------
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
 lda ,x+            ;carica numero di pixel
 sty ,x               ;salva offset
 tfr x,y
 leax 2,x
loop                 
 pshs a
 pshs y
 ldd ,x++   ; prende l'indirizzo del punto
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
 lda ,x
 ldb ,y
 pshs a,b
 lslb
 lslb
 lslb
 lslb
 andb #$f0        ; old  x0
 anda #$0f        ; new 0x
 stb ,x
 ora ,x
 sta ,x+               ;save old 
 puls b,a
 anda #$0f         
 andb #$f0
 stb ,y
 ora ,y
 sta ,y                  ; pos new
 bra exit2
nib1                  ;nibble 1     x0
 lda ,x                ;new
 ldb ,y                ;old
 pshs a,b
 anda #$0f
 andb #$f0
 stb ,x
 ora ,x
 sta ,x+
 puls b,a
 lsla
 lsla
 lsla
 lsla
 anda #$f0
 andb #$0f
 stb ,y
 ora ,y
 sta ,y
exit2
 puls y
 puls a
 deca   ;decrementa il numero di pixel
 lbne loop
 rts
redraw ;******************************
 leax sprite,pcr
 ldx ,x
 lda ,x+
 ldy ,x
 cmpy #$ffff
 lbeq move
 tfr x,y
 leax 2,x
loop2
 pshs a
 pshs y
 ldd ,x++   ; prende l'indirizzo del punto
 addd ,y
 pshs d
 bitb #%00000010
 beq pag1b
pag0b            ;pagina 0
 lda $a7c0
 anda #$fe
 sta $a7c0
 bra exitb
pag1b            ;pagina 1
 lda $a7c0
 ora #$01
 sta $a7c0
exitb
 puls d
 pshs d
 lsra
 rorb
 lsra
 rorb
 tfr d,y
 puls d
 bitb #%00000001
 beq nib1b
nib2b             ;nibble 2   0x
 lda ,x+
 lsra
 lsra
 lsra
 lsra
 ldb ,y
 anda #$0f
 andb #$f0
 stb ,y
 ora ,y
 sta ,y
 bra exit2b
nib1b                  ;nibble 1  x0
 lda ,x+
 ldb ,y 
 anda #$f0
 andb #$0f
 stb ,y
 ora ,y
 sta ,y
exit2b
 puls y
 puls a
 deca   ;decrementa il numero di pixel
 lbne loop2
 lbra move