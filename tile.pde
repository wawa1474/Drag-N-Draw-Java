int tileBorderNumber = 0;//What number in img[] is the border (its just a null tile)

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
    if(!this.clear || this.image == colorTile){//Is the tile colored
      fill(this.r,this.g,this.b);//Set Tile background color
      rect(x,y + (-2 * scl),scl,scl);//Draw colored square behind tile
    }
    
    if(this.image != colorTile && this.image <= totalImages){//if tile image is not 0 and tile image exists
      image(img[this.image], x, y + (-2 * scl));//Draw tile
    }else if(this.image != 0){//image is not blank
      image(missingTexture, x, y + (-2 * scl));//Draw tile
    }
  }
}//class mTile() END

//---------------------------------------------------------------------------------------------------------------------------------------

boolean tileOnScreen(float x, float y){//is this tile on screen
  if(x > 0 + (screenX * scl) && x < width + (screenX * scl) && y > 0 + (screenY * scl) && y < height - (screenY * scl)){//is the tile within the screen bounds
    return true;//yes
  }
  return false;//no
}

//---------------------------------------------------------------------------------------------------------------------------------------

void deleteTile(int x, int y){//Delete a tile and update the array
  if(mapTiles.get(x).get(y).size() > 0){//if there are tiles
    mapTiles.get(x).get(y).remove(mapTiles.get(x).get(y).size() - 1);//delete the top most one
  }
}//void deleteTile() END

//---------------------------------------------------------------------------------------------------------------------------------------

void placeTile(){//Place a tile at the mouses location
  //print(mouseButton);
  if(mouseTileY > UIBottom + screenX){//We're not on the UI and we're within the screen bounds
    if(mouseButton == CENTER && !deleting){//We're dragging with the middle button and not deleting
      mapTiles.get(mouseTileX).get(mouseTileY).add(new mTile(tileBorderNumber,(int)RSlider.getValue(),(int)GSlider.getValue(),(int)BSlider.getValue(), false));//Place a colored tile with no image
      //println("test3");
    }else if(mouseButton == LEFT){//We're dragging with the left button
      //print(mouseButton);
      mapTiles.get(mouseTileX).get(mouseTileY).add(new mTile(tileN,(int)RSlider.getValue(),(int)GSlider.getValue(),(int)BSlider.getValue(), CClear));//Place a tile
      //println("test4");
    }else if(mouseButton == RIGHT){//We clicked with the right button
      //mapTiles[mapTiles.length] = new mTile(Math.floor(mX/scl)*scl,Math.floor(mY/scl)*scl,tileN,RSlider.value(),GSlider.value(),BSlider.value(), CClear);//Place a tile
    }
  }
  resetLHXY();//reset the lower/higher xy for background drawing
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

void updateLHXY(int x, int y){//update the lower/higher xy for background drawing
  if(x < lowerx){//make sure we have the lowest x
    lowerx = x;
  }
  if(y < lowery){//make sure we have the lowest y
    lowery = y;
  }
  if(x > upperx){//make sure we have the highest x
    upperx = x;
  }
  if(y > uppery){//make sure we have the highest y
    uppery = y;
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
          updateLHXY(x * scl, y * scl);//make sure we're fully up to date
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
  return(tX == x && tY == y && mapTiles.get(x).get(y).size() != 0);//Are we on the tile
}//boolean isCursorOnTileXY(int tile, int tX, int tY) END

//---------------------------------------------------------------------------------------------------------------------------------------

void dragTile(){//If dragging a tile: update location
  if (dragging){//Are we dragging a tile
    if(tmpTile != null){//If tile exists
      tmpTile.draw((mouseTileX) * scl, (mouseTileY * scl) - (-2 * scl));//draw the tile on the mouse
    }
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------

boolean checkImage(int tile){//check if tile about to place has same image as tile mouse is on
  //for(int i = 0; i < mapTiles.size(); i++){//Go through all tiles
  //for(int x = 0; x < mapTiles.size(); x++){//loop through all columns
  //  for(int y = 0; y < mapTiles.get(x).size(); y++){//loop through rows
  for(int x = screenBoundsX1; x < screenBoundsX2 + 1; x++){//loop through all columns
    for(int y = screenBoundsY1; y < screenBoundsY2 + 1; y++){//loop through rows
      for(int z = mapTiles.get(x).get(y).size() - 1; z >= 0; z--){
        if(isCursorOnTile(x, y, mouseTileX, mouseTileY)){//Is the mouse cursor on the tile we're checking?
          if(tile == mapTiles.get(x).get(y).get(z).image){//Is the tile image we're on the same as the one we're trying to place?
            return false;//Don't place tile
          }
        }
      }
    }
  }
  return true;//Place tile
}//boolean checkImage(int tile) END