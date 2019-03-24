/*
format 4:

two (2) bytes - file version
two (2) bytes - header length

one (1) byte - tile map name length
one (1) byte - tile map location length

four (4) bytes - number of tiles
four (4) bytes - number of icons

three (3) bytes - background color (red, green, blue)

variable length - tile map name string
variable length - tile map location length

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
  one (1) byte - file name length
  one (1) byte - hover text length
  variable length - file name string
  variable length - hover text string

variable length - sixteen (16) byte alignment (0 - 15)

sixteen (16) bytes - magic text ("wawa1474DragDraw")

*/

/*
format 5:

two (2) bytes - file version
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

sixteen (16) bytes - magic text ("wawa1474DragDraw")

*/