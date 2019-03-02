int tileGroupStep = 0;//what step are we in setting tile group
boolean tileGroupDeleting = false;//are we deleting the tile group
int sx1, sy1, sx2, sy2;//tileGroup XY corners
int tileGrouSXLines = 0;//how many X lines of copied tiles
int tileGrouSYLines = 0;//how many Y lines of copied tiles


ArrayList<ArrayList<ArrayList<mTile>>> mapTilesCopy = new ArrayList<ArrayList<ArrayList<mTile>>>(0);



void tileGroup(String button){//mess with tiles in square group
  int X1, X2, Y1, Y2;//define XY positions
  int XLines, YLines;//define number of XY lines
  
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
  
  for(int i = 0; i < YLines; i++){//loop through all y lines
    for(int j = 0; j < XLines; j++){//loop through all x lines
      if(button == "left"){//we clicked left button
        mapTiles.get(X1 + j).get(Y1 + i).add(new mTile(tileN,(int)RSlider.getValue(),(int)GSlider.getValue(),(int)BSlider.getValue(), CClear));//Place a tile
      }else if(button == "center" && tileGroupDeleting == true){//we clicked middle button on a tile
        //for(int k = 0; k < mapTiles.size(); k++){//loop through all tiles
        //println("test2");
        for(int x = X1; x < X1 + XLines; x++){
          for(int y = Y1; y < Y1 + YLines; y++){
            if(isCursorOnTileXY(x, y, (scl * X1) + (scl * j) + 4, (scl * Y1) + (scl * i) + 4)){//Are we clicking on the tile
              for(int z = 0; z < mapTiles.get(x).get(y).size(); z++){
                deleteTile(x, y);//delete the tile
              }
            }
          }
        }
        //tileGroupDeleting = false;
      }else if(button == "center"){//we clicked middle button
        //println("test");
        mapTiles.get(X1 + j).get(Y1 + i).add(new mTile(tileBorderNumber,(int)RSlider.getValue(),(int)GSlider.getValue(),(int)BSlider.getValue(), CClear));//Place a tile
      }else if(button == "right"){//we clicked right button
        for(int x = 0; x < mapTiles.size(); x++){
          for(int y = 0; y < mapTiles.get(x).size(); y++){
            if(isCursorOnTileXY(x, y, (scl * X1) + (scl * j) + 4, (scl * Y1) + (scl * i) + 4) && mapTiles.get(x).get(y).size() != 0){//Are we clicking on the tile
              mTile tmp = mapTiles.get(x).get(y).get(0);//mapTiles.get(x).get(y).size() - 1
              tmp.r = (int)RSlider.getValue();//set tile red value to red slider value
              tmp.g = (int)GSlider.getValue();//set tile green value to green slider value
              tmp.b = (int)BSlider.getValue();//set tile blue value to blue slider value
              mapTiles.get(x).get(y).remove(mapTiles.get(x).get(y).size() - 1);
              mapTiles.get(x).get(y).add(tmp);
            }
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
  for(int x = 0; x < tileGrouSXLines; x++){
    mapTilesCopy.add(new ArrayList<ArrayList<mTile>>());
    for(int y = 0; y < tileGrouSYLines; y++){
      mapTilesCopy.get(x).add(new ArrayList<mTile>());
    }
  }
  
  for(int i = 0; i < tileGrouSXLines; i++){//loop through all y lines
    for(int j = 0; j < tileGrouSYLines; j++){//loop through all x lines
      hadTile = false;//square does not have tile
      //println((X1 + i) + ": " + (Y1 + j) + ": " + button);
      if(X1 + i < 0 || Y1 + j < 0){
        skip = true;
      }
      if(button == 'x' && !skip){//we clicked middle button on a tile
            for(int z = 0; z < mapTiles.get(X1 + i).get(Y1 + j).size(); z++){
              if(isCursorOnTileXY((X1) + i, (Y1) + j, ((X1 * scl) + (scl * i)) + 4, ((Y1 * scl) + (scl * j)) + 4) && mapTiles.get(X1 + i).get(Y1 + j).size() != 0 && z < mapTiles.get(X1 + i).get(Y1 + j).size()){//Are we clicking on the tile
                mTile tmp = mapTiles.get(X1 + i).get(Y1 + j).get(z);//copy the tile
                mapTilesCopy.get(i).get(j).add(new mTile(tmp.image, tmp.r, tmp.g, tmp.b, tmp.clear));//copy the tile
                hadTile = true;//square has tile
              }
            }
            if(hadTile == true){
              mapTiles.get(X1 + i).get(Y1 + j).clear();
            }
      }else if(button == 'c'){//we clicked right button
        for(int x = 0; x < mapTiles.size(); x++){
          for(int y = 0; y < mapTiles.get(x).size(); y++){
            if(isCursorOnTileXY(x, y, ((X1 * scl) + (scl * i)) + 4, ((Y1 * scl) + (scl * j)) + 4) && mapTiles.get(x).get(y).size() != 0){//Are we clicking on the tile
              mTile tmp = mapTiles.get(x).get(y).get(mapTiles.get(x).get(y).size() - 1);//copy the tile
              mapTilesCopy.get(i).get(j).add(new mTile(tmp.image, tmp.r, tmp.g, tmp.b, tmp.clear));//copy the tile
              hadTile = true;//square has tile
            }
          }
        }
      }
      if(hadTile == false){//if square did not have tile
        mapTilesCopy.add(null);//insert null tile
      }
      
      skip = false;
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
  
  for(int i = 0; i < tileGrouSXLines; i++){//loop through all y lines
    for(int j = 0; j < tileGrouSYLines; j++){//loop through all x lines
      for(int z = 0; z < mapTilesCopy.get(i).get(j).size(); z++){
        mTile tmp = mapTilesCopy.get(i).get(j).get(z);
        int tmpX = (X1 / scl) + i;//Adjust XY To Be On Tile Border
        int tmpY = (Y1 / scl) + j;//Adjust XY To Be On Tile Border
        if(tmpX < 0 || tmpY < 0){
          
        }else{
          mapTiles.get(tmpX).get(tmpY).add(new mTile(tmp.image, tmp.r, tmp.g, tmp.b, tmp.clear));//paste tile
        }
      }
    }
  }
  resetLHXY();
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