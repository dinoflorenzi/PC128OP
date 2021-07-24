# IM2PC128.exe
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
Next select "Image" menu then select "Scale Image" then arrange "Width" to 160 and "Heigh" to 200 then press "Scale" button.7
At the end select "File" menu then select "Export as" then open "Select File Type" chooser and select "Raw image data" then press "EXPORT" and press "EXPORT" in RGB mode.
GIMP will generate .DATA file containing raw data (30000 bytes) and .DATA.PAL file containing raw palette table.



