int tileDepth = 4;//16;//how many tiles are drawn per space
int screenBoundsX1, screenBoundsX2, screenBoundsY1, screenBoundsY2;//0 -> cols/rows

void drawSpots(){
  //Display Map Tiles
  for(int x = 0; x < mapTiles.size(); x++){//loop through all columns
    for(int y = 0; y < mapTiles.get(x).size(); y++){//loop through rows
  //for(int x = screenBoundsX1; x < screenBoundsX2 + 1; x++){//loop through all columns
  //  for(int y = screenBoundsY1; y < screenBoundsY2 + 1; y++){//loop through rows
      //if(tileOnScreen(x * scl, y * scl) || drawAll == true){//if tile is within screen bounds or drawAll is set
        boolean skip = false;//do we skip drawing the rest of the tiles in this spot?
        for(int z = mapTiles.get(x).get(y).size() - tileDepth; z < mapTiles.get(x).get(y).size() && !skip; z++){//loop through all drawn tiles in this xy position
          if(z >= 0){//if there's a tile to be drawn
            mapTiles.get(x).get(y).get(z).draw((x * scl) - (screenX * scl), (y * scl) - (screenY * scl));//draw it
            drawnTiles++;//how many tiles are being drawn?
            //if(!mapTiles.get(x).get(y).get(z).clear){//if there's a non-clear tile thats not at the bottom
            //  skip = true;//don't draw anything below it
            //}
          }
        }
      //}
    }
  }
}

void updateScreenBounds(){
  screenBoundsX1 = screenX;
  screenBoundsY1 = screenY;
  
  screenBoundsX2 = screenBoundsX1 + floor(width / scl);
  screenBoundsY2 = screenBoundsY1 + floor(height / scl);

  //println(screenX1 + ", " + screenY1 + ", " + screenX2 + ", " + screenY2);
}