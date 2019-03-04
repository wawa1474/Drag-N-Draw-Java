int tileDepth = 4;//16;//how many tiles are drawn per space

void drawSpots(){
  //Display Map Tiles
  for(int x = 0; x < mapTiles.size(); x++){//loop through all columns
    for(int y = 0; y < mapTiles.get(x).size(); y++){//loop through rows
      if(tileOnScreen(x * scl, y * scl) || drawAll == true){//if tile is within screen bounds or drawAll is set
        boolean skip = false;//do we skip drawing the rest of the tiles in this spot?
        for(int z = mapTiles.get(x).get(y).size() - tileDepth; z < mapTiles.get(x).get(y).size() && !skip; z++){//loop through all drawn tiles in this xy position
          if(z >= 0){//if there's a tile to be drawn
            mapTiles.get(x).get(y).get(z).draw(x * scl, y * scl);//draw it
            drawnTiles++;//how many tiles are being drawn?
            //if(!mapTiles.get(x).get(y).get(z).clear){
            //  skip = true;
            //}
          }
        }
      }
    }
  }
}