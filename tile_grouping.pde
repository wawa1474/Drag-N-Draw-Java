int tileGroupStep = 0;//what step are we in setting tile group
boolean tileGroupDeleting = false;//are we deleting the tile group
int tileGroupX1, tileGroupX2, tileGroupY1, tileGroupY2;//tileGroup XY corners 0 -> rows/cols
int tileGroupCols = 0;//how many X lines of copied tiles
int tileGroupRows = 0;//how many Y lines of copied tiles
int X1, X2, Y1, Y2;//define XY positions


ArrayList<ArrayList<ArrayList<mTile>>> mapTilesCopy = new ArrayList<ArrayList<ArrayList<mTile>>>(0);//the hellish 3 dimensional ArrayList of tiles to copy, paste, or cut



void tileGroup(String button){//mess with tiles in square group
  int XLines, YLines;//define number of XY lines
  boolean skip = false;
  
  setupOutlineXY(tileGroupX1, tileGroupX2, tileGroupY1, tileGroupY2);
  
  XLines = (X2 - X1);//how many x lines
  YLines = (Y2 - Y1);//how many y lines
  
  for(int i = 0; i < XLines; i++){//loop through all columns
    for(int j = 0; j < YLines; j++){//loop through all rows
      if(X1 + i < 0 || Y1 + j < 0){//if its a negetive number
        skip = true;//skip this space
      }
      
      if(button == "left" && !skip){//we clicked left button
        mapTiles.get(X1 + i).get(Y1 + j).add(new mTile(tileN,(int)RSlider.getValue(),(int)GSlider.getValue(),(int)BSlider.getValue(), CClear));//Place a tile
      }else if(button == "center" && tileGroupDeleting == true && !skip){//we clicked middle button on a tile
        for(int x = X1; x < X1 + XLines; x++){//go through the selected columns
          for(int y = Y1; y < Y1 + YLines; y++){//go through the selected rows
            if(isCursorOnTile(x, y, X1 + i, Y1 + j)){//Are we clicking on the tile
              mapTiles.get(x).get(y).clear();//delete all the tiles in this space
            }
          }
        }
      }else if(button == "center" && !skip){//we clicked middle button
        mapTiles.get(X1 + i).get(Y1 + j).add(new mTile(tileBorderNumber,(int)RSlider.getValue(),(int)GSlider.getValue(),(int)BSlider.getValue(), CClear));//Place a tile
      }else if(button == "right" && !skip){//we clicked right button
        for(int x = X1; x < X1 + XLines; x++){//go through the selected columns
          for(int y = Y1; y < Y1 + YLines; y++){//go through the selected rows
            if(isCursorOnTile(x, y, X1 + i, Y1 + j)){//Are we clicking on the tile
              for(int z = 0; z < mapTiles.get(x).get(y).size(); z++){//go through all the tiles in this space
                mTile tmp = mapTiles.get(x).get(y).get(0);//grab the tile
                tmp.r = (int)RSlider.getValue();//set tile red value to red slider value
                tmp.g = (int)GSlider.getValue();//set tile green value to green slider value
                tmp.b = (int)BSlider.getValue();//set tile blue value to blue slider value
                mapTiles.get(x).get(y).remove(0);//delete the old tile
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
  
  resetLHXY();//reset the lower/higher xy for background drawing
}//void tileGroup(String button) END

//---------------------------------------------------------------------------------------------------------------------------------------

void tileGroupCutCopy(char button){//mess with tiles in square group
  boolean skip = false;//how many tiles are selected
  boolean hadTile = false;//did that square have a tile?
  
  setupOutlineXY(tileGroupX1, tileGroupX2, tileGroupY1, tileGroupY2);
  
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
      if(X1 + i < 0 || Y1 + j < 0){//if its a negetive number
        skip = true;//skip this space
      }
      if(button == 'x' && !skip){//we clicked middle button on a tile
        if(isCursorOnTile(X1 + i, Y1 + j, X1 + i, Y1  + j)){//Are we clicking on the tile
          for(int z = 0; z < mapTiles.get(X1 + i).get(Y1 + j).size(); z++){//go through all tiles in this space
            mTile tmp = mapTiles.get(X1 + i).get(Y1 + j).get(z);//copy the tile
            mapTilesCopy.get(i).get(j).add(new mTile(tmp.image, tmp.r, tmp.g, tmp.b, tmp.clear));//copy the tile
            hadTile = true;//square has tile
          }
        }
        if(hadTile == true){//if there was a tile in the space
          mapTiles.get(X1 + i).get(Y1 + j).clear();//delete all tiles in the space
        }
      }else if(button == 'c' && !skip){//we clicked right button
        if(isCursorOnTile(X1 + i, Y1 + j, X1 + i, Y1  + j)){//Are we clicking on the tile
          for(int z = 0; z < mapTiles.get(X1 + i).get(Y1 + j).size(); z++){//go through all tiles in this space
            mTile tmp = mapTiles.get(X1 + i).get(Y1 + j).get(z);//copy the tile
            mapTilesCopy.get(i).get(j).add(new mTile(tmp.image, tmp.r, tmp.g, tmp.b, tmp.clear));//copy the tile
            hadTile = true;//square has tile
          }
        }
      }
      if(hadTile == false){//if square did not have tile
        mapTilesCopy.add(null);//insert null tile
      }
      
      skip = false;//only skip if we need to
    }
  }
  tileGroupStep = 0;//reset step count
  resetLHXY();//reset the lower/higher xy for background drawing
}//void tileGroupCutCopy(char button) END

//---------------------------------------------------------------------------------------------------------------------------------------

void tileGroupPaste(){//Paste The Copied Tiles
  int tileCount = 0;//how many tiles are there
  
  if(noTile == true){//are we not allowed to place tiles
    return;//do nothing
  }
  
  X1 = floor((mouseX - (floor(tileGroupCols / 2) * scl)) / scl) * scl + (screenX * scl);//Adjust XY To Be On Tile Border
  Y1 = floor((mouseY - (floor(tileGroupRows / 2) * scl)) / scl) * scl + (screenY * scl);//Adjust XY To Be On Tile Border
  
  for(int i = 0; i < tileGroupCols; i++){//loop through all columns
    for(int j = 0; j < tileGroupRows; j++){//loop through all rows
      for(int z = 0; z < mapTilesCopy.get(i).get(j).size(); z++){//go through all tiles in this space
        mTile tmp = mapTilesCopy.get(i).get(j).get(z);//get the copy
        int tmpX = (X1 / scl) + i;//Adjust XY To Be On Tile Border
        int tmpY = (Y1 / scl) + j;//Adjust XY To Be On Tile Border
        if(tmpX < 0 || tmpY < 0){//if we're in a nagative area
          //do nothing
        }else{
          mapTiles.get(tmpX).get(tmpY).add(new mTile(tmp.image, tmp.r, tmp.g, tmp.b, tmp.clear));//paste tile
        }
      }
    }
  }
  resetLHXY();//reset the lower/higher xy for background drawing
}//void tileGroupPaste() END

//---------------------------------------------------------------------------------------------------------------------------------------

void drawGroupPasteOutline(){//Draw Red Outline Showing Amount Of Tiles To Be Placed
  int X1,X2,Y1,Y2;//Setup Variables
  
  X1 = floor((mouseX - (floor(tileGroupCols / 2) * scl)) / scl) * scl + (screenX * scl);//Adjust XY To Be On Tile Border
  X2 = (floor((mouseX + (ceil((float)tileGroupCols / 2) * scl)) / scl) * scl) + (screenX * scl);//Adjust XY To Be On Tile Border
  Y1 = floor((mouseY - (floor(tileGroupRows / 2) * scl)) / scl) * scl + (screenY * scl);//Adjust XY To Be On Tile Border
  Y2 = (floor((mouseY + (ceil((float)tileGroupRows / 2) * scl)) / scl) * scl) + (screenY * scl);//Adjust XY To Be On Tile Border

  //X1 = (mouseTileX - (tileGrouSXLines / 2)) + screenX;//Adjust XY To Be On Tile Border
  //X2 = (mouseTileX + (tileGrouSXLines / 2)) + screenX;//Adjust XY To Be On Tile Border
  //Y1 = (mouseTileY - (tileGrouSYLines / 2)) + screenY;//Adjust XY To Be On Tile Border
  //Y2 = (mouseTileY + (tileGrouSYLines / 2)) + screenY;//Adjust XY To Be On Tile Border
  
  //int tmpX = 0, tmpY = 0;
  
  //if(X2 - X1 % 2 != 0){tmpX = 1;}
  //if(Y2 - Y1 % 2 != 0){tmpY = 1;}
  
  strokeWeight(borderThickness);//Thicker
  stroke(255,0,0);//RED
  line(X1, Y1, X1, Y2);//Draw Left
  line(X2, Y1, X2, Y2);//Draw Right
  line(X1, Y1, X2, Y1);//Draw Top
  line(X1, Y2, X2, Y2);//Draw Bottom
  //line(X1 * scl, Y1 * scl, X1 * scl, (Y2 + tmpY) * scl);//Draw Left
  //line((X2 + tmpX) * scl, Y1 * scl, (X2 + tmpX) * scl, (Y2 + tmpY) * scl);//Draw Right
  //line(X1 * scl, Y1 * scl, (X2 + tmpX) * scl, Y1 * scl);//Draw Top
  //line(X1 * scl, (Y2 + tmpY) * scl, (X2 + tmpX) * scl, (Y2 + tmpY) * scl);//Draw Bottom
  strokeWeight(1);//Default
  stroke(0);//BLACK
}//void drawGroupPasteOutline() END

//---------------------------------------------------------------------------------------------------------------------------------------

void drawTileGroupOutline(){//Draw Red Outline Showing Selected Area
  int asx2 = 0,asy2 = 0;//Setup Variables
    
  if(tileGroupStep == 1){//Are We On Step One
    asx2 = mouseTileX + 1;//Corner is tied to mouse
    asy2 = mouseTileY + 1;//Corner is tied to mouse
  }else if(tileGroupStep == 2){//Are We On Step Two
    asx2 = tileGroupX2;//Corner is tied to set XY
    asy2 = tileGroupY2;//Corner is tied to set XY
  }
  
  setupOutlineXY(tileGroupX1, asx2, tileGroupY1, asy2);
  
  //X2 += scl;
  //Y2 += scl;
    
  strokeWeight(borderThickness);//Thicker
  stroke(255,0,0);//RED
  line(X1 * scl, Y1 * scl, X1 * scl, Y2 * scl);//Draw Left
  line(X2 * scl, Y1 * scl, X2 * scl, Y2 * scl);//Draw Right
  line(X1 * scl, Y1 * scl, X2 * scl, Y1 * scl);//Draw Top
  line(X1 * scl, Y2 * scl, X2 * scl, Y2 * scl);//Draw Bottom
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

void setupOutlineXY(int tmpX1, int tmpX2, int tmpY1, int tmpY2){
  if(tmpX1 < tmpX2){//if x1 is less than x2
    X1 = tmpX1;//Adjust XY To Be On Tile Border
    X2 = tmpX2;//Adjust XY To Be On Tile Border
  }else{//otherwise
    X2 = tmpX1 + 1;//Adjust XY To Be On Tile Border
    X1 = tmpX2 - 1;//Adjust XY To Be On Tile Border
  }
  
  if(tmpY1 < tmpY2){//if y1 is less than y2
    Y1 = tmpY1;//Adjust XY To Be On Tile Border
    Y2 = tmpY2;//Adjust XY To Be On Tile Border
  }else{//otherwise
    Y2 = tmpY1 + 1;//Adjust XY To Be On Tile Border
    Y1 = tmpY2 - 1;//Adjust XY To Be On Tile Border
  }
}