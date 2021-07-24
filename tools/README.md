## IM2PC128.exe
Windows tool to convert picture to bin file loadable to PC128/Thomson MO6 computer.
The picture must be resized, colour reduced, and finally exported to raw file by GIMP program.
usage:
IM2PC128 scrmode inputfile asm
  scrmode:    2 convert to 320x200 4 colour picture
  scrmode:    3 convert to 160x200 16 colour picture
  inputfile:  gimp raw exported picture file (.data extension)
  asm:        if present, it appends loader asm code to view thw picture

For example:
Start GIMP prgram, open picture to be converted, select "Image" menu then select "Mode" then select "Indexed" then select "Generate optimun palette" and type "mximum numbers of colours" 16 then press "Convert"
Next select "Image" menu then select "Scale Image" then arrange "Width" to 160 and "Heigh" to 200 then press "Scale" button.
At the end select "File" menu then select "Export as" then open "Select File Type" chooser and select "Raw image data" then press "EXPORT" and press "EXPORT" in RGB mode.
GIMP will generate .DATA file containing raw data (30000 bytes) and .DATA.PAL file containing raw palette table.
Now launch window terminal and type "IMG2PC128 3 filename.data asm" and the program will generate two files:
filename.data.bin containing picture bin data + asm code
filename.data.pal.txt containing basic list with PALETTE settings.
Now launch DCMOTO, select BASIC128 then select "FILE" menu and select filename.data.pal.txt by "KEYBOARD SIM", then add the following lines:
1 CLEAR,&H5EFF
2 CONSOLE,,,,3:LOCATE,,0
...... PALETTE CODE
1000 EXEC &h5F00:A$=INPUT$(1)
By debugger menu select ram page 7 then load filename.data.bin to the address from 5f00 to 9fff.
Quit debugger and RUN basic program.



