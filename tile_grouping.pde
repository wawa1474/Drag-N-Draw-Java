int tileGroupStep = 0;//what step are we in setting tile group
boolean tileGroupDeleting = false;//are we deleting the tile group
int sx1, sy1, sx2, sy2;//tileGroup XY corners
int tileGrouSXLines = 0;//how many X lines of copied tiles
int tileGrouSYLines = 0;//how many Y lines of copied tiles


ArrayList<ArrayList<ArrayList<mTile>>> mapTilesCopy = new ArrayList<ArrayList<ArrayList<mTile>>>(0);//the hellish 3 dimensional ArrayList of tiles to copy, paste, or cut



void tileGroup(String button){//mess with tiles in square group
  int X1, X2, Y1, Y2;//define XY positions
  int XLines, YLines;//define number of XY lines
  boolean skip = false;
  
  if(sx1 < sx2){//if x1 is less than x2
    X1 = floor(sx1 / scl);//Adjust XY To Be On Tile Border
    X2 = (ceil((float)sx2 / scl));//Adjust XY To Be On Tile Border
  }else{//otherwise
    X2 = (ceil((float)sx1 / scl));//Adjust XY To Be On Tile Border
    X1 = floor(sx2 / scl);//Adjust XY To Be On Tile Border
  }
  
  if(sy1 < sy2){//if y1 is less than y2
    Y1 = floor(sy1 / scl);//Adjust XY To Be On Tile Border
    Y2 = (ceil((float)sy2 / scl));//Adjust XY To Be On Tile Border
  }else{//otherwise
    Y2 = (ceil((float)sy1 / scl));//Adjust XY To Be On Tile Border
    Y1 = floor(sy2 / scl);//Adjust XY To Be On Tile Border
  }
  
  //X2 += scl;
  //Y2 += scl;
  
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
            if(isCursorOnTileXY(x, y, ((X1 + i) * scl) + 4, ((Y1 + j) * scl) + 4)){//Are we clicking on the tile
              mapTiles.get(x).get(y).clear();//delete all the tiles in this space
            }
          }
        }
      }else if(button == "center" && !skip){//we clicked middle button
        mapTiles.get(X1 + i).get(Y1 + j).add(new mTile(tileBorderNumber,(int)RSlider.getValue(),(int)GSlider.getValue(),(int)BSlider.getValue(), CClear));//Place a tile
      }else if(button == "right" && !skip){//we clicked right button
        for(int x = X1; x < X1 + XLines; x++){//go through the selected columns
          for(int y = Y1; y < Y1 + YLines; y++){//go through the selected rows
            if(isCursorOnTileXY(x, y, ((X1 + i) * scl) + 4, ((Y1 + j) * scl) + 4) && mapTiles.get(x).get(y).size() != 0){//Are we clicking on the tile
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
  int X1, X2, Y1, Y2;//define XY positions
  boolean skip = false;//how many tiles are selected
  boolean hadTile = false;//did that square have a tile?
  
  if(sx1 < sx2){//if x1 is less than x2
    X1 = floor(sx1 / scl);//Adjust XY To Be On Tile Border
    X2 = (ceil((float)sx2 / scl));//Adjust XY To Be On Tile Border
  }else{//otherwise
    X2 = (ceil((float)sx1 / scl));//Adjust XY To Be On Tile Border
    X1 = floor(sx2 / scl);//Adjust XY To Be On Tile Border
  }
  
  if(sy1 < sy2){//if y1 is less than y2
    Y1 = floor(sy1 / scl);//Adjust XY To Be On Tile Border
    Y2 = (ceil((float)sy2 / scl));//Adjust XY To Be On Tile Border
  }else{//otherwise
    Y2 = (ceil((float)sy1 / scl));//Adjust XY To Be On Tile Border
    Y1 = floor(sy2 / scl);//Adjust XY To Be On Tile Border
  }
  
  //X2 += scl;
  //Y2 += scl;
  
  tileGrouSXLines = (X2 - X1);//how many x lines
  tileGrouSYLines = (Y2 - Y1);//how many y lines
  
  mapTilesCopy.clear();//delete all tiles
  for(int x = 0; x < tileGrouSXLines; x++){//and make as many columns as needed
    mapTilesCopy.add(new ArrayList<ArrayList<mTile>>());//add a column
    for(int y = 0; y < tileGrouSYLines; y++){//and make as many rows as needed
      mapTilesCopy.get(x).add(new ArrayList<mTile>());//add a row
    }
  }
  
  for(int i = 0; i < tileGrouSXLines; i++){//loop through all columns
    for(int j = 0; j < tileGrouSYLines; j++){//loop through all rows
      hadTile = false;//square does not have tile
      if(X1 + i < 0 || Y1 + j < 0){//if its a negetive number
        skip = true;//skip this space
      }
      if(button == 'x' && !skip){//we clicked middle button on a tile
        if(isCursorOnTileXY(X1 + i, Y1 + j, ((X1 + i) * scl) + 4, ((Y1  + j) * scl) + 4) && mapTiles.get(X1 + i).get(Y1 + j).size() != 0){//Are we clicking on the tile
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
        if(isCursorOnTileXY(X1 + i, Y1 + j, ((X1 + i) * scl) + 4, ((Y1  + j) * scl) + 4) && mapTiles.get(X1 + i).get(Y1 + j).size() != 0){//Are we clicking on the tile
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
  int X1,Y1;//Setup Variables
  int tileCount = 0;//how many tiles are there
  
  X1 = floor((mouseX - (floor(tileGrouSXLines / 2) * scl)) / scl) * scl - SX;//Adjust XY To Be On Tile Border
  Y1 = floor((mouseY - (floor(tileGrouSYLines / 2) * scl)) / scl) * scl - SY;//Adjust XY To Be On Tile Border
  
  for(int i = 0; i < tileGrouSXLines; i++){//loop through all columns
    for(int j = 0; j < tileGrouSYLines; j++){//loop through all rows
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
  
  X1 = floor((mouseX - (floor(tileGrouSXLines / 2) * scl)) / scl) * scl - SX;//Adjust XY To Be On Tile Border
  X2 = (floor((mouseX + (ceil((float)tileGrouSXLines / 2) * scl)) / scl) * scl) - SX;//Adjust XY To Be On Tile Border
  Y1 = floor((mouseY - (floor(tileGrouSYLines / 2) * scl)) / scl) * scl - SY;//Adjust XY To Be On Tile Border
  Y2 = (floor((mouseY + (ceil((float)tileGrouSYLines / 2) * scl)) / scl) * scl) - SY;//Adjust XY To Be On Tile Border
  
  //X2 += scl;
  //Y2 += scl;
  
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
  int X1,X2,Y1,Y2,asx2 = 0,asy2 = 0;//Setup Variables
    
  if(tileGroupStep == 1){//Are We On Step One
    asx2 = mouseX - SX;//Corner is tied to mouse
    asy2 = mouseY - SY;//Corner is tied to mouse
  }else if(tileGroupStep == 2){//Are We On Step Two
    asx2 = sx2;//Corner is tied to set XY
    asy2 = sy2;//Corner is tied to set XY
  }
    
  if(sx1 < asx2){//if x1 is less than x2
    X1 = floor(sx1 / scl) * scl;//Adjust XY To Be On Tile Border
    X2 = ceil((float)asx2 / scl) * scl;//Adjust XY To Be On Tile Border
  }else{//otherwise
    X2 = ceil((float)sx1 / scl) * scl;//Adjust XY To Be On Tile Border
    X1 = floor(asx2 / scl) * scl;//Adjust XY To Be On Tile Border
  }
  
  if(sy1 < asy2){//if y1 is less than y2
    Y1 = floor(sy1 / scl) * scl;//Adjust XY To Be On Tile Border
    Y2 = ceil((float)asy2 / scl) * scl;//Adjust XY To Be On Tile Border
  }else{//otherwise
    Y2 = ceil((float)sy1 / scl) * scl;//Adjust XY To Be On Tile Border
    Y1 = floor(asy2 / scl) * scl;//Adjust XY To Be On Tile Border
  }
  
  //X2 += scl;
  //Y2 += scl;
    
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