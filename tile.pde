int mapN = 0;//Which map peice are we messing with
int tileBorderNumber = 0;//What number in img[] is the border (its just a null tile)

int scl = 32;//Square Scale

ArrayList<ArrayList<ArrayList<mTile>>> mapTiles = new ArrayList<ArrayList<ArrayList<mTile>>>(0);
mTile tmpTile;
int tmpTileX = 0;
int tmpTileY = 0;


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
      rect(x,y,scl,scl);//Draw colored square behind tile
    }
    
    if(this.image != colorTile && this.image <= totalImages){//if tile image is not 0 and tile image exists
      image(img[this.image], x, y);//Draw tile
    }else if(this.image != 0){//image is not blank
      image(missingTexture, x, y);//Draw tile
    }
  }
  
  boolean tileOnScreen(int x, int y){//is this tile on screen
    if(x > -scl - SX && x  < width - SX && y > -scl - SY && y < height - SY){//is the tile within the screen bounds
      return true;//yes
    }
    return false;//no
  }
  
  //void snapLocation(){//Snap XY location of tile to grid
  //  this.x = floor(mouseX / scl) * scl - SX;//Adjust X location of tile
  //  this.y = floor(mouseY / scl) * scl - SY;//Adjust Y location of tile
  //  updateLHXY(this.x, this.y);//update the lower/higher xy for background drawing
  //}//void snapTileLocation(int tile) END
}//class mTile() END

//---------------------------------------------------------------------------------------------------------------------------------------

void updateXY(){//Update the XY position of the mouse and the page XY offset
  mX = mouseX - SX;//Update the X position of the mouse
  mY = mouseY - SY;//Update the Y position of the mouse
  //SX = window.pageXOffset;//Update the page X offset
  //SY = window.pageYOffset;//Update the page Y offset
}//void updateXY() END

//---------------------------------------------------------------------------------------------------------------------------------------

void deleteTile(int x, int y){//Delete a tile and update the array
  if(mapTiles.get(x).get(y).size() > 0){//if there are tiles
    //mapTiles.get(x).get(y).remove(0);//mapTiles.get(x).get(y).size());//delete the specified tile
    mapTiles.get(x).get(y).remove(mapTiles.get(x).get(y).size() - 1);
  }
  //-2,147,483,648 -> 2,147,483,647
  //resetLHXY();//reset the lower/higher xy for background drawing
}//void deleteTile() END

//---------------------------------------------------------------------------------------------------------------------------------------

void placeTile(){//Place a tile at the mouses location
  //print(mouseButton);
  if(mY > scl*UIBottom - SY + fV && mY < (height - (scl*1.5)) - SY + fV && mX < (width - (scl)) - SX + fV){//We're not on the UI and we're within the screen bounds
    if(mouseButton == CENTER && !deleting){//We're dragging with the middle button and not deleting
      mapTiles.get(floor(mX/scl)).get(floor(mY/scl)).add(new mTile(tileBorderNumber,(int)RSlider.getValue(),(int)GSlider.getValue(),(int)BSlider.getValue(), false));//Place a colored tile with no image
      //println("test3");
    }else if(mouseButton == LEFT){//We're dragging with the left button
      //print(mouseButton);
      mapTiles.get(floor(mX/scl)).get(floor(mY/scl)).add(new mTile(tileN,(int)RSlider.getValue(),(int)GSlider.getValue(),(int)BSlider.getValue(), CClear));//Place a tile
      //println("test4");
    }else if(mouseButton == RIGHT){//We clicked with the right button
      //mapTiles[mapTiles.length] = new mTile(Math.floor(mX/scl)*scl,Math.floor(mY/scl)*scl,tileN,RSlider.value(),GSlider.value(),BSlider.value(), CClear);//Place a tile
    }
  }
  //updateLHXY(mapTiles.size() - 1);//update the lower/higher xy for background drawing
  resetLHXY();
}//void placeTile() END

//---------------------------------------------------------------------------------------------------------------------------------------

void clearMapTilesArray(){//delete all tiles
  mapTiles.clear();//delete all tiles
  for(int x = 0; x < 256; x++){
    mapTiles.add(new ArrayList<ArrayList<mTile>>());
    for(int y = 0; y < 256; y++){
      mapTiles.get(x).add(new ArrayList<mTile>());
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

//void updateLHXY(int tile){//update the lower/higher xy for background drawing
//  if(tile == -1){//if the tile doesn't exist
//    return;//do nothing
//  }
//  mTile tmp = mapTiles.get(tile);
//  if(tmp.x < lowerx){//make sure we have the lowest x
//    lowerx = tmp.x;
//  }
//  if(tmp.y < lowery){//make sure we have the lowest y
//    lowery = tmp.y;
//  }
//  if(tmp.x > upperx){//make sure we have the highest x
//    upperx = tmp.x;
//  }
//  if(tmp.y > uppery){//make sure we have the highest y
//    uppery = tmp.y;
//  }
//}

//---------------------------------------------------------------------------------------------------------------------------------------

void resetLHXY(){//reset the lower/higher xy for background drawing
  lowerx = 2147483647;//tiles will always be less than this
  lowery = 2147483647;//tiles will always be less than this
  upperx = -2147483648;//tiles will always be greater than this
  uppery = -2147483648;//tiles will always be greater than this
  //for(mTile tile : mapTiles){//go through all tiles
  for(int x = 0; x < mapTiles.size(); x++){
    for(int y = 0; y < mapTiles.get(x).size(); y++){
      if(mapTiles.get(x).get(y).size() != 0){
        if(mapTiles.get(x).get(y).get(mapTiles.get(x).get(y).size() - 1) != null){
          updateLHXY(x * scl, y * scl);//and make sure we're fully up to date
        }
      }
    }
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------

void loadTile(int x, int y, int z){//Set current image to tile image
  if(mapTiles.get(x).get(y).size() != 0){
    tileN = mapTiles.get(x).get(y).get(z).image;//Set current image to tile image
  }
}//void loadTile() END

void loadTile(mTile tmp){//Set current image to tile image
  if(tmp != null){
    tileN = tmp.image;//Set current image to tile image
  }
}//void loadTile() END

//---------------------------------------------------------------------------------------------------------------------------------------

boolean isCursorOnTile(int x, int y){//Is the mouse cursor on the tile we're checking?
  int tmpX = x * scl;
  int tmpY = y * scl;
  return(mX > tmpX - fV && mX < tmpX + scl + fV && mY > tmpY - fV && mY < tmpY + scl + fV && mapTiles.get(x).get(y).size() != 0);//Are we clicking on the tile
  //if(mapTiles.get(x).get(y).size() != 0){
  //  return true;
  //}
  //return false;
}//boolean isCursorOnTile(int tile) END

//---------------------------------------------------------------------------------------------------------------------------------------

boolean isCursorOnTileXY(int x, int y, int tX, int tY){//Is the mouse cursor on the tile we're checking?
  int tmpX = x * scl;
  int tmpY = y * scl;
  return(tX > tmpX - fV && tX < tmpX + scl + fV && tY > tmpY - fV && tY < tmpY + scl + fV);//Are we clicking on the tile
}//boolean isCursorOnTileXY(int tile, int tX, int tY) END

//---------------------------------------------------------------------------------------------------------------------------------------

boolean isCursorOnTileNoFV(int x, int y){//Is the mouse cursor on the tile we're checking?
  int tmpX = x * scl;
  int tmpY = y * scl;
  return(mX > tmpX && mX < tmpX + scl && mY > tmpY && mY < tmpY + scl);//Are we clicking on the tile
}//boolean isCursorOnTileNoFV(int tile) END

//---------------------------------------------------------------------------------------------------------------------------------------

boolean isCursorOnTileNoFVXY(int x, int y, int tX, int tY){//Is the mouse cursor on the tile we're checking?
  int tmpX = x * scl;
  int tmpY = y * scl;
  return(tX > tmpX && tX < tmpX + scl && tY > tmpY && tY < tmpY + scl);//Are we clicking on the tile
}//boolean isCursorOnTileNoFVXY(int tile, int tX, int tY) END

//---------------------------------------------------------------------------------------------------------------------------------------

void dragTile(){//If dragging a tile: update location
  if (dragging){//Are we dragging a tile
    if(tmpTile != null){//If tile exists
      //updateLocation();//Adjust XY location of tile
      tmpTile.draw(mX - (scl / 2), mY - (scl / 2));// - (scl / 2)
    }
  }
}

//void updateLocation(){//Adjust XY location of tile
//  tmpTileX = mX;// + offsetX;//Adjust X location of tile
//  tmpTileY = mY;// + offsetY;//Adjust Y location of tile
//}//void updateTileLocation(int tile) END

//void updateOffset(){//Update mouse XY offset relative to upper-left corner of tile
//  offsetX = tmpTileX - mX;//keep track of relative X location of click to corner of rectangle
//  offsetY = tmpTileY - mY;//keep track of relative Y location of click to corner of rectangle
//}//void updateOffset() END

//---------------------------------------------------------------------------------------------------------------------------------------

boolean checkImage(int tile){//check if tile about to place has same image as tile mouse is on
  //for(int i = 0; i < mapTiles.size(); i++){//Go through all tiles
  for(int x = 0; x < mapTiles.size(); x++){
    for(int y = 0; y < mapTiles.get(x).size(); y++){
      for(int z = mapTiles.get(x).get(y).size() - 1; z >= 0; z--){
        if(isCursorOnTile(x, y)){//Is the mouse cursor on the tile we're checking?
          if(mapTiles.get(x).get(y).get(z) != null){
            if(tile == mapTiles.get(x).get(y).get(z).image){//Is the tile image we're on the same as the one we're trying to place?
              return false;//Don't place tile
            }
          }
        }
      }
    }
  }
  //console.log("True");
  return true;//Place tile
}//boolean checkImage(int tile) END

//---------------------------------------------------------------------------------------------------------------------------------------

//boolean checkImageXY(int tile, int x, int y){//check if tile about to place has same image as tile mouse is on
//  for(int i = 0; i < mapTiles.size(); i++){//Go through all tiles
//    if(isCursorOnTileXY(i, x, y)){//Is XY on the tile we're checking?
//      if(tile == mapTiles.get(i).image){//Is the tile image we're on the same as the one we're trying to place?
//        return false;//Don't place tile
//      }
//    }
//  }
//  //console.log("True");
//  return true;//Place tile
//}//boolean checkImageXY(int tile, int x, int y) END