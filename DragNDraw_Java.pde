import controlP5.*;

//Started August 16, 2018 at ~4:30 PM

int _DEBUG_ = 0;
int _DEBUGAMOUNT_ = 50000;

int _FILEVERSION_ = 0;

boolean dragging = false;
boolean deleting = false;
boolean noTile = false;

boolean noKeyboard = false;

int mapN = 0;
int totalImages = 39;
int rowLength = 16;
int tileRow = 0;
int tileN = 1;
boolean CClear = false;

int fullTotalImages = (int)(Math.ceil((double)(totalImages / rowLength)) * rowLength) - 1;

int drawnTiles = 0;
boolean drawAll = false;
int FPSCutOff = 2;

int tileGroupStep = 0;
boolean tileGroupDeleting = false;
int sx1, sy1, sx2, sy2;
int tileGroupXLines = 0;
int tileGroupYLines = 0;

int tileBorderNumber = 0;

int offsetX = 0, offsetY = 0;

int scl = 32;

int cols = 100;
int rows = 100;

int SX = 0, SY = 0;
int mX = 0, mY = 0, pX = 0, pY = 0;
int fV = 1;
int UIRight = 22;
int UIBottom = 2;

int scrollAmount = 5;

PImage[] img = new PImage[0];//totalImages + 1];
mTile[] mapTiles = new mTile[0];//25000];
mTile mapTilesCopy[];
PImage BACKGROUND;
PImage missingTexture;

ControlP5 UIControls;
Controller RSlider, GSlider, BSlider;

tileUI UI = new tileUI();
canvasBG BG = new canvasBG();
int borderThickness = 4;

void preload(){
  missingTexture = loadImage("assets/missingTexture.png");
  
  for(int i = 0; i <= totalImages; i++){
    img = (PImage[]) expand(img, img.length + 1);
    img[i] = loadImage("assets/" + i + ".png");
  }
  
  for(int i = totalImages + 1; i <= fullTotalImages; i++){
    img = (PImage[]) expand(img, img.length + 1);
    img[i] = missingTexture;
  }
  
  BACKGROUND = loadImage("assets/background.png");
}

void setup(){
  preload();
  
  size(960,540);//X, Y
  //fullScreen();
  surface.setResizable(true);
  
  UIControls = new ControlP5(this);
  UI.setup();
  
  mapTiles = (mTile[]) expand(mapTiles, mapTiles.length + 1);
  mapTiles[mapTiles.length - 1] = new mTile(256,256,3,127,127,127,false);
}

void draw(){
  drawnTiles = 0;//reset number of drawn tiles

  //updateXY();//Update the XY position of the mouse and the page XY offset
  
  BG.draw();//Draw the background and grid
  
  //If dragging a tile: update location
  if (dragging){//Are we dragging a tile
    if(mapTiles[mapN] != null){//If tile exists
      updateTileLocation(mapN);//Adjust XY location of tile
    }
  }
  
  //Display Map Tiles
  for(int i = 0; i < mapTiles.length; i++){//Go through all the tiles
    if(mapTiles[i].x > pX - scl && mapTiles[i].x  < width + pX && mapTiles[i].y > pY - 1 && mapTiles[i].y < height + pY || drawAll == true){//if tile is within screen bounds or drawAll is set
      if(!mapTiles[i].clear || mapTiles[i].image == 0){//Is the tile colored
        fill(mapTiles[i].r,mapTiles[i].g,mapTiles[i].b);//Set Tile background color
        rect(mapTiles[i].x,mapTiles[i].y,scl,scl);//Draw colored square behind tile
      }
      if(mapTiles[i].image != 0 && mapTiles[i].image <= totalImages){//if tile image is not 0 and tile image exists
        image(img[mapTiles[i].image], mapTiles[i].x, mapTiles[i].y);//Draw tile
      }else if(mapTiles[i].image != 0){//image is not blank
        image(missingTexture, mapTiles[i].x, mapTiles[i].y);//Draw tile
      }
      drawnTiles++;//how many tiles are being drawn?
    }
  }
  
  BG.border();//Draw the RED border
  
  
  if(tileGroupStep > 0 && tileGroupStep != 3){//selecting group and not pasteing
    drawTileGroupOutline();//draw the red outline
  }
  
  if(tileGroupStep == 3){//pasteing group
    drawGroupPasteOutline();//draw the red outline
  }
  //Update and Draw the UI
  //UI.update();//Update the UI position
  //UI.draw();//Draw the UI
  /*pushMatrix();
  translate(-30, -20);
  BG.draw();
  BG.border();
  UI.draw();
  popMatrix();
  line(100,0,0,100);
  image(img[1], 0,0);
  image(img[mapTiles[0].image],mapTiles[0].x,mapTiles[0].y);*/
}

class tileUI{
  void draw(){
    line(0,0,100,100);
    text(str(_FILEVERSION_), 10,10);
  }
  
  void update(){
    
  }
  
  void setup(){
    UIControls.addSlider("RSlider").setPosition(100,100).setSize(100,20);
    UIControls.addSlider("GSlider").setPosition(100,120).setSize(100,20);
    UIControls.addSlider("BSlider").setPosition(100,140).setSize(100,20);
    RSlider = UIControls.getController("RSlider");
    GSlider = UIControls.getController("GSlider");
    BSlider = UIControls.getController("BSlider");
  }
}

class canvasBG{//The background
  void draw(){//Draw the background
    background(255);//Draw the white background
    image(BACKGROUND, 0, 0);//Draw background
  }//draw() END
  
  void border(){
    strokeWeight(borderThickness); // Thicker
    stroke(255,0,0);//RED
    line(1, 0, 1, rows*scl);//Draw Verticle lines
    line((scl * cols) - 1, 0, (scl * cols) - 1, rows*scl);//Draw Verticle lines
    line(0, 1, cols*scl, 1);//Draw Horizontal Lines
    line(0, (scl * rows) - 1, cols*scl, (scl * rows) - 1);//Draw Horizontal Lines
    strokeWeight(1); // Default
    stroke(0);//BLACK
  }//border() END
}//canvasBG END

class mTile{//Tile Object
  int x, y;
  int image;
  int r, g, b;
  boolean clear;

  public mTile(int x, int y, int image, int r, int g, int b, boolean clear){//Tile Object
    this.x = x;//Store X Position
    this.y = y;//Store Y Position
    this.image = image;//Store Image Number
    this.r = r;//Store Red Value
    this.g = g;//Store Green Value
    this.b = b;//Store Blue Value
    this.clear = clear;//Is the tile clear
    //this.lore = lore || 0;//The LORE? of the tile
  }//mTile() END
}//mTile() END

void deleteTile(int tile){//Delete a tile and update the array
  if(mapTiles.length > 1){//If there is more than 1 tile
    for(int i = tile; i < mapTiles.length; i++){//Go through all tiles after the one we're deleting
      mapTiles[i] = mapTiles[i + 1];//Shift the tile down 1
    }
    mapTiles = (mTile[]) shorten(mapTiles);//Shorten the Map Tiles Array by 1
  }
}//deleteTile() END


void loadTile(int tile){//Set current image to tile image
  tileN = mapTiles[tile].image;//Set current image to tile image
}//loadTile() END

void updateOffset(int tile){//Update mouse XY offset relative to upper-left corner of tile
  offsetX = mapTiles[tile].x-mX;//keep track of relative X location of click to corner of rectangle
  offsetY = mapTiles[tile].y-mY;//keep track of relative Y location of click to corner of rectangle
}//updateOffset() END

void nextTileC(){//Move To Next Tile
  updateTileRow();//Get the row to whatever tile were on
  tileN++;//Increment the tile number
  if(tileN > fullTotalImages){//Is the tile number greater than our total number of images?
    tileN = 0;//Loop the tile number back to the first tile
    tileRow = 0;//Loop the tile row back to the first row
  }
  if(tileN == rowLength*(tileRow+1)){//If the tile number is the last tile
    tileRow++;//Increment the tile row
    if(tileRow > fullTotalImages/rowLength){//Is the tile row greater than our total number of rows?
      tileRow = 0;//Loop the tile row back to the first row
    }
  }
}//nextTileC() END

void prevTileC(){//Move To Previous Tile
  updateTileRow();//Get the row to whatever tile were on
  tileN--;//Decrement the tile number
  if(tileN < 0){//Is the tile number less than zero?
    tileN = fullTotalImages/*totalImages + 1*/;//Loop the tile number back to the last tile
    tileRow = (int)Math.floor(fullTotalImages/rowLength);//Loop the tile row back to the last row
  }
  if(tileN < rowLength*tileRow){//Is the tile number less than the lower end of the current row?
    tileRow--;//Decrement the tile row
    if(tileRow < 0){//Is the tile number less than zero?
      tileRow = (int)Math.floor(fullTotalImages/rowLength);//Loop the tile row back to the last row
    }
  }
}//prevTileC() END

void updateTileRow(){//Get the row to whatever tile were on
  while(Math.floor(tileN/rowLength)*rowLength < rowLength*tileRow){//Is tileN lower than the row were on?
      tileRow--;//Decrement tileRow
      if(tileRow < 0){//Is the tile number less than zero?
        tileRow = (int)Math.floor(totalImages/rowLength);//Loop the tile row back to the last row
      }
    }
    while(Math.floor(tileN/rowLength)*rowLength > rowLength*tileRow){//Is tileN higher than the row were on?
      tileRow++;//Increment tileRow
      if(tileRow > totalImages/rowLength){//Is the tile row greater than our total number of rows?
        tileRow = 0;//Loop the tile row back to the first row
      }
    }
}//updateTileRow() END

void nextRowC(){//Next Row
  if(tileN < rowLength * tileRow || tileN > rowLength * tileRow + rowLength){//Is tileN outside of our current row
    //Do Nothing
  }else{
    tileN += rowLength;//Keep the selected tile number in the same relative position
    if(tileN > fullTotalImages){//If the tile number is greater than our total number of tiles
      tileN = tileN - (fullTotalImages + 1);//Loop the tile number back to first row in the same relative position
    }
  }
  tileRow++;//Increment the row number
  if(tileRow > fullTotalImages / rowLength){//If the row number is greater than our total number of rows
    tileRow = 0;//Loop the row number back to the first
  }
}//nextRowC() END

void prevRowC(){//Previous Row
  if(tileN < rowLength * tileRow || tileN > rowLength * tileRow + rowLength){//Is tileN outside of our current row
    //Do Nothing
  }else{
    tileN -= rowLength;//Keep the selected tile number in the same relative position
    if(tileN < 0){//If the tile number is less than zero
      tileN = (fullTotalImages + 1) - (0 - tileN);//Loop the tile number back to last row in the same relative position
    }
  }
  tileRow--;//Decrement the row number
  if(tileRow < 0){//If the row number is less than our zero
    tileRow = (int)Math.floor(fullTotalImages / rowLength);//Loop the row number back to the last
  }
}//prevRowC() END

boolean isCursorOnTile(int tile){//Is the mouse cursor on the tile we're checking?
  return(mX > mapTiles[tile].x - fV && mX < mapTiles[tile].x + scl + fV && mY > mapTiles[tile].y - fV && mY < mapTiles[tile].y + scl + fV);//Are we clicking on the tile
}//isCursorOnTile() END

boolean isCursorOnTileXY(int tile, int tX, int tY){//Is the mouse cursor on the tile we're checking?
  return(tX > mapTiles[tile].x - fV && tX < mapTiles[tile].x + scl + fV && tY > mapTiles[tile].y - fV && tY < mapTiles[tile].y + scl + fV);//Are we clicking on the tile
}//isCursorOnTile() END

boolean isCursorOnTileNoFV(int tile){//Is the mouse cursor on the tile we're checking?
  return(mX > mapTiles[tile].x && mX < mapTiles[tile].x + scl && mY > mapTiles[tile].y && mY < mapTiles[tile].y + scl);//Are we clicking on the tile
}//isCursorOnTileNoFV() END

boolean isCursorOnTileNoFVXY(int tile, int tX, int tY){//Is the mouse cursor on the tile we're checking?
  return(tX > mapTiles[tile].x && tX < mapTiles[tile].x + scl && tY > mapTiles[tile].y && tY < mapTiles[tile].y + scl);//Are we clicking on the tile
}//isCursorOnTileNoFV() END

void updateTileLocation(int tile){//Adjust XY location of tile
  mapTiles[tile].x = mX + offsetX;//Adjust X location of tile
  mapTiles[tile].y = mY + offsetY;//Adjust Y location of tile
}//updateTileLocation() END

void snapTileLocation(int tile){//Snap XY location of tile to grid
  mapTiles[tile].x = (int)Math.floor(mouseX / scl) * scl;//Adjust X location of tile
  mapTiles[tile].y = (int)Math.floor(mouseY / scl) * scl;//Adjust Y location of tile
}//snapTileLocation() END

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
}//checkImage() END

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
}//checkImageXY() END

void placeTile(){//Place a tile at the mouses location
  //console.log(mouseButton);
  if(mY > scl*UIBottom + pY + fV && mY < (height - (scl*1.5)) + pY + fV && mX < (width - (scl)) + pX + fV){//We're not on the UI and we're within the screen bounds
    if(mouseButton == CENTER && !deleting){//We're dragging with the middle button and not deleting
      mapTiles[mapTiles.length] = new mTile((int)Math.floor(mX/scl)*scl,(int)Math.floor(mY/scl)*scl,tileBorderNumber,(int)RSlider.getValue(),(int)GSlider.getValue(),(int)BSlider.getValue(), false);//Place a colored tile with no image
    }else if(mouseButton == LEFT){//We're dragging with the left button
      mapTiles[mapTiles.length] = new mTile((int)Math.floor(mX/scl)*scl,(int)Math.floor(mY/scl)*scl,tileN,(int)RSlider.getValue(),(int)GSlider.getValue(),(int)BSlider.getValue(), CClear);//Place a tile
    }else if(mouseButton == RIGHT){//We clicked with the right button
      //mapTiles[mapTiles.length] = new mTile(Math.floor(mX/scl)*scl,Math.floor(mY/scl)*scl,tileN,RSlider.value(),GSlider.value(),BSlider.value(), CClear);//Place a tile
    }
  }
}//placeTile() END

void tileGroup(String button){//mess with tiles in square group
  int X1, X2, Y1, Y2;//define XY positions
  int XLines, YLines;//define number of XY lines
  
  if(sx1 < sx2){//if x1 is less than x2
    X1 = (int)Math.floor(sx1 / scl) * scl;//Adjust XY To Be On Tile Border
    X2 = (int)Math.ceil(sx2 / scl) * scl;//Adjust XY To Be On Tile Border
  }else{//otherwise
    X2 = (int)Math.ceil(sx1 / scl) * scl;//Adjust XY To Be On Tile Border
    X1 = (int)Math.floor(sx2 / scl) * scl;//Adjust XY To Be On Tile Border
  }
  
  if(sy1 < sy2){//if y1 is less than y2
    Y1 = (int)Math.floor(sy1 / scl) * scl;//Adjust XY To Be On Tile Border
    Y2 = (int)Math.ceil(sy2 / scl) * scl;//Adjust XY To Be On Tile Border
  }else{//otherwise
    Y2 = (int)Math.ceil(sy1 / scl) * scl;//Adjust XY To Be On Tile Border
    Y1 = (int)Math.floor(sy2 / scl) * scl;//Adjust XY To Be On Tile Border
  }
  
  XLines = (X2 - X1) / scl;//how many x lines
  YLines = (Y2 - Y1) / scl;//how many y lines
  
  for(int i = 0; i < YLines; i++){//loop through all y lines
    for(int j = 0; j < XLines; j++){//loop through all x lines
      if(button == "left"){//we clicked left button
        mapTiles[mapTiles.length] = new mTile(X1 + (scl * j),Y1 + (scl * i),tileN,(int)RSlider.getValue(),(int)GSlider.getValue(),(int)BSlider.getValue(), CClear);//Place a tile
      }else if(button == "center" && tileGroupDeleting == true){//we clicked middle button on a tile
        for(int k = 0; k <= mapTiles.length-1; k++){//loop through all tiles
          if(isCursorOnTileXY(k, (X1 + (scl * j)) + 4, (Y1 + (scl * i)) + 4)){//Are we clicking on the tile
            deleteTile(k);//delete the tile
            k--;//We need to recheck that tile
          }
        }
      }else if(button == "center"){//we clicked middle button
        mapTiles[mapTiles.length] = new mTile(X1 + (scl * j),Y1 + (scl * i),tileBorderNumber,(int)RSlider.getValue(),(int)GSlider.getValue(),(int)BSlider.getValue(), CClear);//Place a tile
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
}//placeTile() END

void tileGroupPaste(){//Paste The Copied Tiles
  int X1,Y1;//Setup Variables
  int tileCount = 0;//how many tiles are there
  
  X1 = (int)Math.floor((mouseX - (Math.floor(tileGroupXLines / 2) * scl)) / scl) * scl;//Adjust XY To Be On Tile Border
  Y1 = (int)Math.floor((mouseY - (Math.floor(tileGroupYLines / 2) * scl)) / scl) * scl;//Adjust XY To Be On Tile Border
  
  for(int i = 0; i < tileGroupYLines; i++){//loop through all y lines
    for(int j = 0; j < tileGroupXLines; j++){//loop through all x lines
      if(tileCount < mapTilesCopy.length){//are there more tiles
        if(mapTilesCopy[tileCount] != null){//if tile is not null
          mapTiles = (mTile[]) expand(mapTiles, mapTiles.length + 1);
          mapTiles[mapTiles.length - 1] = new mTile(0, 0, mapTilesCopy[tileCount].image, mapTilesCopy[tileCount].r, mapTilesCopy[tileCount].g, mapTilesCopy[tileCount].b, mapTilesCopy[tileCount].clear);//paste tile
          mapTiles[mapTiles.length - 2].x = X1 + (scl * j);//Adjust XY To Be On Tile Border
          mapTiles[mapTiles.length - 2].y = Y1 + (scl * i);//Adjust XY To Be On Tile Border
        }
        if(tileCount++ == mapTilesCopy.length){//are we done
          return;//yes, return
        }
      }
    }
  }
}//tileGroupPaste() END

void drawGroupPasteOutline(){//Draw Red Outline Showing Amount Of Tiles To Be Placed
  int X1,X2,Y1,Y2;//Setup Variables
  
  X1 = (int)Math.floor((mouseX - (Math.floor(tileGroupXLines / 2) * scl)) / scl) * scl;//Adjust XY To Be On Tile Border
  X2 = (int)Math.floor((mouseX + (Math.ceil(tileGroupXLines / 2) * scl)) / scl) * scl;//Adjust XY To Be On Tile Border
  Y1 = (int)Math.floor((mouseY - (Math.floor(tileGroupYLines / 2) * scl)) / scl) * scl;//Adjust XY To Be On Tile Border
  Y2 = (int)Math.floor((mouseY + (Math.ceil(tileGroupYLines / 2) * scl)) / scl) * scl;//Adjust XY To Be On Tile Border
  
  strokeWeight(borderThickness); // Thicker
  stroke(255,0,0);//RED
  line(X1, Y1, X1, Y2);//Draw Left
  line(X2, Y1, X2, Y2);//Draw Right
  line(X1, Y1, X2, Y1);//Draw Top
  line(X1, Y2, X2, Y2);//Draw Bottom
  strokeWeight(1); // Default
  stroke(0);//BLACK
}//drawGroupPasteOutline() END

void drawTileGroupOutline(){//Draw Red Outline Showing Selected Area
  int X1,X2,Y1,Y2,asx2 = 0,asy2 = 0;//Setup Variables
    
  if(tileGroupStep == 1){//Are We On Step One
    asx2 = mouseX;//Corner is tied to mouse
    asy2 = mouseY;//Corner is tied to mouse
  }else if(tileGroupStep == 2){//Are We On Step Two
    asx2 = sx2;//Corner is tied to set XY
    asy2 = sy2;//Corner is tied to set XY
  }
    
  if(sx1 < asx2){//if x1 is less than x2
    X1 = (int)Math.floor(sx1 / scl) * scl;//Adjust XY To Be On Tile Border
    X2 = (int)Math.ceil(asx2 / scl) * scl;//Adjust XY To Be On Tile Border
  }else{//otherwise
    X2 = (int)Math.ceil(sx1 / scl) * scl;//Adjust XY To Be On Tile Border
    X1 = (int)Math.floor(asx2 / scl) * scl;//Adjust XY To Be On Tile Border
  }
  
  if(sy1 < asy2){//if y1 is less than y2
    Y1 = (int)Math.floor(sy1 / scl) * scl;//Adjust XY To Be On Tile Border
    Y2 = (int)Math.ceil(asy2 / scl) * scl;//Adjust XY To Be On Tile Border
  }else{//otherwise
    Y2 = (int)Math.ceil(sy1 / scl) * scl;//Adjust XY To Be On Tile Border
    Y1 = (int)Math.floor(asy2 / scl) * scl;//Adjust XY To Be On Tile Border
  }
    
  strokeWeight(borderThickness); // Thicker
  stroke(255,0,0);//RED
  line(X1, Y1, X1, Y2);//Draw Left
  line(X2, Y1, X2, Y2);//Draw Right
  line(X1, Y1, X2, Y1);//Draw Top
  line(X1, Y2, X2, Y2);//Draw Bottom
  strokeWeight(1); // Default
  stroke(0);//BLACK
}//drawTileGroupOutline() END