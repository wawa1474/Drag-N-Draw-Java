/*
Make custom file format to decrease save file size

use a pallette based color system to compress color data?
  256 or 65536 color pallette

shave one bit off image number and use it to store clear flag
  means only 32768 images per map but that should be enough for anyone

for icons have a settable color (16 colors?)
  and maybe make it so there's no color border?

pack bytes into chars
xy and image number are seperate
red and green get packed together
blue and flags get packed togther
X Y I RG BF

pack bytes into chars
max 65536 images XD
256 max tiles in xy directions
red and green get packed together
blue and flags get packed togther
XY II RG BF

flags:
  clear

Try loading tile map based on name
if that fails try loading by location
if that fails throw error

File Version, Tile Map Name, Tile Map Location, Map Tiles Amount, Clickable Icons Amount
Map Tiles Array
Clickable Icons Array

File Version, Tile Map Location (File Name 22 character limit), Map Tiles Amount, Clickable Icons Amount
VV MM MM CC CC LL LL LL LL LL LL LL LL LL LL LL
*/