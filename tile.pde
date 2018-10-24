int mapN = 0;//Which map peice are we messing with
int tileBorderNumber = 0;//What number in img[] is the border (its just a null tile)

int scl = 32;//Square Scale

mTile[] mapTiles = new mTile[0];//Map Tiles Array


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
  if(mapTiles.length > 0){//if there are tiles
    if(mapTiles.length > 1){//If there is more than 1 tile
      for(int i = tile; i < mapTiles.length - 1; i++){//Go through all tiles after the one we're deleting
        mapTiles[i] = mapTiles[i + 1];//Shift the tile down 1
      }
    }
    mapTiles = (mTile[]) shorten(mapTiles);//Shorten the Map Tiles Array by 1
  }
}//void deleteTile() END

//---------------------------------------------------------------------------------------------------------------------------------------

void placeTile(){//Place a tile at the mouses location
  //print(mouseButton);
  if(mY > scl*UIBottom - SY + fV && mY < (height - (scl*1.5)) - SY + fV && mX < (width - (scl)) - SX + fV){//We're not on the UI and we're within the screen bounds
    if(mouseButton == CENTER && !deleting){//We're dragging with the middle button and not deleting
      mapTiles = (mTile[]) expand(mapTiles, mapTiles.length + 1);//make sure we have room
      mapTiles[mapTiles.length - 1] = new mTile(floor(mX/scl)*scl,floor(mY/scl)*scl,tileBorderNumber,(int)RSlider.getValue(),(int)GSlider.getValue(),(int)BSlider.getValue(), false);//Place a colored tile with no image
    }else if(mouseButton == LEFT){//We're dragging with the left button
      //print(mouseButton);
      mapTiles = (mTile[]) expand(mapTiles, mapTiles.length + 1);//make sure we have room
      mapTiles[mapTiles.length - 1] = new mTile(floor(mX/scl)*scl,floor(mY/scl)*scl,tileN,(int)RSlider.getValue(),(int)GSlider.getValue(),(int)BSlider.getValue(), CClear);//Place a tile
    }else if(mouseButton == RIGHT){//We clicked with the right button
      //mapTiles[mapTiles.length] = new mTile(Math.floor(mX/scl)*scl,Math.floor(mY/scl)*scl,tileN,RSlider.value(),GSlider.value(),BSlider.value(), CClear);//Place a tile
    }
  }
}//void placeTile() END

//---------------------------------------------------------------------------------------------------------------------------------------

void loadTile(int tile){//Set current image to tile image
  tileN = mapTiles[tile].image;//Set current image to tile image
}//void loadTile() END

//---------------------------------------------------------------------------------------------------------------------------------------

void updateOffset(int tile){//Update mouse XY offset relative to upper-left corner of tile
  offsetX = mapTiles[tile].x-mX;//keep track of relative X location of click to corner of rectangle
  offsetY = mapTiles[tile].y-mY;//keep track of relative Y location of click to corner of rectangle
}//void updateOffset() END

//---------------------------------------------------------------------------------------------------------------------------------------

boolean isCursorOnTile(int tile){//Is the mouse cursor on the tile we're checking?
  return(mX > mapTiles[tile].x - fV && mX < mapTiles[tile].x + scl + fV && mY > mapTiles[tile].y - fV && mY < mapTiles[tile].y + scl + fV);//Are we clicking on the tile
}//boolean isCursorOnTile(int tile) END

//---------------------------------------------------------------------------------------------------------------------------------------

boolean isCursorOnTileXY(int tile, int tX, int tY){//Is the mouse cursor on the tile we're checking?
  return(tX > mapTiles[tile].x - fV && tX < mapTiles[tile].x + scl + fV && tY > mapTiles[tile].y - fV && tY < mapTiles[tile].y + scl + fV);//Are we clicking on the tile
}//boolean isCursorOnTileXY(int tile, int tX, int tY) END

//---------------------------------------------------------------------------------------------------------------------------------------

boolean isCursorOnTileNoFV(int tile){//Is the mouse cursor on the tile we're checking?
  return(mX > mapTiles[tile].x && mX < mapTiles[tile].x + scl && mY > mapTiles[tile].y && mY < mapTiles[tile].y + scl);//Are we clicking on the tile
}//boolean isCursorOnTileNoFV(int tile) END

//---------------------------------------------------------------------------------------------------------------------------------------

boolean isCursorOnTileNoFVXY(int tile, int tX, int tY){//Is the mouse cursor on the tile we're checking?
  return(tX > mapTiles[tile].x && tX < mapTiles[tile].x + scl && tY > mapTiles[tile].y && tY < mapTiles[tile].y + scl);//Are we clicking on the tile
}//boolean isCursorOnTileNoFVXY(int tile, int tX, int tY) END

//---------------------------------------------------------------------------------------------------------------------------------------

void updateTileLocation(int tile){//Adjust XY location of tile
  mapTiles[tile].x = mX + offsetX;//Adjust X location of tile
  mapTiles[tile].y = mY + offsetY;//Adjust Y location of tile
}//void updateTileLocation(int tile) END

//---------------------------------------------------------------------------------------------------------------------------------------

void snapTileLocation(int tile){//Snap XY location of tile to grid
  mapTiles[tile].x = floor(mouseX / scl) * scl - SX;//Adjust X location of tile
  mapTiles[tile].y = floor(mouseY / scl) * scl - SY;//Adjust Y location of tile
}//void snapTileLocation(int tile) END

//---------------------------------------------------------------------------------------------------------------------------------------

boolean checkImage(int tile){//check if tile about to place has same image as tile mouse is on
  for(int i = mapTiles.length - 1; i >= 0; i--){//Go through all tiles
    if(isCursorOnTile(i)){//Is the mouse cursor on the tile we're checking?
      if(tile == mapTiles[i].image){//Is the tile image we're on the same as the one we're trying to place?
        //mylog.log("False", "Image", i, ", ", mapTiles[i].image, ", ", tile);
        return false;//Don't place tile
      }
    }
  }
  //console.log("True");
  return true;//Place tile
}//boolean checkImage(int tile) END

//---------------------------------------------------------------------------------------------------------------------------------------

boolean checkImageXY(int tile, int x, int y){//check if tile about to place has same image as tile mouse is on
  for(int i = mapTiles.length - 1; i >= 0; i--){//Go through all tiles
    if(isCursorOnTileXY(i, x, y)){//Is XY on the tile we're checking?
      if(tile == mapTiles[i].image){//Is the tile image we're on the same as the one we're trying to place?
        //mylog.log("False", "Image", i, ", ", mapTiles[i].image, ", ", tile);
        return false;//Don't place tile
      }
    }
  }
  //console.log("True");
  return true;//Place tile
}//boolean checkImageXY(int tile, int x, int y) END