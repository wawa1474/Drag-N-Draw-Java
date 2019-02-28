/*
format 4:

two (2) bytes - file version
two (2) bytes - header length

one (1) byte - tile map name length
one (1) byte - tile map location length

four (4) bytes - number of tiles
four (4) bytes - number of icons

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

//--------------------------------------------------------------------------------------------------------------

/*
format A:

two (2) bytes - file version (0 - 65535)
two (2) bytes - header length (0 - 65535)

one (1) byte - tile map name length (0 - 255)
one (1) byte - tile map location length (0 - 255)

four (4) bytes - number of tiles (0 - 2,147,483,647) (would theoretically be twice this but its held in an int)
four (4) bytes - number of icons (0 - 2,147,483,647) (would theoretically be twice this but its held in an int)

variable length - tile map name string (0 - 255)
variable length - tile map location length (0 - 255)

variable length - sixteen (16) byte alignment (0 - 15)

variable length - four (4) bytes per tile
  one (1) byte - x position (0 - 255)
  one (1) byte - y position (0 - 255)
  six (6) bits - color palette (0 - 63), one (1) bit - clear flag, one (1) bit - image number
  one (1) byte - image (0 - 511)

variable length - sixteen (16) byte alignment (0 - 15)

variable length - five (5) bytes per icon
  one (1) byte - x position (0 - 255)
  one (1) byte - y position (0 - 255)
  one (1) byte - file name length (0 - 255)
  one (1) byte - hover text length (0 - 255)
  four (4) bits - color palette (0 - 15), one (1) bit - clear flag, three (3) bits - reserved
  variable length - file name string (0 - 255)
  variable length - hover text string (0 - 255)

variable length - sixteen (16) byte alignment (0 - 15)

// one (1) byte - tile color palette length (0 - 255)
// one (1) byte - icon color palette length (0 - 255)

two hundred fifty-six (256) bytes - tile color palette

sixteen (16) bytes - icon color palette

sixteen (16) bytes - magic text ("wawa1474DragDraw")

*/

//--------------------------------------------------------------------------------------------------------------

/*
format B:

two (2) bytes - file version (0 - 65535)
two (2) bytes - header length (0 - 65535)

one (1) byte - tile map name length (0 - 255)
one (1) byte - tile map location length (0 - 255)

// four (4) bytes - number of tiles (0 - 2,147,483,647) (would theoretically be twice this but its held in an int)
// four (4) bytes - number of icons (0 - 2,147,483,647) (would theoretically be twice this but its held in an int)
two (2) bytes + one (1) bit - number of tiles (0 - ‭131071‬) (two tiles for every space)
one (1) byte + seven (7) bits - number of icons (0 - ‭32767‬‬) (one icon for every other space)

variable length - tile map name string (0 - 255)
variable length - tile map location length (0 - 255)

variable length - sixteen (16) byte alignment (0 - 15)

variable length - four (4) bytes per tile
  one (1) byte - x position (0 - 255)
  one (1) byte - y position (0 - 255)
  one (1) byte - image (0 - 255)
  seven (7) bits - color palette (1 - 127, 0 is reserved for a clear "flag"), one (1) bit - reserved

variable length - sixteen (16) byte alignment (0 - 15)

variable length - five (5) bytes per icon plus variable length file name and hover text
  one (1) byte - x position (0 - 255)
  one (1) byte - y position (0 - 255)
  one (1) byte - file name length (0 - 255)
  one (1) byte - hover text length (0 - 255)
  four (4) bits - color palette (0 - 15), one (1) bit - clear flag, three (3) bits - reserved
  variable length - file name string (0 - 255)
  variable length - hover text string (0 - 255)

variable length - sixteen (16) byte alignment (0 - 15)

// one (1) byte - tile color palette length (0 - 255)
// one (1) byte - icon color palette length (0 - 255)

two hundred fifty-six (256) bytes - tile color palette

//sixteen (16) bytes - icon color palette (maybe use the last/first? colors of the tile color palette for this too)

sixteen (16) bytes - magic text ("wawa1474DragDraw")

*/

//--------------------------------------------------------------------------------------------------------------

/*
format C:

two (2) bytes - file version (0 - 65535)
two (2) bytes - header length (0 - 65535)

one (1) byte - tile map name length (0 - 255)
one (1) byte - tile map location length (0 - 255)

four (4) bytes - number of tiles (0 - 2,147,483,647) (would theoretically be twice this but its held in an int)
four (4) bytes - number of icons (0 - 2,147,483,647) (would theoretically be twice this but its held in an int)
// two (2) bytes + one (1) bit - number of tiles (0 - ‭131071‬) (two tiles for every space)
// one (1) byte + seven (7) bits - number of icons (0 - ‭32767‬‬) (one icon for every other space)

variable length - tile map name string (0 - 255)
variable length - tile map location length (0 - 255)

variable length - sixteen (16) byte alignment (0 - 15)

variable length - eight (8) bytes per tile
  one (1) byte - x position (0 - 255)
  one (1) byte - y position (0 - 255)
  two (2) bytes - image (0 - 65535)
  one (1) byte - color palette (1 - 255, 0 is reserved for a clear "flag")
  three (3) bytes - reserved

variable length - sixteen (16) byte alignment (0 - 15)

variable length - five (5) bytes per icon plus variable length file name and hover text
  one (1) byte - x position (0 - 255)
  one (1) byte - y position (0 - 255)
  one (1) byte - file name length (0 - 255)
  one (1) byte - hover text length (0 - 255)
  five (5) bits - color palette (1 - 31, 0 is reserved for a clear "flag"), three (3) bits - reserved
  variable length - file name string (0 - 255)
  variable length - hover text string (0 - 255)

variable length - sixteen (16) byte alignment (0 - 15)

// one (1) byte - tile color palette length (0 - 255)
// one (1) byte - icon color palette length (0 - 255)

two hundred fifty-six (256) bytes - tile color palette

//sixteen (16) bytes - icon color palette (maybe use the last/first? colors of the tile color palette for this too)

sixteen (16) bytes - magic text ("wawa1474DragDraw")

*/

//--------------------------------------------------------------------------------------------------------------

/*
format D:

two (2) bytes - file version (0 - 65535)
two (2) bytes - header length (0 - 65535)

one (1) byte - tile map name length (0 - 255)
one (1) byte - tile map location length (0 - 255)

// four (4) bytes - number of tiles (0 - 2,147,483,647) (would theoretically be twice this but its held in an int)
// four (4) bytes - number of icons (0 - 2,147,483,647) (would theoretically be twice this but its held in an int)
two (2) bytes + one (1) bit - number of tiles (0 - ‭131071‬) (two tiles for every space)
one (1) byte + seven (7) bits - number of icons (0 - ‭32767‬‬) (one icon for every other space)

variable length - tile map name string (0 - 255)
variable length - tile map location length (0 - 255)

variable length - sixteen (16) byte alignment (0 - 15)

variable length - four (4) bytes per tile
  one (1) byte - x position (0 - 255)
  one (1) byte - y position (0 - 255)
  one (1) byte - image (0 - 255)
  six (6) bits - color palette (1 - 63, 0 is reserved for a clear "flag"), two (2) bits - image rotation (90 degree increments)
  // three (3) bytes - reserved

variable length - sixteen (16) byte alignment (0 - 15)

variable length - five (5) bytes per icon plus variable length file name and hover text
  one (1) byte - x position (0 - 255)
  one (1) byte - y position (0 - 255)
  one (1) byte - file name length (0 - 255)
  one (1) byte - hover text length (0 - 255)
  six (6) bits - color palette (1 - 63, 0 is reserved for a clear "flag"), two (2) bits - reserved
  variable length - file name string (0 - 255)
  variable length - hover text string (0 - 255)

variable length - sixteen (16) byte alignment (0 - 15)

// one (1) byte - tile color palette length (0 - 255)
// one (1) byte - icon color palette length (0 - 255)

sixty-four (64) bytes - tile color palette

// sixteen (16) bytes - icon color palette (maybe use the last/first? colors of the tile color palette for this too)

sixteen (16) bytes - magic text ("wawa1474DragDraw")

*/