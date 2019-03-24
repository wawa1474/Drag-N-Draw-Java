int cols = 8;//Columns
int rows = 8;//Rows

int tileDepth = 16;//16;//how many tiles are drawn per space
int screenX1, screenX2, screenY1, screenY2;//0 -> cols/rows
int drawnTiles = 0;//how many tiles are on the screen

void drawTilesAndIcons(){
  drawnTiles = 0;//reset number of drawn tiles
  //Display Map Tiles
  for(int x = screenX1; x < screenX2 + 1; x++){//loop through all columns
    for(int y = screenY1; y < screenY2 + 1; y++){//loop through rows
      boolean skip = false;//do we skip drawing the rest of the tiles in this spot?
      if(checkBounds(x, y)){
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

  //draw any icons on the screen
  for(int i = 0; i < icons.size(); i++){//Go through all the clickable icons
    clickableIcon tmp = icons.get(i);
    int tmpX = tmp.x / scl;
    int tmpY = tmp.y / scl;
    
    if(tmpX >= screenX1 && tmpX <= screenX2 && tmpY >= screenY1 && tmpY <= screenY2){
      tmp.draw();//draw the icon
      if(tmp.mouseOver()){//if mouse hovering over icon
        tmp.drawText();//draw the icons text
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
  
  if(screenX2 > rows){
    screenX2 = rows;
  }
  
  if(screenY2 > cols){
    screenY2 = cols;
  }

  //println(screenX1 + ", " + screenY1 + ", " + screenX2 + ", " + screenY2);
}

//---------------------------------------------------------------------------------------------------------------------------------------

boolean checkBounds(int x, int y){
  return !(x >= cols || y >= rows || x < 0 || y < 0);//true if within bounds
}