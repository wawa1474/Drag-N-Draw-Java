int mapN = 0;//Which map peice are we messing with
int tileBorderNumber = 0;//What number in img[] is the border (its just a null tile)

int scl = 32;//Square Scale

ArrayList<mTile> mapTiles = new ArrayList<mTile>(0);


class mTile{//Tile Object
  int x, y;//Store XY Position
  int image;//Store Image Number
  int r, g, b;//Store RGB Value
  boolean clear;//Is the tile clear

  public mTile(int x, int y, int image, int r, int g, int b, boolean clear){//Tile Object
    this.x = x;//Store X Position
    this.y = y;//Store Y Position
    this.image = image;//Store Image Number
    this.r = r;//Store Red Value
    this.g = g;//Store Green Value
    this.b = b;//Store Blue Value
    this.clear = clear;//Is the tile clear
    //this.lore = lore || 0;//The LORE? of the tile
  }//public mTile(int x, int y, int image, int r, int g, int b, boolean clear) END
  
  void draw(){
    if(!this.clear || this.image == colorTile){//Is the tile colored
      fill(this.r,this.g,this.b);//Set Tile background color
      rect(this.x,this.y,scl,scl);//Draw colored square behind tile
    }
    
    if(this.image != colorTile && this.image <= totalImages){//if tile image is not 0 and tile image exists
      image(img[this.image], this.x, this.y);//Draw tile
    }else if(this.image != 0){//image is not blank
      image(missingTexture, this.x, this.y);//Draw tile
    }
  }
  
  boolean tileOnScreen(){//is this tile on screen
    if(this.x > -scl - SX && this.x  < width - SX && this.y > -scl - SY && this.y < height - SY){//is the tile within the screen bounds
      return true;//yes
    }
    return false;//no
  }
  
  void updateLocation(){//Adjust XY location of tile
    this.x = mX + offsetX;//Adjust X location of tile
    this.y = mY + offsetY;//Adjust Y location of tile
  }//void updateTileLocation(int tile) END
  
  void snapLocation(){//Snap XY location of tile to grid
    this.x = floor(mouseX / scl) * scl - SX;//Adjust X location of tile
    this.y = floor(mouseY / scl) * scl - SY;//Adjust Y location of tile
    updateLHXY(this.x, this.y);//update the lower/higher xy for background drawing
  }//void snapTileLocation(int tile) END
}//class mTile() END

//---------------------------------------------------------------------------------------------------------------------------------------

void updateXY(){//Update the XY position of the mouse and the page XY offset
  mX = mouseX - SX;//Update the X position of the mouse
  mY = mouseY - SY;//Update the Y position of the mouse
  //SX = window.pageXOffset;//Update the page X offset
  //SY = window.pageYOffset;//Update the page Y offset
}//void updateXY() END

//---------------------------------------------------------------------------------------------------------------------------------------

void deleteTile(int tile){//Delete a tile and update the array
  if(mapTiles.size() > 0){//if there are tiles
    mapTiles.remove(tile);//delete the specified tile
  }
  //-2,147,483,648 -> 2,147,483,647
  //resetLHXY();//reset the lower/higher xy for background drawing
}//void deleteTile() END

//---------------------------------------------------------------------------------------------------------------------------------------

void placeTile(){//Place a tile at the mouses location
  //print(mouseButton);
  if(mY > scl*UIBottom - SY + fV && mY < (height - (scl*1.5)) - SY + fV && mX < (width - (scl)) - SX + fV){//We're not on the UI and we're within the screen bounds
    if(mouseButton == CENTER && !deleting){//We're dragging with the middle button and not deleting
      mapTiles.add(new mTile(floor(mX/scl)*scl,floor(mY/scl)*scl,tileBorderNumber,(int)RSlider.getValue(),(int)GSlider.getValue(),(int)BSlider.getValue(), false));//Place a colored tile with no image
    }else if(mouseButton == LEFT){//We're dragging with the left button
      //print(mouseButton);
      mapTiles.add(new mTile(floor(mX/scl)*scl,floor(mY/scl)*scl,tileN,(int)RSlider.getValue(),(int)GSlider.getValue(),(int)BSlider.getValue(), CClear));//Place a tile
    }else if(mouseButton == RIGHT){//We clicked with the right button
      //mapTiles[mapTiles.length] = new mTile(Math.floor(mX/scl)*scl,Math.floor(mY/scl)*scl,tileN,RSlider.value(),GSlider.value(),BSlider.value(), CClear);//Place a tile
    }
  }
  updateLHXY(mapTiles.size() - 1);//update the lower/higher xy for background drawing
}//void placeTile() END

//---------------------------------------------------------------------------------------------------------------------------------------

void clearMapTilesArray(){//delete all tiles
  mapTiles.clear();//delete all tiles
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

void updateLHXY(int tile){//update the lower/higher xy for background drawing
  if(tile == -1){//if the tile doesn't exist
    return;//do nothing
  }
  mTile tmp = mapTiles.get(tile);
  if(tmp.x < lowerx){//make sure we have the lowest x
    lowerx = tmp.x;
  }
  if(tmp.y < lowery){//make sure we have the lowest y
    lowery = tmp.y;
  }
  if(tmp.x > upperx){//make sure we have the highest x
    upperx = tmp.x;
  }
  if(tmp.y > uppery){//make sure we have the highest y
    uppery = tmp.y;
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------

void resetLHXY(){//reset the lower/higher xy for background drawing
  lowerx = 2147483647;//tiles will always be less than this
  lowery = 2147483647;//tiles will always be less than this
  upperx = -2147483648;//tiles will always be greater than this
  uppery = -2147483648;//tiles will always be greater than this
  for(mTile tile : mapTiles){//go through all tiles
    updateLHXY(tile.x, tile.y);//and make sure we're fully up to date
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------

void loadTile(int tile){//Set current image to tile image
  tileN = mapTiles.get(tile).image;//Set current image to tile image
}//void loadTile() END

//---------------------------------------------------------------------------------------------------------------------------------------

void updateOffset(int tile){//Update mouse XY offset relative to upper-left corner of tile
  mTile tmp = mapTiles.get(tile);
  offsetX = tmp.x - mX;//keep track of relative X location of click to corner of rectangle
  offsetY = tmp.y - mY;//keep track of relative Y location of click to corner of rectangle
}//void updateOffset() END

//---------------------------------------------------------------------------------------------------------------------------------------

boolean isCursorOnTile(int tile){//Is the mouse cursor on the tile we're checking?
  mTile tmp = mapTiles.get(tile);
  return(mX > tmp.x - fV && mX < tmp.x + scl + fV && mY > tmp.y - fV && mY < tmp.y + scl + fV);//Are we clicking on the tile
}//boolean isCursorOnTile(int tile) END

//---------------------------------------------------------------------------------------------------------------------------------------

boolean isCursorOnTileXY(int tile, int tX, int tY){//Is the mouse cursor on the tile we're checking?
  mTile tmp = mapTiles.get(tile);
  return(tX > tmp.x - fV && tX < tmp.x + scl + fV && tY > tmp.y - fV && tY < tmp.y + scl + fV);//Are we clicking on the tile
}//boolean isCursorOnTileXY(int tile, int tX, int tY) END

//---------------------------------------------------------------------------------------------------------------------------------------

boolean isCursorOnTileNoFV(int tile){//Is the mouse cursor on the tile we're checking?
  mTile tmp = mapTiles.get(tile);
  return(mX > tmp.x && mX < tmp.x + scl && mY > tmp.y && mY < tmp.y + scl);//Are we clicking on the tile
}//boolean isCursorOnTileNoFV(int tile) END

//---------------------------------------------------------------------------------------------------------------------------------------

boolean isCursorOnTileNoFVXY(int tile, int tX, int tY){//Is the mouse cursor on the tile we're checking?
  mTile tmp = mapTiles.get(tile);
  return(tX > tmp.x && tX < tmp.x + scl && tY > tmp.y && tY < tmp.y + scl);//Are we clicking on the tile
}//boolean isCursorOnTileNoFVXY(int tile, int tX, int tY) END

//---------------------------------------------------------------------------------------------------------------------------------------

void dragTile(){//If dragging a tile: update location
  if (dragging){//Are we dragging a tile
    if(mapTiles.get(mapN) != null){//If tile exists
      mapTiles.get(mapN).updateLocation();//Adjust XY location of tile
    }
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------

boolean checkImage(int tile){//check if tile about to place has same image as tile mouse is on
  for(int i = 0; i < mapTiles.size(); i++){//Go through all tiles
    if(isCursorOnTile(i)){//Is the mouse cursor on the tile we're checking?
      if(tile == mapTiles.get(i).image){//Is the tile image we're on the same as the one we're trying to place?
        return false;//Don't place tile
      }
    }
  }
  //console.log("True");
  return true;//Place tile
}//boolean checkImage(int tile) END

//---------------------------------------------------------------------------------------------------------------------------------------

boolean checkImageXY(int tile, int x, int y){//check if tile about to place has same image as tile mouse is on
  for(int i = 0; i < mapTiles.size(); i++){//Go through all tiles
    if(isCursorOnTileXY(i, x, y)){//Is XY on the tile we're checking?
      if(tile == mapTiles.get(i).image){//Is the tile image we're on the same as the one we're trying to place?
        return false;//Don't place tile
      }
    }
  }
  //console.log("True");
  return true;//Place tile
}//boolean checkImageXY(int tile, int x, int y) END