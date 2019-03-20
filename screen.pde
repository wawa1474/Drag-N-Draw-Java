int tileDepth = 4;//16;//how many tiles are drawn per space
int screenX1, screenX2, screenY1, screenY2;//0 -> cols/rows

void drawSpots(){
  drawnTiles = 0;//reset number of drawn tiles
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
  
  if (dragging){//Are we dragging a tile
    if(tmpTile != null){//If tile exists
      if(mouseY < UIBottom * scl){
        //do nothing
      }else{
        tmpTile.draw(mouseTileX * scl, mouseTileY * scl);//draw the tile on the mouse snapped to the grid
        drawnTiles++;//dragged tile on screen, count it
      }
    }
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------

void updateScreenBounds(){
  screenX2 = floor(width - screenX)/scl;
  screenY2 = floor(height - screenY)/scl;

  screenX1 = screenX2 - floor(width / scl);
  screenY1 = (screenY2 - floor(height / scl));

  //println(screenX1 + ", " + screenY1 + ", " + screenX2 + ", " + screenY2);
}