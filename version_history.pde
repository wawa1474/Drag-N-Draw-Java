final String _PROGRAMVERSION_TITLE_ = "PRE_ALPHA";//what version do we display
//_PROGRAMVERSION_FILE_ range is 0-255
//used to figure out what version of our program the save file came from
final byte[] _PROGRAMVERSION_FILE_ = {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};//<- = pre-alpha


/*
VERSION = "PRE_ALPHA";//what version do we display
_PROGRAMVERSION_FILE_ = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};//<- = pre-alpha
  all the things


*/




final int _FILEVERSION_SETTINGS_ = 0;//what version of file saving and loading
/*
load and save program settings
  key binds



file format:

two (2) bytes - file format version

three (3) bytes - background color? (red, green, blue)

key binds
strings with null (0) termination
  //export canvas
  //save map as
  //new map
  //open map
  //save map
  //color tiles
  //tile group
  //cut
  //copy
  //paste
  //tile debug
  //copy color
  //set background color
  //background lines
  //up
  //left
  //down
  //right
  //delete

sixteen (16) bytes - application version
sixteen (16) bytes - magic text ("wawa1474DragDraw")
*/





final int _FILEVERSION_MAP_ = 5;//what version of file saving and loading
/*
format 5:

two (2) bytes - file format version
two (2) bytes - header length

two (2) bytes - map width in tiles
two (2) bytes - map height in tiles

three (3) bytes - background color (red, green, blue)

four (4) bytes - number of tiles
four (4) bytes - number of icons

variable length - tile map name string (null (0) terminated)
variable length - tile map location length (null (0) terminated)

variable length - sixteen (16) byte alignment (0 - 15)

variable length - eight (8) bytes per tile
  one (1) byte - x position
  one (1) byte - y position
  two (2) bytes - image
  one (1) byte - r position
  one (1) byte - g position
  one (1) byte - b position
  one (1) byte - tile flags

variable length - sixteen (16) byte alignment (0 - 15)

variable length - four (4) bytes per icon
  one (1) byte - x position
  one (1) byte - y position
  variable length - file name string (null (0) terminated)
  variable length - hover text string (null (0) terminated)

variable length - sixteen (16) byte alignment (0 - 15)

sixteen (16) bytes - application version
sixteen (16) bytes - magic text ("wawa1474DragDraw")

*/



final int _FILEVERSION_TILEMAP_ = 0;//what version of file saving and loading