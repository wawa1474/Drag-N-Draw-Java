/*
save and load character file for editing in player flayer and playing in role n' play

characters will consist of images
  mug shot for dialogue
  animations for moving, attacking, etc.

and data
  health
  stamina
  items
  etc.

character files will be zipped up to keep them as a single easily transported unit
and will be unzipped when in use


println(zipEntry.getName());//we can get the file name and location
*/

class character{
  int x, y;//position
  PImage mugShot;//dialogue photo
  PImage[] actions;//array of action sprites
  //tmp.copy(this.tileMapImage, x * scl, y * scl, this.tileWidth, this.tileHeight, 0, 0, this.tileWidth, this.tileHeight);//copy the tile at this xy position
  
  character(){
    
  }
}