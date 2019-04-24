/*
load and save program settings
  key binds



file format:

two (2) bytes - file format version
two (2) bytes - header length

three (3) bytes - background color (red, green, blue)

key binds
???!?!?!?!?!?!?!?

sixteen (16) bytes - application version
sixteen (16) bytes - magic text ("wawa1474DragDraw")
*/

final int _FILEVERSION_SETTINGS_ = 0;//what version of file saving and loading