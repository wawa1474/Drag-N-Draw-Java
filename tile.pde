final int scl = 32;//Square Scale

ArrayList<ArrayList<ArrayList<mTile>>> mapTiles = new ArrayList<ArrayList<ArrayList<mTile>>>(0);//the hellish 3 dimensional ArrayList of tiles

mTile tmpTile;//the temporary tile we're dragging
int tmpTileX = 0;//its x position
int tmpTileY = 0;//its y position


class mTile{//Tile Object
  int image;//Store Image Number
  int r, g, b;//Store RGB Value
  boolean colored;//does the tile have a background color

  public mTile(int image, int r, int g, int b, boolean colored){//Tile Object
    this.image = image;//Store Image Number
    this.r = r;//Store Red Value
    this.g = g;//Store Green Value
    this.b = b;//Store Blue Value
    this.colored = colored;//Is the tile clear
    //this.lore = lore || 0;//The LORE? of the tile
  }//public mTile(int x, int y, int image, int r, int g, int b, boolean clear) END
  
  void draw(int x, int y){
    if(this.colored || this.image == tileMaps.get(tileMapShow).colorTile){//Is the tile colored
      if(!drawLines){noStroke();}else{strokeWeight(1); stroke(BLACK);}
      fill(this.r,this.g,this.b);//Set Tile background color
      rect(x,y,scl,scl);//Draw colored square behind tile
    }
    
    if(tileMaps.size() != 0 && this.image != tileMaps.get(tileMapShow).colorTile){
      if(this.image <= totalImages && tileImages.length != 0 && tileImages[this.image] != null){//if tile image is not 0 and tile image exists
        image(tileImages[this.image], x, y);//Draw tile
      }else if(missingTexture != null && !this.colored){//image is not blank
        image(missingTexture, x, y);//Draw tile
      }
    }
  }
}//class mTile() END

//---------------------------------------------------------------------------------------------------------------------------------------

boolean tileOnScreen(float x, float y){//is this tile on screen
  if(x > -scl - screenX && x  < width - screenX && y > -scl - screenY && y < height - screenY){//is the tile within the screen bounds
    return true;//yes
  }
  return false;//no
}

//---------------------------------------------------------------------------------------------------------------------------------------

void deleteTile(int x, int y, int z){//Delete a tile and update the array
  if(mapTiles.get(x).get(y).size() > 0){//if there are tiles
    mapTiles.get(x).get(y).remove(z);//delete the top most one
  }
}//void deleteTile() END

//---------------------------------------------------------------------------------------------------------------------------------------

void placeTile(){//Place a tile at the mouses location
  if(mouseY > (UIBottom * scl) + fudgeValue && mouseY < height - fudgeValue && mouseX < width - fudgeValue && mouseX > 0 + fudgeValue && checkBounds(mouseTileX, mouseTileY)){//We're not on the UI and we're within the screen bounds
    if(mouseButton == CENTER && !deleting){//We're dragging with the middle button and not deleting
      //.get(x).get(y).add(new mTile(color tile, red, green, blue, tile is clear));
      mapTiles.get(mouseTileX).get(mouseTileY).add(new mTile(tileMaps.get(tileMapShow).colorTile,(int)RSlider.getValue(),(int)GSlider.getValue(),(int)BSlider.getValue(), false));//Place a colored tile with no image
    }else if(mouseButton == LEFT){//We're dragging with the left button
      //.get(x).get(y).add(new mTile(selected tile image number, red, green, blue, is tile clear?));
      mapTiles.get(mouseTileX).get(mouseTileY).add(new mTile(tileN,(int)RSlider.getValue(),(int)GSlider.getValue(),(int)BSlider.getValue(), colorTiles));//Place a tile
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

boolean checkImage(int tile){//check if tile about to place has same image as tile mouse is on
  for(int x = screenX1; x < screenX2 + 1; x++){//loop through all columns
    for(int y = screenY1; y < screenY2 + 1; y++){//loop through rows
      if(checkBounds(x, y)){
        for(int z = mapTiles.get(x).get(y).size() - 1; z >= 0; z--){
          if(x == mouseTileX && y == mouseTileY){//Is the mouse cursor on the tile we're checking?
            if(tile == mapTiles.get(x).get(y).get(z).image){//Is the tile image we're on the same as the one we're trying to place?
              return false;//Don't place tile
            }
          }
        }
      }
    }
  }
  //for(int z = mapTiles.get(mouseTileY).get(mouseTileY).size() - 1; z >= 0; z--){
  //  if(tile == mapTiles.get(mouseTileY).get(mouseTileY).get(z).image){//Is the tile image we're on the same as the one we're trying to place?
  //    return false;//Don't place tile
  //  }
  //}
  return true;//Place tile
}//boolean checkImage(int tile) END