int tileGroupStep = 0;//what step are we in setting tile group
boolean tileGroupDeleting = false;//are we deleting the tile group
int sx1, sy1, sx2, sy2;//tileGroup XY corners
int tileGroupCols = 0;//how many columns of copied tiles
int tileGroupRows = 0;//how many rows of copied tiles
int X1,X2,Y1,Y2;//Setup Variables

ArrayList<ArrayList<ArrayList<mTile>>> mapTilesCopy = new ArrayList<ArrayList<ArrayList<mTile>>>(0);//the hellish 3 dimensional ArrayList of tiles to copy, paste, or cut

void tileGroup(String button_){//mess with tiles in square group
  int XLines, YLines;//define number of XY lines
  boolean skip = false;
  
  setupXXYY(sx1, sx2, sy1, sy2);
  
  XLines = (X2 - X1);//how many x lines
  YLines = (Y2 - Y1);//how many y lines
  
  for(int i = 0; i < XLines; i++){//loop through all columns
    for(int j = 0; j < YLines; j++){//loop through all rows
      if(X1 + i < 0 || Y1 + j < 0){//if its a negetive number
        skip = true;//skip this space
      }
      
      if(button_ == "left" && !skip){//we clicked left button
        mapTiles.get(X1 + i).get(Y1 + j).add(new mTile(tileN, currentTileColor, colorTiles));//Place a tile
      }else if(button_ == "center" && tileGroupDeleting == true && !skip){//we clicked middle button on a tile
        for(int x = X1; x < X1 + XLines; x++){//go through the selected columns
          for(int y = Y1; y < Y1 + YLines; y++){//go through the selected rows
            if(x == X1 + i && y == Y1 + j){//Are we clicking on the tile
              mapTiles.get(x).get(y).clear();//delete all the tiles in this space
            }
          }
        }
      }else if(button_ == "center" && !skip){//we clicked middle button
        mapTiles.get(X1 + i).get(Y1 + j).add(new mTile(tileMaps.get(tileMapShow).colorTile, currentTileColor, true));//Place a tile
      }else if(button_ == "right" && !skip){//we clicked right button
        for(int x = X1; x < X1 + XLines; x++){//go through the selected columns
          for(int y = Y1; y < Y1 + YLines; y++){//go through the selected rows
            if(x == X1 + i && y == Y1 + j){//Are we clicking on the tile
              for(int z = 0; z < mapTiles.get(x).get(y).size(); z++){//go through all the tiles in this space
                mTile tmp = mapTiles.get(x).get(y).get(0);//grab the tile
                tmp.tileColor = currentTileColor;
                deleteTile(x, y, 0);//Delete a tile;//delete the old tile
                mapTiles.get(x).get(y).add(tmp);//and readd it
              }
            }
          }
        }
      }
      skip = false;//don't skip unless we need to
    }
  }
  tileGroupStep = 0;//reset step count
  tileGroupDeleting = false;//no longer deleting
}//void tileGroup(String button) END

//---------------------------------------------------------------------------------------------------------------------------------------

void tileGroupCutCopy(char button_){//mess with tiles in square group
  boolean hadTile = false;//did that square have a tile?
  
  setupXXYY(sx1, sx2, sy1, sy2);
  
  tileGroupCols = (X2 - X1);//how many x lines
  tileGroupRows = (Y2 - Y1);//how many y lines
  
  mapTilesCopy.clear();//delete all tiles
  for(int x = 0; x < tileGroupCols; x++){//and make as many columns as needed
    mapTilesCopy.add(new ArrayList<ArrayList<mTile>>());//add a column
    for(int y = 0; y < tileGroupRows; y++){//and make as many rows as needed
      mapTilesCopy.get(x).add(new ArrayList<mTile>());//add a row
    }
  }
  
  for(int i = 0; i < tileGroupCols; i++){//loop through all columns
    for(int j = 0; j < tileGroupRows; j++){//loop through all rows
      hadTile = false;//square does not have tile
      if(checkBounds(X1 + i, Y1 + j)){//if its a negetive number
        if(button_ == 'd'){//we clicked middle button on a tile
          for(int z = 0; z < mapTiles.get(X1 + i).get(Y1 + j).size(); z++){//go through all tiles in this space
            hadTile = true;//square has tile
          }
          if(hadTile == true){//if there was a tile in the space
            mapTiles.get(X1 + i).get(Y1 + j).clear();//delete all tiles in the space
          }
        }else if(button_ == 'x'){//we clicked middle button on a tile
          for(int z = 0; z < mapTiles.get(X1 + i).get(Y1 + j).size(); z++){//go through all tiles in this space
            mTile tmp = mapTiles.get(X1 + i).get(Y1 + j).get(z);//copy the tile
            mapTilesCopy.get(i).get(j).add(new mTile(tmp.image, tmp.tileColor, tmp.colored));//copy the tile
            hadTile = true;//square has tile
          }
          if(hadTile == true){//if there was a tile in the space
            mapTiles.get(X1 + i).get(Y1 + j).clear();//delete all tiles in the space
          }
        }else if(button_ == 'c'){//we clicked right button
          for(int z = 0; z < mapTiles.get(X1 + i).get(Y1 + j).size(); z++){//go through all tiles in this space
            mTile tmp = mapTiles.get(X1 + i).get(Y1 + j).get(z);//copy the tile
            mapTilesCopy.get(i).get(j).add(new mTile(tmp.image, tmp.tileColor, tmp.colored));//copy the tile
          }
        }
      }
    }
  }
  tileGroupStep = 0;//reset step count
}//void tileGroupCutCopy(char button) END

//---------------------------------------------------------------------------------------------------------------------------------------

void tileGroupPaste(){//Paste The Copied Tiles
  if(noTile == true){//are we not allowed to place tiles
    return;//do nothing
  }
  
  mouseToXXYY();
  
  for(int i = 0; i < tileGroupCols; i++){//loop through all columns
    for(int j = 0; j < tileGroupRows; j++){//loop through all rows
      for(int z = 0; z < mapTilesCopy.get(i).get(j).size(); z++){//go through all tiles in this space
        mTile tmp = mapTilesCopy.get(i).get(j).get(z);//get the copy
        int tmpX = (X1 / scl) + i;//Adjust XY To Be On Tile Border
        int tmpY = (Y1 / scl) + j;//Adjust XY To Be On Tile Border
        if(checkBounds(tmpX, tmpY)){//if we're in a negative area
          mapTiles.get(tmpX).get(tmpY).add(new mTile(tmp.image, tmp.tileColor, tmp.colored));//paste tile
        }
      }
    }
  }
}//void tileGroupPaste() END

//---------------------------------------------------------------------------------------------------------------------------------------

void drawGroupPasteOutline(){//Draw Red Outline Showing Amount Of Tiles To Be Placed
  mouseToXXYY();
  
  X2 = X1 + (tileGroupCols * scl);
  Y2 = Y1 + (tileGroupRows * scl);
  
  for(int i = 0; i < tileGroupCols; i++){//loop through all columns
    for(int j = 0; j < tileGroupRows; j++){//loop through all rows
      boolean skip = false;//do we skip drawing the rest of the tiles in this spot?
      for(int z = mapTilesCopy.get(i).get(j).size() - tileDepth; z < mapTilesCopy.get(i).get(j).size() && !skip; z++){//loop through all drawn tiles in this xy position
        if(z >= 0){//if there's a tile to be drawn
          mapTilesCopy.get(i).get(j).get(z).draw((i * scl) + X1, (j * scl) + Y1);//draw it
          drawnTiles++;//how many tiles are being drawn?
          if(mapTilesCopy.get(i).get(j).get(z).colored){//if there's a non-clear tile thats not at the bottom
            skip = true;//don't draw anything below it
          }
        }
      }
    }
  }
  
  strokeWeight(borderThickness);//Thicker
  stroke(255,0,0);//RED
  line(X1, Y1, X1, Y2);//Draw Left
  line(X2, Y1, X2, Y2);//Draw Right
  line(X1, Y1, X2, Y1);//Draw Top
  line(X1, Y2, X2, Y2);//Draw Bottom
  strokeWeight(1);//Default
  stroke(0);//BLACK
}//void drawGroupPasteOutline() END

//---------------------------------------------------------------------------------------------------------------------------------------

void drawTileGroupOutline(){//Draw Red Outline Showing Selected Area
  int asx2 = 0,asy2 = 0;//Setup Variables
    
  if(tileGroupStep == 1){//Are We On Step One
    asx2 = mouseX - screenX;//Corner is tied to mouse
    asy2 = mouseY - screenY - (UIBottom);//Corner is tied to mouse
  }else if(tileGroupStep == 2){//Are We On Step Two
    asx2 = sx2;//Corner is tied to set XY
    asy2 = sy2;//Corner is tied to set XY
  }
  
  setupXXYY(sx1, asx2, sy1, asy2);
  
  X1 = X1 * scl;
  X2 = X2 * scl;
  Y1 = Y1 * scl;
  Y2 = Y2 * scl;
    
  strokeWeight(borderThickness);//Thicker
  stroke(255,0,0);//RED
  line(X1, Y1, X1, Y2);//Draw Left
  line(X2, Y1, X2, Y2);//Draw Right
  line(X1, Y1, X2, Y1);//Draw Top
  line(X1, Y2, X2, Y2);//Draw Bottom
  strokeWeight(1);//Default
  stroke(0);//BLACK
}//void drawTileGroupOutline() END

//---------------------------------------------------------------------------------------------------------------------------------------

void drawTileGroupOutlines(){
  if(tileGroupStep > 0 && tileGroupStep != 3){//selecting group and not pasteing
    drawTileGroupOutline();//draw the red outline
  }
  
  if(tileGroupStep == 3){//pasteing group
    drawGroupPasteOutline();//draw the red outline
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------

void setupXXYY(int tmpX1_, int tmpX2_, int tmpY1_, int tmpY2_){
  if(tmpX1_ < tmpX2_){//if x1 is less than x2
    X1 = floor(tmpX1_ / scl);//Adjust XY To Be On Tile Border
    X2 = (ceil((float)tmpX2_ / scl));//Adjust XY To Be On Tile Border
  }else{//otherwise
    X2 = (ceil((float)tmpX1_ / scl));//Adjust XY To Be On Tile Border
    X1 = floor(tmpX2_ / scl);//Adjust XY To Be On Tile Border
  }

  if(tmpY1_ < tmpY2_){//if y1 is less than y2
    Y1 = floor(tmpY1_ / scl);//Adjust XY To Be On Tile Border
    Y2 = (ceil((float)tmpY2_ / scl));//Adjust XY To Be On Tile Border
  }else{//otherwise
    Y2 = (ceil((float)tmpY1_ / scl));//Adjust XY To Be On Tile Border
    Y1 = floor(tmpY2_ / scl);//Adjust XY To Be On Tile Border
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------

void mouseToXXYY(){
  X1 = (floor((mouseX - ((tileGroupCols / 2) * scl)) / scl) * scl) - screenX;//Adjust XY To Be On Tile Border
  Y1 = (floor((mouseY - ((tileGroupRows / 2) * scl)) / scl) * scl) - screenY - 64;//Adjust XY To Be On Tile Border
}