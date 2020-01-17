int cols = 256;//Columns
int rows = 127;//Rows

//final int tileDepth = 16;//16;//how many tiles are drawn per space
int screenX1, screenX2, screenY1, screenY2;//0 -> cols/rows
int drawnTiles = 0;//how many tiles are on the screen

void drawTilesAndIcons(){
  drawnTiles = 0;//reset number of drawn tiles
  //Display Map Tiles
  //for(int x = screenX1; x < screenX2 + 1; x++){//loop through all columns
  //  for(int y = screenY1; y < screenY2 + 1; y++){//loop through rows
  //    boolean skip = false;//do we skip drawing the rest of the tiles in this spot?
  //    int depth = 0;
  //    if(checkBounds(x, y)){
  //      //if(mapTiles != null){
  //        for(int i = mapTiles.get(x).get(y).size() - 1; i >= 0 && !skip; i--){
  //          if(mapTiles.get(x).get(y).get(i).colored){//if there's a non-clear tile thats not at the bottom
  //            depth = i;
  //            skip = true;//don't draw anything below it
  //          }
  //        }
  //        for(int z = depth/*mapTiles.get(x).get(y).size() - tileDepth*/; z < mapTiles.get(x).get(y).size(); z++){//loop through all drawn tiles in this xy position
  //          if(z >= 0){//if there's a tile to be drawn
  //            mapTiles.get(x).get(y).get(z).draw(x * scl, y * scl);//draw it
  //            drawnTiles++;//how many tiles are being drawn?
  //            //if(!mapTiles.get(x).get(y).get(z).clear){//if there's a non-clear tile thats not at the bottom
  //            //  skip = true;//don't draw anything below it
  //            //}
  //          }
  //        }
  //      //}
  //    }
  //  }
  //}
  drawTiles(mapTiles, screenX1, screenY1, screenX2 + 1, screenY2 + 1, 0, 0);

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
      if(mouseY < UIBottom/* * scl*/){
        //do nothing
      }else{
        tmpTile.draw(mouseTileX * scl, mouseTileY * scl);//draw the tile on the mouse snapped to the grid
        drawnTiles++;//dragged tile on screen, count it
      }
    }
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------

void drawTiles(ArrayList<ArrayList<ArrayList<mTile>>> tiles_, int x1_, int y1_, int x2_, int y2_, int offsetX_, int offsetY_){
  for(int x = x1_; x < x2_; x++){//loop through all columns
    for(int y = y1_; y < y2_; y++){//loop through rows
      if(x < tiles_.size() && y < tiles_.get(x).size()){
        ArrayList<mTile> tmp = tiles_.get(x).get(y);
        if(checkBounds(x, y)){
          if(tmp.size() != 0){
            boolean skip = false;//do we skip drawing the rest of the tiles in this spot?
            int depth = 0;
            for(int i = tmp.size() - 1; i >= 0 && !skip; i--){
              if(tmp.get(i).colored){//if there's a non-clear tile thats not at the bottom
                depth = i;
                skip = true;//don't draw anything below it
              }
            }
            for(int z = depth/*mapTiles.get(x).get(y).size() - tileDepth*/; z < tmp.size(); z++){//loop through all drawn tiles in this xy position
              if(z >= 0){//if there's a tile to be drawn
                tmp.get(z).draw((x * scl) + offsetX_, (y * scl) + offsetY_);//draw it
                drawnTiles++;//how many tiles are being drawn?
              }
            }
          }
        }
      }
    }
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------

void updateScreenBounds(){
  if (currentUI == _EDITORUI_ && (oldScreenW != width || oldScreenH != height)){//Sketch window has resized
    oldScreenW = width;
    oldScreenH = height;
    editor_colorTools_panel.setDragArea();
  }
  
  screenX2 = floor(width - screenX)/scl;
  screenY2 = floor(height - screenY)/scl;

  screenX1 = screenX2 - floor(width / scl);
  screenY1 = (screenY2 - floor(height / scl));
  
  if(screenX2 > cols){
    screenX2 = cols;
  }
  
  if(screenY2 > rows){
    screenY2 = rows;
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------

boolean checkBounds(int x_, int y_){
  return !(x_ >= cols || y_ >= rows || x_ < 0 || y_ < 0);//true if within bounds
}