int scl = 32;//Square Scale

ArrayList<ArrayList<ArrayList<mTile>>> mapTiles = new ArrayList<ArrayList<ArrayList<mTile>>>(0);//the hellish 3 dimensional ArrayList of tiles

mTile tmpTile;//the temporary tile we're dragging
int tmpTileX = 0;//its x position
int tmpTileY = 0;//its y position


class mTile{//Tile Object
  int image;//Store Image Number
  int r, g, b;//Store RGB Value
  boolean clear;//Is the tile clear

  public mTile(int image, int r, int g, int b, boolean clear){//Tile Object
    this.image = image;//Store Image Number
    this.r = r;//Store Red Value
    this.g = g;//Store Green Value
    this.b = b;//Store Blue Value
    this.clear = clear;//Is the tile clear
    //this.lore = lore || 0;//The LORE? of the tile
  }//public mTile(int x, int y, int image, int r, int g, int b, boolean clear) END
  
  void draw(int x, int y){
    if(!this.clear || this.image == tileMaps.get(tileMapShow).colorTile){//Is the tile colored
      if(!drawLines){noStroke();}
      fill(this.r,this.g,this.b);//Set Tile background color
      rect(x,y,scl,scl);//Draw colored square behind tile
    }
    
    if(tileMaps.size() != 0 && this.image != tileMaps.get(tileMapShow).colorTile && this.image <= totalImages && tileImages.length != 0 && tileImages[this.image] != null){//if tile image is not 0 and tile image exists
      image(tileImages[this.image], x, y);//Draw tile
    }else if(this.image != 0 && missingTexture != null && !this.clear){//image is not blank
      image(missingTexture, x, y);//Draw tile
    }
  }
}//class mTile() END

//---------------------------------------------------------------------------------------------------------------------------------------

boolean tileOnScreen(float x, float y){//is this tile on screen
  if(x > -scl - SX && x  < width - SX && y > -scl - SY && y < height - SY){//is the tile within the screen bounds
    return true;//yes
  }
  return false;//no
}

//---------------------------------------------------------------------------------------------------------------------------------------

void updateMouseXY(){//Update the XY position of the mouse and the page XY offset
  mX = mouseX - SX;//Update the X position of the mouse
  mY = mouseY - SY;//Update the Y position of the mouse
}//void updateXY() END

//---------------------------------------------------------------------------------------------------------------------------------------

void deleteTile(int x, int y){//Delete a tile and update the array
  if(mapTiles.get(x).get(y).size() > 0){//if there are tiles
    mapTiles.get(x).get(y).remove(mapTiles.get(x).get(y).size() - 1);//delete the top most one
  }
}//void deleteTile() END

//---------------------------------------------------------------------------------------------------------------------------------------

void placeTile(){//Place a tile at the mouses location
  if(mY > scl*UIBottom - SY + fV && mY < (height - (scl*1.5)) - SY + fV && mX < (width - (scl)) - SX + fV && mX >= 0){//We're not on the UI and we're within the screen bounds
    if(mouseButton == CENTER && !deleting){//We're dragging with the middle button and not deleting
      //.get(x).get(y).add(new mTile(color tile, red, green, blue, tile is clear));
      mapTiles.get(floor(mX/scl)).get(floor(mY/scl)).add(new mTile(tileMaps.get(tileMapShow).colorTile,(int)RSlider.getValue(),(int)GSlider.getValue(),(int)BSlider.getValue(), true));//Place a colored tile with no image
    }else if(mouseButton == LEFT){//We're dragging with the left button
      //.get(x).get(y).add(new mTile(selected tile image number, red, green, blue, is tile clear?));
      mapTiles.get(floor(mX/scl)).get(floor(mY/scl)).add(new mTile(tileN,(int)RSlider.getValue(),(int)GSlider.getValue(),(int)BSlider.getValue(), CClear));//Place a tile
    }else if(mouseButton == RIGHT){//We clicked with the right button
      //do nothing
    }
  }
}//void placeTile() END

//---------------------------------------------------------------------------------------------------------------------------------------

void clearMapTilesArray(){//delete all tiles
  mapTiles.clear();//delete all tiles
  for(int x = 0; x < cols; x++){//and make as many columns as needed
    mapTiles.add(new ArrayList<ArrayList<mTile>>());//add a column
    for(int y = 0; y < rows; y++){//and make as many rows as needed
      mapTiles.get(x).add(new ArrayList<mTile>());//add a row
    }
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------

void resetLHXY(){//reset the lower/higher xy for background drawing
  lowerx = 2147483647;//tiles will always be less than this
  lowery = 2147483647;//tiles will always be less than this
  upperx = -2147483648;//tiles will always be greater than this
  uppery = -2147483648;//tiles will always be greater than this
  for(int x = 0; x < mapTiles.size(); x++){//got through all columns
    for(int y = 0; y < mapTiles.get(x).size(); y++){//go through all rows
      if(mapTiles.get(x).get(y).size() != 0){//if there are tiles in this spot
        if(mapTiles.get(x).get(y).get(mapTiles.get(x).get(y).size() - 1) != null){//and they're not null
          int tmpX = x * scl;
          int tmpY = y * scl;
          
          if(tmpX < lowerx){lowerx = tmpX;}//make sure we have the lowest x
          if(tmpY < lowery){lowery = tmpY;}//make sure we have the lowest y
          if(tmpX > upperx){upperx = tmpX;}//make sure we have the highest x
          if(tmpY > uppery){uppery = tmpY;}//make sure we have the highest y
        }
      }
    }
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------

void loadTile(int x, int y, int z){//Set current image to tile image
  if(mapTiles.get(x).get(y).size() != 0){//if there are tiles in this spot
    tileN = mapTiles.get(x).get(y).get(z).image;//Set current image to tile image
  }
}//void loadTile() END

void loadTile(mTile tmp){//Set current image to tile image
  if(tmp != null){
    tileN = tmp.image;//Set current image to tile image
    updateTileRow();//make sure we're on the right tile row
  }
}//void loadTile() END

//---------------------------------------------------------------------------------------------------------------------------------------

boolean isCursorOnTile(int x, int y, int tX, int tY){//Is tX,tY on the tile we're checking?
  int tmpX = x * scl;//x,y need to be multiplied for checking
  int tmpY = y * scl;
  return(tX > tmpX - fV && tX < tmpX + scl + fV && tY > tmpY - fV && tY < tmpY + scl + fV && mapTiles.get(x).get(y).size() != 0);//Are we on the tile
}//boolean isCursorOnTileXY(int tile, int tX, int tY) END

//---------------------------------------------------------------------------------------------------------------------------------------

void dragTile(){//If dragging a tile: update location
  if (dragging){//Are we dragging a tile
    if(tmpTile != null){//If tile exists
      if(mY < (UIBottom * scl) - SY){
        //do nothing
      }else{
        tmpTile.draw(floor(mX / scl) * scl, floor(mY / scl) * scl);//draw the tile on the mouse snapped to the grid
      }
    }
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------

boolean checkImage(int tile){//check if tile about to place has same image as tile mouse is on
  for(int x = screenX1; x < screenX2 + 1; x++){//loop through all columns
    for(int y = screenY1; y < screenY2 + 1; y++){//loop through rows
      for(int z = mapTiles.get(x).get(y).size() - 1; z >= 0; z--){
        if(isCursorOnTile(x, y, mX, mY)){//Is the mouse cursor on the tile we're checking?
          if(tile == mapTiles.get(x).get(y).get(z).image){//Is the tile image we're on the same as the one we're trying to place?
            return false;//Don't place tile
          }
        }
      }
    }
  }
  return true;//Place tile
}//boolean checkImage(int tile) END