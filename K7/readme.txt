SPRDEF.k7 USAGE
screen mode CONSOLE,,,,3 (160x200)
loadm
default loading and exec address &h6000, but relocating with loadm"cass:",offset
entry point parameters:
exec address
+ 2 address to write sprite data
+ 4 y,x coordinates of up left corner of the sprite on screen to get
+ 6 widht,height of the sprite

SPRITEXY.K7 USAGE
screen mode CONSOLE,,,,3 (160x200)
loadm
default loading and exec address &h6000, but relocating with loadm"cass:",offset
entry point parameters:
exec address
+ 2 address to read sprite data
+ 4 y,x coordinates of up left corner of the sprite on screen to put
+ 6 flag. setting 0 COPY MODE, setting 1 PASTE MODE


