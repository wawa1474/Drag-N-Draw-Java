int tileGroupStep = 0;//what step are we in setting tile group
boolean tileGroupDeleting = false;//are we deleting the tile group
int sx1, sy1, sx2, sy2;//tileGroup XY corners
int tileGrouSXLines = 0;//how many X lines of copied tiles
int tileGrouSYLines = 0;//how many Y lines of copied tiles



void tileGroup(String button){//mess with tiles in square group
  int X1, X2, Y1, Y2;//define XY positions
  int XLines, YLines;//define number of XY lines
  
  if(sx1 < sx2){//if x1 is less than x2
    X1 = floor(sx1 / scl) * scl;//Adjust XY To Be On Tile Border
    X2 = (ceil((float)sx2 / scl) * scl);//Adjust XY To Be On Tile Border
  }else{//otherwise
    X2 = (ceil((float)sx1 / scl) * scl);//Adjust XY To Be On Tile Border
    X1 = floor(sx2 / scl) * scl;//Adjust XY To Be On Tile Border
  }
  
  if(sy1 < sy2){//if y1 is less than y2
    Y1 = floor(sy1 / scl) * scl;//Adjust XY To Be On Tile Border
    Y2 = (ceil((float)sy2 / scl) * scl);//Adjust XY To Be On Tile Border
  }else{//otherwise
    Y2 = (ceil((float)sy1 / scl) * scl);//Adjust XY To Be On Tile Border
    Y1 = floor(sy2 / scl) * scl;//Adjust XY To Be On Tile Border
  }
  
  //X2 += scl;
  //Y2 += scl;
  
  XLines = (X2 - X1) / scl;//how many x lines
  YLines = (Y2 - Y1) / scl;//how many y lines
  
  for(int i = 0; i < YLines; i++){//loop through all y lines
    for(int j = 0; j < XLines; j++){//loop through all x lines
      if(button == "left"){//we clicked left button
        mapTiles = (mTile[]) expand(mapTiles, mapTiles.length + 1);//make sure we have room
        mapTiles[mapTiles.length - 1] = new mTile(X1 + (scl * j),Y1 + (scl * i),tileN,(int)RSlider.getValue(),(int)GSlider.getValue(),(int)BSlider.getValue(), CClear);//Place a tile
      }else if(button == "center" && tileGroupDeleting == true){//we clicked middle button on a tile
        for(int k = 0; k <= mapTiles.length - 1; k++){//loop through all tiles
          if(isCursorOnTileXY(k, (X1 + (scl * j)) + 4, (Y1 + (scl * i)) + 4)){//Are we clicking on the tile
            deleteTile(k);//delete the tile
            k--;//We need to recheck that tile
          }
        }
      }else if(button == "center"){//we clicked middle button
        mapTiles = (mTile[]) expand(mapTiles, mapTiles.length + 1);//make sure we have room
        mapTiles[mapTiles.length - 1] = new mTile(X1 + (scl * j),Y1 + (scl * i),tileBorderNumber,(int)RSlider.getValue(),(int)GSlider.getValue(),(int)BSlider.getValue(), CClear);//Place a tile
      }else if(button == "right"){//we clicked right button
        for(int k = 0; k <= mapTiles.length-1; k++){//loop through all tiles
          if(isCursorOnTileXY(k, (X1 + (scl * j)) + 4, (Y1 + (scl * i)) + 4)){//Are we clicking on the tile
            mapTiles[k].r = (int)RSlider.getValue();//set tile red value to red slider value
            mapTiles[k].g = (int)GSlider.getValue();//set tile green value to green slider value
            mapTiles[k].b = (int)BSlider.getValue();//set tile blue value to blue slider value
          }
        }
      }
    }
  }
  tileGroupStep = 0;//reset step count
  tileGroupDeleting = false;//no longer deleting
  
  resetLHXY();
}//void tileGroup(String button) END

//---------------------------------------------------------------------------------------------------------------------------------------

void tileGroupCutCopy(char button){//mess with tiles in square group
  int X1, X2, Y1, Y2;//define XY positions
  int tileCount = 0;//how many tiles are selected
  boolean hadTile = false;//did that square have a tile?
  
  if(sx1 < sx2){//if x1 is less than x2
    X1 = floor(sx1 / scl) * scl;//Adjust XY To Be On Tile Border
    X2 = (ceil((float)sx2 / scl) * scl);//Adjust XY To Be On Tile Border
  }else{//otherwise
    X2 = (ceil((float)sx1 / scl) * scl);//Adjust XY To Be On Tile Border
    X1 = floor(sx2 / scl) * scl;//Adjust XY To Be On Tile Border
  }
  
  if(sy1 < sy2){//if y1 is less than y2
    Y1 = floor(sy1 / scl) * scl;//Adjust XY To Be On Tile Border
    Y2 = (ceil((float)sy2 / scl) * scl);//Adjust XY To Be On Tile Border
  }else{//otherwise
    Y2 = (ceil((float)sy1 / scl) * scl);//Adjust XY To Be On Tile Border
    Y1 = floor(sy2 / scl) * scl;//Adjust XY To Be On Tile Border
  }
  
  //X2 += scl;
  //Y2 += scl;
  
  tileGrouSXLines = (X2 - X1) / scl;//how many x lines
  tileGrouSYLines = (Y2 - Y1) / scl;//how many y lines
  
  for(int i = 0; i < tileGrouSYLines; i++){//loop through all y lines
    for(int j = 0; j < tileGrouSXLines; j++){//loop through all x lines
      hadTile = false;//square does not have tile
      if(button == 'x'){//we clicked middle button on a tile
        for(int k = 0; k <= mapTiles.length-1; k++){//loop through all tiles
          if(isCursorOnTileXY(k, (X1 + (scl * j)) + 4, (Y1 + (scl * i)) + 4)){//Are we clicking on the tile
            mapTilesCopy = (mTile[]) expand(mapTilesCopy, mapTilesCopy.length + 1);//make sure we have room
            mapTilesCopy[tileCount] = mapTiles[k];//copy the tile
            tileCount++;//next tile
            deleteTile(k);//delete the tile
            k--;//We need to recheck that tile
            hadTile = true;//square has tile
          }
        }
      }else if(button == 'c'){//we clicked right button
        for(int k = 0; k <= mapTiles.length-1; k++){//loop through all tiles
          if(isCursorOnTileXY(k, (X1 + (scl * j)) + 4, (Y1 + (scl * i)) + 4)){//Are we clicking on the tile
            mapTilesCopy = (mTile[]) expand(mapTilesCopy, mapTilesCopy.length + 1);//make sure we have room
            mapTilesCopy[tileCount] = mapTiles[k];//copy the tile
            tileCount++;//next tile
            hadTile = true;//square has tile
          }
        }
      }
      if(hadTile == false){//if square did not have tile
        mapTilesCopy = (mTile[]) expand(mapTilesCopy, mapTilesCopy.length + 1);//make sure we have room
        mapTilesCopy[tileCount] = null;//insert null tile
        tileCount++;//next tile
      }
    }
  }
  tileGroupStep = 0;//reset step count
  
  resetLHXY();
}//void tileGroupCutCopy(char button) END

//---------------------------------------------------------------------------------------------------------------------------------------

void tileGroupPaste(){//Paste The Copied Tiles
  int X1,Y1;//Setup Variables
  int tileCount = 0;//how many tiles are there
  
  X1 = floor((mouseX - (floor(tileGrouSXLines / 2) * scl)) / scl) * scl - SX;//Adjust XY To Be On Tile Border
  Y1 = floor((mouseY - (floor(tileGrouSYLines / 2) * scl)) / scl) * scl - SY;//Adjust XY To Be On Tile Border
  
  for(int i = 0; i < tileGrouSYLines; i++){//loop through all y lines
    for(int j = 0; j < tileGrouSXLines; j++){//loop through all x lines
      if(tileCount < mapTilesCopy.length){//are there more tiles
        if(mapTilesCopy[tileCount] != null){//if tile is not null
          mapTiles = (mTile[]) expand(mapTiles, mapTiles.length + 1);
          mapTiles[mapTiles.length - 1] = new mTile(0, 0, mapTilesCopy[tileCount].image, mapTilesCopy[tileCount].r, mapTilesCopy[tileCount].g, mapTilesCopy[tileCount].b, mapTilesCopy[tileCount].clear);//paste tile
          mapTiles[mapTiles.length - 1].x = X1 + (scl * j);//Adjust XY To Be On Tile Border
          mapTiles[mapTiles.length - 1].y = Y1 + (scl * i);//Adjust XY To Be On Tile Border
        }
        if(tileCount++ == mapTilesCopy.length){//are we done
          return;//yes, return
        }
      }
    }
  }
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
  
  strokeWeight(borderThickness); // Thicker
  stroke(255,0,0);//RED
  line(X1, Y1, X1, Y2);//Draw Left
  line(X2, Y1, X2, Y2);//Draw Right
  line(X1, Y1, X2, Y1);//Draw Top
  line(X1, Y2, X2, Y2);//Draw Bottom
  strokeWeight(1); // Default
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
    
  strokeWeight(borderThickness); // Thicker
  stroke(255,0,0);//RED
  line(X1, Y1, X1, Y2);//Draw Left
  line(X2, Y1, X2, Y2);//Draw Right
  line(X1, Y1, X2, Y1);//Draw Top
  line(X1, Y2, X2, Y2);//Draw Bottom
  strokeWeight(1); // Default
  stroke(0);//BLACK
}//void drawTileGroupOutline() END