int tileDepth = 4;//16;//how many tiles are drawn per space
int screenX1, screenX2, screenY1, screenY2;//0 -> cols/rows

void drawSpots(){
  //Display Map Tiles
  for(int x = screenX1; x < screenX2 + 1; x++){//loop through all columns
    for(int y = screenY1; y < screenY2 + 1; y++){//loop through rows
        boolean skip = false;//do we skip drawing the rest of the tiles in this spot?
        for(int z = mapTiles.get(x).get(y).size() - tileDepth; z < mapTiles.get(x).get(y).size() && !skip; z++){//loop through all drawn tiles in this xy position
          if(z >= 0){//if there's a tile to be drawn
            mapTiles.get(x).get(y).get(z).draw(x * scl, y * scl);//draw it
            drawnTiles++;//how many tiles are being drawn?
            //if(!mapTiles.get(x).get(y).get(z).clear){//if there's a non-clear tile thats not at the bottom
            //  skip = true;//don't draw anything below it
            //}
          }
        }
    }
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------

void updateScreenBounds(){
  screenX2 = floor(width - SX)/scl;
  screenY2 = floor(height - SY)/scl;

  screenX1 = screenX2 - floor(width / scl);
  screenY1 = (screenY2 - floor(height / scl)) + 2;

  //println(screenX1 + ", " + screenY1 + ", " + screenX2 + ", " + screenY2);
}