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

SPRGET4C.k7
utility to grab sprite from screen to memory location.
 USAGE
screen mode CONSOLE,,,,2 (320x200)
loadm
default loading and exec address &h6000, but relocating with loadm"cass:",offset
entry point parameters:
exec address
+ 2 (16 bit) address to write sprite data
+ 4 widht (char) ,height (pixel) of the sprite
the image to grab must be on the up-left corner of the screen. The width must be one char plus of the effective size. The height could be the same of the sprite in pixel.

SPRITE4C.K7 
utility to move sprite on the screen without clear the background.
USAGE
screen mode CONSOLE,,,,2 (320x200)
loadm
default loading and exec address &h6000, but relocating with loadm"cass:",offset
entry point parameters:
exec address
+ 2 (16 bit) address to read sprite data
+ 4 x(16 bit),y(16 bit) pointers to integer variable (use varptr to get) setting the coordinates  x,y of the sprite on screen to put
