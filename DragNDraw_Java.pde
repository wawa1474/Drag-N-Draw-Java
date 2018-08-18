import controlP5.*;

//Started August 16, 2018 at ~4:30 PM

int _DEBUG_ = 0;
int _DEBUGAMOUNT_ = 50000;

int _FILEVERSION_ = 2;

boolean dragging = false;
boolean deleting = false;
boolean noTile = false;

boolean noKeyboard = false;

int mapN = 0;
int totalImages = 40 - 1;
int rowLength = 16;
int tileRow = 0;
int tileN = 1;
boolean CClear = false;

int fullTotalImages = ceil((float)totalImages / rowLength) * rowLength - 1;

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

int scrollAmount = 1;

PImage[] img = new PImage[0];//totalImages + 1];
mTile[] mapTiles = new mTile[0];//25000];
mTile[] mapTilesCopy = new mTile[0];
PImage BACKGROUND;
PImage missingTexture;

Table mapTable;
String fileName = "Map1";

ControlP5 UIControls;
Controller RSlider, GSlider, BSlider;
Controller scrollSlider;
Controller fileSaveMap, fileLoadMap, fileSaveCanvas;

tileUI UI = new tileUI();
canvasBG BG = new canvasBG();
int borderThickness = 4;

void preload(){
  PImage tileMap = loadImage("assets/tileMap.png");
  tileMap.loadPixels();
  
  for(int i = 0; i <= totalImages; i++){
    img = (PImage[]) expand(img, img.length + 1);
    img[i] = createImage(32, 32, RGB);
    img[i].loadPixels();
    for(int y = 0; y < 32; y++){
      for(int x = 0; x < 32; x++){
        img[i].set(x, y, tileMap.get(x + (scl * floor(i % 32)), y + (scl * floor(i / 32))));
      }
    }
    img[i].updatePixels();
  }
  
  missingTexture = loadImage("assets/missingTexture.png");
  
  println(totalImages + ": " + fullTotalImages);
  if(totalImages != fullTotalImages){
    for(int i = totalImages + 1; i <= fullTotalImages; i++){
      img = (PImage[]) expand(img, img.length + 1);
      img[i] = missingTexture;
    }
  }
  
  BACKGROUND = loadImage("assets/background.png");
}

void setup(){
  preload();
  
  size(960,540);//X, Y
  surface.setResizable(true);
  
  UIControls = new ControlP5(this);
  UI.setup();
  
  mapTiles = (mTile[]) expand(mapTiles, mapTiles.length + 1);
  mapTiles[mapTiles.length - 1] = new mTile(256,256,3,127,127,127,false);
}

void draw(){
  pushMatrix();
  translate(SX, SY);
  
  drawnTiles = 0;//reset number of drawn tiles

  updateXY();//Update the XY position of the mouse and the page XY offset
  
  BG.draw();//Draw the background and grid
  
  //If dragging a tile: update location
  if (dragging){//Are we dragging a tile
    if(mapTiles[mapN] != null){//If tile exists
      updateTileLocation(mapN);//Adjust XY location of tile
    }
  }
  
  //Display Map Tiles
  for(int i = 0; i < mapTiles.length; i++){//Go through all the tiles
    if(mapTiles[i].x > -scl - SX && mapTiles[i].x  < width - SX && mapTiles[i].y > -scl - SY && mapTiles[i].y < height - SY || drawAll == true){//if tile is within screen bounds or drawAll is set
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
  
  popMatrix();
  
  //Update and Draw the UI
  UI.update();//Update the UI position
  UI.draw();//Draw the UI
}

void mousePressed(){//We pressed a mouse button
  //updateXY();
  if(tileGroupStep == 3){//pasteing group of tiles
    if(mouseButton == LEFT){//We clicked with the left button
      tileGroupPaste();//paste group selection
      tileGroupStep = 0;//reset group selection step
      return;//Block normal action
    }
  }
  
  if(tileGroupStep == 2){//placing group of tiles
    if(mouseButton == LEFT){//We clicked with the left button
      tileGroup("left");//placing image tiles
      return;//Block normal action
    }else if(mouseButton == CENTER){//We clicked with the middle button
      for(int i = mapTiles.length-1; i >= 0; i--){//Loop through all tiles
        if(isCursorOnTile(i)){//Are we clicking on the tile
          tileGroupDeleting = true;//deleting group of tiles
          //break;
        }
      }//Went through all the tiles
      tileGroup("center");//placing colored tile
      return;//Block normal action
    }
  }
  
  if(mouseButton == RIGHT){//We clicked with the right button
    if(tileGroupStep == 2){//placing group of tiles
      tileGroup("right");//coloring group of tiles
    }else{//otherwise
      for(int i = 0; i <= mapTiles.length-1; i++){//Loop through all tiles
        if(isCursorOnTile(i)){//Are we clicking on the tile
          mapTiles[i].r = (int)RSlider.getValue();//set tile red value
          mapTiles[i].g = (int)GSlider.getValue();//set tile green value
          mapTiles[i].b = (int)BSlider.getValue();//set tile blue value
        }
      }//Went through all the tiles
    }
    return;//Block normal action
  }

  for(int i = 0; i < rowLength; i++){//Go through all the tiles in the row
    if(mX > scl*i - SX + fV && mX < scl*(i+1) - SX - fV && mY > 0 - SY + fV && mY < scl - SY - fV){//Are we clicking on the tile UI
      noTile = true;//Dont allow tile placement
      if(img[rowLength*tileRow+i] == null){return;}//if image doesn't exist return
      tileN = rowLength*tileRow+i;//Set the tile cursor to the tile we clicked on
      mapTiles = (mTile[]) expand(mapTiles, mapTiles.length + 1);
      mapTiles[mapTiles.length - 1] = new mTile(scl*i + pX - SX,0 + pY - SY,tileN,(int)RSlider.getValue(),(int)GSlider.getValue(),(int)BSlider.getValue(), CClear);//Create a tile
    }
  }//Went through all the tiles in the row
  
  if(mX > 0 - SX && mX < scl*UIRight - SX && mY > 0 /* scl */ - SY && mY < scl*UIBottom - SY){//Did we click on the UI
    noTile = true;//Dont allow tile placement
    //return;//Don't do anything else
  }

  // Did I click on the rectangle?
  for(int i = mapTiles.length-1; i >= 0; i--){//Go through all the tiles
    if(isCursorOnTile(i)){//Are we clicking on the tile
      if(mouseButton == CENTER){//We clicked with the middle button
        deleteTile(i);//Delete a tile and update the array
        mapN = -1;//We're not holding a tile
        deleting = true;//We're deleting
        return;//Block normal action
      }else if(mouseButton == LEFT && !CClear){//We clicked with the left button
        mapN = i;//Keep track of what tile we clicked on
        dragging = true;//We dragging
        updateOffset(i);//Update the mouse offset of the tile
        loadColors(i);//Load the color inputs and sliders with the color from the tile
        return;//Block normal action
      }/*else if(mouseButton == RIGHT){//We clicked with the right button
        mylog.log("Right");
        //loadTile(i);
        //updateTileRow();//Get the row to whatever tile were on
        //return false;
      }*/
    }
  }//Went through all the tiles
  
  placeTile();//Place a tile at current mouse position
}//mousePressed() END

void mouseDragged(){//We dragged the mouse while holding a button
  //updateXY();
  
  if(mouseButton == RIGHT){//We clicked with the right button
    for(int i = 0; i <= mapTiles.length-1; i++){//loop through all the tiles
      if(isCursorOnTile(i)){//Are we clicking on the tile
        mapTiles[i].r = (int)RSlider.getValue();//set tile red value
        mapTiles[i].g = (int)GSlider.getValue();//set tile green value
        mapTiles[i].b = (int)BSlider.getValue();//set tile blue value
      }
    }//Went through all the tiles
  }
  
  if(mouseButton == CENTER && deleting){//We dragging and deleting with the middle button
    for(int i = mapTiles.length-1; i >= 0; i--){//Go through all the tiles
      if(isCursorOnTile(i)){//Are we clicking on the tile
        deleteTile(i);//Delete a tile and update the array
        mapN = -1;//We're not holding a tile
      }
    }//Went through all the tiles
  }

  if(noTile){//We're not allowed to place tiles
    return;//Don't do anything else
  }

  if(dragging){//We're dragging
    return;//Block normal action
  }
  
  for(int i = mapTiles.length-1; i >= 0; i--){//Go through all the tiles
    /*Pad*/if(isCursorOnTile(i) && !checkImage(tileN)){//Are we clicking on the tile
      return;//Block normal action
    }else if(isCursorOnTile(i) && mouseButton == CENTER){//Are we clicking on the tile with the middle button
      return;//Block normal action
    }else if(isCursorOnTile(i) && !CClear){//Are we clicking on a clear tile
      return;//Block normal action
    }
  }//Went through all the tiles

  placeTile();//Place a tile at current mouse position
  
  //return false;
}//mouseDragged() END

void mouseReleased(){//We released the mouse button
  if(dragging){//Are we dragging a tile
    if(mapTiles[mapN] != null){//If tile exists
      snapTileLocation(mapN);//Snap XY location of tile to grid
    }
  }
  
  deleting = false;//Quit deleting
  dragging = false;//Quit dragging
  noTile = false;//Allow tile placement

  if(mapN != -1 && mapTiles.length > mapN){//If tile exists
    if(mapTiles[mapN].x >= pX && mapTiles[mapN].x < scl*rowLength + pX && mapTiles[mapN].y == pY){//Is the tile we just dropped on the UI
      deleteTile(mapN);//Delete a tile and update the array
      //return false;
    }
  }
}//mouseReleased() END

void mouseWheel(MouseEvent event){//We Scrolled The Mouse Wheel
  if(event.getCount() < 0){//If Scrolling Up
    nextTileC();//Move To Next Tile
  }else{
    prevTileC();//Move To Previous Tile
  }
}//mouseWheel(event) END

void keyPressed(){//We pressed a key
  if(noKeyboard == false){//are we blocking keyboard functions?
    //console.log(keyCode);//What key did we press?
    if (keyCode == /*SHIFT*/16){//We pressed shift
      prevRowC();//Previous Tile row
    }else if (keyCode == /*SPACE*/32){//We pressed space
      nextRowC();//Next Tile Row
    }
  }
}

void keyTyped(){//We typed a key
  if(noKeyboard == false){//are we blocking keyboard functions?
    /*if(key == 'q'){//We pressed 'Q'
      prevTileC();
    }else if(key == 'e'){//We pressed 'E'
      nextTileC();
    }else */if(key == 'f'){//We pressed 'F'
      if(CClear){//Is it currently clear?
        CClear = false;//Set if not clear
        //CCheckBox.checked(false);//Uncheck the checkbox
      }else{//Its not clear
        CClear = true;//Set it clear
        //CCheckBox.checked(true);//Check the checkbox
      }
    }else if(key == 'x'){//We pressed 'X'
      if(tileGroupStep == 2){//we're on step two of group selection
        tileGroupCutCopy('x');//cut group selection
      }
    }else if(key == 'c'){//We pressed 'C'
      if(tileGroupStep == 2){//we're on step two of group selection
        tileGroupCutCopy('c');//copy group selection
      }
    }else if(key == 'v'){//We pressed 'V'
      if(tileGroupStep != 3){
        tileGroupStep = 3;//paste step is 3
      }else if(tileGroupStep == 3){
        tileGroupStep = 0;//paste step is 3
      }
    }else if(key == 'i'){//We pressed 'I'
      for(int i = mapTiles.length-1; i >= 0; i--){//Go through all the tiles
        mapTiles[i].y -= scl * scrollAmount;//Move tile up 1 space
      }
    }else if(key == 'j'){//We pressed 'J'
      for(int i = mapTiles.length-1; i >= 0; i--){//Go through all the tiles
        mapTiles[i].x -= scl * scrollAmount;//Move tile left 1 space
      }
    }else if(key == 'k'){//We pressed 'K'
      for(int i = mapTiles.length-1; i >= 0; i--){//Go through all the tiles
        mapTiles[i].y += scl * scrollAmount;//Move tile down 1 space
      }
    }else if(key == 'l'){//We pressed 'L'
      for(int i = mapTiles.length-1; i >= 0; i--){//Go through all the tiles
        mapTiles[i].x += scl * scrollAmount;//Move tile right 1 space
      }
    }else if(key == 'r'){//We pressed 'R'
      for(int i = mapTiles.length-1; i >= 0; i--){//Go through all the tiles
        if(isCursorOnTile(i)){//Are we clicking on the tile
          println("Tile #: " + i + ", X Position: " + mapTiles[i].x + ", Y Position: " + mapTiles[i].y + ", Red Amount: " + mapTiles[i].r + ", Green Amount: " + mapTiles[i].g + ", Blue Amount: " + mapTiles[i].b + ", Tile Image #: " + mapTiles[i].image + ", Is Tile Clear: " + mapTiles[i].clear);// + ", Tile Lore: " + mapTiles[i].lore);
          //console.log('Tile #: ' + i + ', X Position: ' + mapTiles[i].x + ', Y Position: ' + mapTiles[i].y);
          //console.log('Red Amount: ' + mapTiles[i].r + ', Green Amount: ' + mapTiles[i].g + ', Blue Amount: ' + mapTiles[i].b);
          //console.log('Tile Image #: ' + mapTiles[i].image + ', Is Tile Clear: ' + mapTiles[i].clear);
          //console.log('Tile Lore: ' + mapTiles[i].lore);
        }
      }
    }else if(key == 'q'){//We pressed 'P'
      //tileGroup(scl * 10, scl * 3, scl * 5, scl * 10)
      if(tileGroupStep == 0){//set XY1
        tileGroupStep = 1;//ready for next step
        sx1 = mouseX - SX;//set x1 to mouse x position
        sy1 = mouseY - SY;//set y1 to mouse y position
      }else if (tileGroupStep == 1){//set XY2
        tileGroupStep = 2;//ready to do group tiles stuff
        sx2 = mouseX - SX;//set x1 to mouse x position
        sy2 = mouseY - SY;//set y2 to mouse y position
      }
    }/*else if(key == 'm'){//We pressed 'm'
      selectOutput("Select a CSV to write to:", "FileSaveMapSelect");
      //FileSaveMap();
    }else if(key == 'n'){
      selectInput("Select a CSV to read from:", "FileLoadMapSelect");
      //FileLoadMap();
    }else if(key == 'b'){
      selectOutput("Select a PNG to write to:", "FileSaveCanvasSelect");
      //FileSaveCanvas();
    }*/
    
    if(key == 'w'){//We pressed 'W'
      if(SY < scl * 5){
        SY += /*window.pageYOffset - */(scl * scrollAmount);//Scroll Screen UP
      }
      if(SY > scl * 5){
        SY = scl * 5;
      }
    }
    if(key == 'a'){//We pressed 'A'
      if(SX < scl * 5){
        SX += /*window.pageXOffset - */(scl * scrollAmount);//Scroll Screen LEFT
      }
      if(SX > scl * 5){
        SX = scl * 5;
      }
    }
    if(key == 's'){//We pressed 'S'
      if(SY > -((scl * 105) - height)){
        SY -= /*window.pageYOffset + */(scl * scrollAmount);//Scroll Screen RIGHT
      }
      if(SY < -((scl * 105) - height)){
        SY = -((scl * 105) - height);
      }
    }
    if(key == 'd'){//We pressed 'D'
      if(SX > -((scl * 105) - width)){
        SX -= /*window.pageXOffset + */(scl * scrollAmount);//Scroll Screen DOWN
      }
      if(SX < -((scl * 105) - width)){
        SX = -((scl * 105) - width);
      }
    }
  }
}//keyTyped() END

class tileUI{
  void draw(){
    fill(RSlider.getValue(),GSlider.getValue(),BSlider.getValue());//Set background color to the RGB value set by user
    rect(scl * 3, scl, scl, scl);//Display color behind RGB Sliders
    
    fill(255);//Set background color to white
    rect(0, 0, scl*rowLength, scl);//Create rectangle behind tiles UI
    for(int i = 0; i < rowLength; i++){//Go through all the tiles
      if((rowLength*tileRow)+i <= fullTotalImages){//If tile exists
        if((rowLength*tileRow)+i == tileN){//If displaying selected tile
          fill(RSlider.getValue(),GSlider.getValue(),BSlider.getValue());//Set background color to the RGB value set by user
          rect(scl*i, 0, scl, scl);//Display color behind the tile
        }
        image(img[rowLength*tileRow+i], scl*i, 0);//Draw tile
      }
    }//Went through all the tiles
    
    fill(255,0,0);//red text
    stroke(0);//no outline
    textSize(24);//larger text size
    //String FPS = String.valueOf(frameRate);
    //text("FPS: " + FPS.substring(0, 4), ((scl * 12) + scl / 8), (scl * 1.75));//FPS: (fps.fp)
    
    text("Tiles: " + mapTiles.length, ((scl * 16) + scl / 8), (scl / 1.25));//Tiles: (tiles)
  
    text("Drawn: " + drawnTiles, ((scl * 16) + scl / 8), (scl * 1.75));//Drawn: (drawn)
    textSize(12);//Default text size
  }
  
  void update(){
    scrollAmount = (int)scrollSlider.getValue();
  }
  
  void setup(){
    UIControls.addSlider("RSlider").setDecimalPrecision(0).setPosition(0,scl + 1.3).setSliderMode(Slider.FLEXIBLE).setSize(scl * 3,10).setRange(0,255).setValue(127).setCaptionLabel("");
    UIControls.addSlider("GSlider").setDecimalPrecision(0).setPosition(0,scl + 12.3).setSliderMode(Slider.FLEXIBLE).setSize(scl * 3,10).setRange(0,255).setValue(127).setCaptionLabel("");
    UIControls.addSlider("BSlider").setDecimalPrecision(0).setPosition(0,scl + 23.3).setSliderMode(Slider.FLEXIBLE).setSize(scl * 3,10).setRange(0,255).setValue(127).setCaptionLabel("");
    RSlider = UIControls.getController("RSlider");
    GSlider = UIControls.getController("GSlider");
    BSlider = UIControls.getController("BSlider");
    
    UIControls.addSlider("scrollSlider").setDecimalPrecision(0).setPosition(scl * 4,scl).setSliderMode(Slider.FLEXIBLE).setSize(scl * 2,scl).setRange(1,10).setValue(5).setCaptionLabel("");
    scrollSlider = UIControls.getController("scrollSlider");
    
    UIControls.addButtonBar("fileSaveLoad").addItems(split("Save Load Image", " ")).setSize(scl * 4, scl).setPosition(scl * 7,scl);
    fileSaveMap = UIControls.getController("fileSaveLoad");
  }
}

void fileSaveLoad(int n){
  //println(n);
  if(n == 0){
    selectOutput("Select a CSV to write to:", "FileSaveMapSelect");
  }else if(n == 1){
    selectInput("Select a CSV to read from:", "FileLoadMapSelect");
  }else if(n == 2){
    selectOutput("Select a PNG to write to:", "FileSaveCanvasSelect");
  }else{
    println("Button Does Not Exist");
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

void updateXY(){//Update the XY position of the mouse and the page XY offset
  mX = mouseX - SX;//Update the X position of the mouse
  mY = mouseY - SY;//Update the Y position of the mouse
  //pX = window.pageXOffset;//Update the page X offset
  //pY = window.pageYOffset;//Update the page Y offset
  pX = SX;
  pY = SY;
}//updateXY() END

void deleteTile(int tile){//Delete a tile and update the array
  if(mapTiles.length > 0){//If there is more than 1 tile
    if(mapTiles.length > 1){
      for(int i = tile; i < mapTiles.length - 1; i++){//Go through all tiles after the one we're deleting
        mapTiles[i] = mapTiles[i + 1];//Shift the tile down 1
      }
    }
    mapTiles = (mTile[]) shorten(mapTiles);//Shorten the Map Tiles Array by 1
  }
}//deleteTile() END

void placeTile(){//Place a tile at the mouses location
  //print(mouseButton);
  if(mY > scl*UIBottom - SY + fV && mY < (height - (scl*1.5)) - SY + fV && mX < (width - (scl)) - SX + fV){//We're not on the UI and we're within the screen bounds
    if(mouseButton == CENTER && !deleting){//We're dragging with the middle button and not deleting
      mapTiles = (mTile[]) expand(mapTiles, mapTiles.length + 1);
      mapTiles[mapTiles.length - 1] = new mTile(floor(mX/scl)*scl,floor(mY/scl)*scl,tileBorderNumber,(int)RSlider.getValue(),(int)GSlider.getValue(),(int)BSlider.getValue(), false);//Place a colored tile with no image
    }else if(mouseButton == LEFT){//We're dragging with the left button
      //print(mouseButton);
      mapTiles = (mTile[]) expand(mapTiles, mapTiles.length + 1);
      mapTiles[mapTiles.length - 1] = new mTile(floor(mX/scl)*scl,floor(mY/scl)*scl,tileN,(int)RSlider.getValue(),(int)GSlider.getValue(),(int)BSlider.getValue(), CClear);//Place a tile
    }else if(mouseButton == RIGHT){//We clicked with the right button
      //mapTiles[mapTiles.length] = new mTile(Math.floor(mX/scl)*scl,Math.floor(mY/scl)*scl,tileN,RSlider.value(),GSlider.value(),BSlider.value(), CClear);//Place a tile
    }
  }
}//placeTile() END

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
    tileN = fullTotalImages;//Loop the tile number back to the last tile
    tileRow = floor(fullTotalImages/rowLength);//Loop the tile row back to the last row
  }
  if(tileN < rowLength*tileRow){//Is the tile number less than the lower end of the current row?
    tileRow--;//Decrement the tile row
    if(tileRow < 0){//Is the tile number less than zero?
      tileRow = floor(fullTotalImages/rowLength);//Loop the tile row back to the last row
    }
  }
}//prevTileC() END

void updateTileRow(){//Get the row to whatever tile were on
  while(floor(tileN/rowLength)*rowLength < rowLength*tileRow){//Is tileN lower than the row were on?
      tileRow--;//Decrement tileRow
      if(tileRow < 0){//Is the tile number less than zero?
        tileRow = floor(fullTotalImages/rowLength);//Loop the tile row back to the last row
      }
    }
    while(floor(tileN/rowLength)*rowLength > rowLength*tileRow){//Is tileN higher than the row were on?
      tileRow++;//Increment tileRow
      if(tileRow > fullTotalImages/rowLength){//Is the tile row greater than our total number of rows?
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
    tileRow = floor(fullTotalImages / rowLength);//Loop the row number back to the last
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
  mapTiles[tile].x = floor(mouseX / scl) * scl - SX;//Adjust X location of tile
  mapTiles[tile].y = floor(mouseY / scl) * scl - SY;//Adjust Y location of tile
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

void loadColors(int tile){//Load RGB Sliders and RGB Inputs with value from tile
  RSlider.setValue(mapTiles[tile].r);//Set Red Slider value to Red value of the tile
  GSlider.setValue(mapTiles[tile].g);//Set Green Slider value to Green value of the tile
  BSlider.setValue(mapTiles[tile].b);//Set Blue Slider value to Blue value of the tile
}//loadColors() END

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
        mapTiles = (mTile[]) expand(mapTiles, mapTiles.length + 1);
        mapTiles[mapTiles.length - 1] = new mTile(X1 + (scl * j),Y1 + (scl * i),tileN,(int)RSlider.getValue(),(int)GSlider.getValue(),(int)BSlider.getValue(), CClear);//Place a tile
      }else if(button == "center" && tileGroupDeleting == true){//we clicked middle button on a tile
        for(int k = 0; k <= mapTiles.length - 1; k++){//loop through all tiles
          if(isCursorOnTileXY(k, (X1 + (scl * j)) + 4, (Y1 + (scl * i)) + 4)){//Are we clicking on the tile
            deleteTile(k);//delete the tile
            k--;//We need to recheck that tile
          }
        }
      }else if(button == "center"){//we clicked middle button
        mapTiles = (mTile[]) expand(mapTiles, mapTiles.length + 1);
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
}//placeTile() END

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
  
  tileGroupXLines = (X2 - X1) / scl;//how many x lines
  tileGroupYLines = (Y2 - Y1) / scl;//how many y lines
  
  for(int i = 0; i < tileGroupYLines; i++){//loop through all y lines
    for(int j = 0; j < tileGroupXLines; j++){//loop through all x lines
      hadTile = false;//square does not have tile
      if(button == 'x'){//we clicked middle button on a tile
        for(int k = 0; k <= mapTiles.length-1; k++){//loop through all tiles
          if(isCursorOnTileXY(k, (X1 + (scl * j)) + 4, (Y1 + (scl * i)) + 4)){//Are we clicking on the tile
            mapTilesCopy = (mTile[]) expand(mapTilesCopy, mapTilesCopy.length + 1);
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
            mapTilesCopy = (mTile[]) expand(mapTilesCopy, mapTilesCopy.length + 1);
            mapTilesCopy[tileCount] = mapTiles[k];//copy the tile
            tileCount++;//next tile
            hadTile = true;//square has tile
          }
        }
      }
      if(hadTile == false){//if square did not have tile
        mapTilesCopy = (mTile[]) expand(mapTilesCopy, mapTilesCopy.length + 1);
        mapTilesCopy[tileCount] = null;//insert null tile
        tileCount++;//next tile
      }
    }
  }
  tileGroupStep = 0;//reset step count
}//tileGroupCutCopy() END

void tileGroupPaste(){//Paste The Copied Tiles
  int X1,Y1;//Setup Variables
  int tileCount = 0;//how many tiles are there
  
  X1 = floor((mouseX - (floor(tileGroupXLines / 2) * scl)) / scl) * scl - SX;//Adjust XY To Be On Tile Border
  Y1 = floor((mouseY - (floor(tileGroupYLines / 2) * scl)) / scl) * scl - SY;//Adjust XY To Be On Tile Border
  
  for(int i = 0; i < tileGroupYLines; i++){//loop through all y lines
    for(int j = 0; j < tileGroupXLines; j++){//loop through all x lines
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
}//tileGroupPaste() END

void drawGroupPasteOutline(){//Draw Red Outline Showing Amount Of Tiles To Be Placed
  int X1,X2,Y1,Y2;//Setup Variables
  
  X1 = floor((mouseX - (floor(tileGroupXLines / 2) * scl)) / scl) * scl - SX;//Adjust XY To Be On Tile Border
  X2 = (floor((mouseX + (ceil((float)tileGroupXLines / 2) * scl)) / scl) * scl) - SX;//Adjust XY To Be On Tile Border
  Y1 = floor((mouseY - (floor(tileGroupYLines / 2) * scl)) / scl) * scl - SY;//Adjust XY To Be On Tile Border
  Y2 = (floor((mouseY + (ceil((float)tileGroupYLines / 2) * scl)) / scl) * scl) - SY;//Adjust XY To Be On Tile Border
  
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
}//drawGroupPasteOutline() END

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
}//drawTileGroupOutline() END

void FileSaveCanvasSelect(File selection){
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    fileName = selection.getAbsolutePath();
    FileSaveCanvas();
  }
}

void FileSaveMapSelect(File selection){
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    fileName = selection.getAbsolutePath();
    FileSaveMap();
  }
}

void FileLoadMapSelect(File selection){
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    fileName = selection.getAbsolutePath();
    FileLoadMap();
  }
}

void FileSaveCanvas(){//Save the Canvas to a file
  int lowX = scl * cols;
  int highX = 0;
  int lowY = scl * rows;
  int highY = 0;
  
  for(int i = 0; i < mapTiles.length; i++){//Go through all the tiles
    if(mapTiles[i].x < lowX){
      lowX = mapTiles[i].x;
    }
    if(mapTiles[i].x > highX){
      highX = mapTiles[i].x;
    }
    if(mapTiles[i].y < lowY){
      lowY = mapTiles[i].y;
    }
    if(mapTiles[i].y > highY){
      highY = mapTiles[i].y;
    }
  }//Went through all the tiles

  PGraphics fullCanvas = createGraphics(highX - lowX + scl, highY - lowY + scl);
  fullCanvas.beginDraw();
  fullCanvas.image(BACKGROUND, 0, 0);//Draw the background
  //Display Map Tiles
  for(int i = 0; i < mapTiles.length; i++){//Go through all the tiles
    if(!mapTiles[i].clear){//Is the tile colored
      fullCanvas.fill(mapTiles[i].r,mapTiles[i].g,mapTiles[i].b);//Set Tile background color
      fullCanvas.rect(mapTiles[i].x - lowX,mapTiles[i].y - lowY,scl,scl);//Draw colored square behind tile
    }
    fullCanvas.image(img[mapTiles[i].image], mapTiles[i].x - lowX, mapTiles[i].y - lowY);//Draw tile
  }//Went through all the tiles
  fullCanvas.endDraw();
  fullCanvas.save(fileName);// + ".png");//Save the map to a PNG file
}//FileSaveCanvas() END

void FileSaveMap(){//Save the Map to file
  mapTable = new Table();//create new p5 table
  mapTable.addColumn("x");//Tile X position
  mapTable.addColumn("y");//Tile Y position
  mapTable.addColumn("image");//Tile Image
  mapTable.addColumn("r");//Tile Red amount
  mapTable.addColumn("g");//Tile Green amount
  mapTable.addColumn("b");//Tile Blue amount
  mapTable.addColumn("clear");//Is Tile Clear
  //mapTable.addColumn('lore');//Tile LORE?
  TableRow newRow;
  
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////FILE METADATA
  newRow = mapTable.addRow();//Add a row to table
  newRow.setInt("x",_FILEVERSION_);//File Version
  newRow.setInt("y",0);//blank
  newRow.setInt("image",0);//blank
  newRow.setInt("r",0);//blank
  newRow.setInt("g",0);//blank
  newRow.setInt("b",0);//blank
  newRow.setInt("clear",0);//blank
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////FILE METADATA
  
  /*if(_FILEVERSION_ == 0){
    for(int i = 0; i <= mapTiles.length - 1; i++){//loop through all tiles
      newRow = mapTable.addRow();//Add a row to table
      newRow.setInt("x",floor(mapTiles[i].x / scl));//Tile X position
      newRow.setInt("y",floor(mapTiles[i].y / scl));//Tile Y position
      newRow.setInt("image",mapTiles[i].image);//Tile Image
      newRow.setInt("r",floor(mapTiles[i].r / scl));//Tile Red amount
      newRow.setInt("g",floor(mapTiles[i].g / scl));//Tile Green amount
      newRow.setInt("b",floor(mapTiles[i].b / scl));//Tile Blue amount
      int CLEAR = 1;//tile is clear
      if(!mapTiles[i].clear){//Is Tile Clear
        CLEAR = 0;//tile is not clear
      }
      newRow.setInt("clear",CLEAR);//Is Tile Clear
      //newRow.set('lore',mapTiles[i].lore);//Tile LORE?
    }
  }else if(_FILEVERSION_ == 1){
    for(int i = 0; i <= mapTiles.length - 1; i++){//loop through all tiles
      newRow = mapTable.addRow();//Add a row to table
      newRow.setInt("x",floor(mapTiles[i].x));//Tile X position
      newRow.setInt("y",floor(mapTiles[i].y));//Tile Y position
      newRow.setInt("image",mapTiles[i].image);//Tile Image
      newRow.setInt("r",floor(mapTiles[i].r));//Tile Red amount
      newRow.setInt("g",floor(mapTiles[i].g));//Tile Green amount
      newRow.setInt("b",floor(mapTiles[i].b));//Tile Blue amount
      int CLEAR = 1;//tile is clear
      if(!mapTiles[i].clear){//Is Tile Clear
        CLEAR = 0;//tile is not clear
      }
      newRow.setInt("clear",CLEAR);//Is Tile Clear
      //newRow.set('lore',mapTiles[i].lore);//Tile LORE?
    }
  }else */if(_FILEVERSION_ == 2){
    for(int i = 0; i <= mapTiles.length - 1; i++){//loop through all tiles
      newRow = mapTable.addRow();//Add a row to table
      newRow.setInt("x",floor(mapTiles[i].x / scl));//Tile X position
      newRow.setInt("y",floor(mapTiles[i].y / scl));//Tile Y position
      newRow.setInt("image",mapTiles[i].image);//Tile Image
      newRow.setInt("r",floor(mapTiles[i].r));//Tile Red amount
      newRow.setInt("g",floor(mapTiles[i].g));//Tile Green amount
      newRow.setInt("b",floor(mapTiles[i].b));//Tile Blue amount
      int CLEAR = 1;//tile is clear
      if(!mapTiles[i].clear){//Is Tile Clear
        CLEAR = 0;//tile is not clear
      }
      newRow.setInt("clear",CLEAR);//Is Tile Clear
      //newRow.set('lore',mapTiles[i].lore);//Tile LORE?
    }
  }else{
    println("File Version Error (Saving).");//throw error
  }
  saveTable(mapTable, fileName);// + ".csv");//Save the Map to a CSV file
  mapTable = null;//Clear the Table
}//FileSaveMap() END

void FileLoadMap(){//load map from file
  //noLoop();
  mapTable = loadTable(fileName, "header");// + ".csv", "header");//Load the csv
  
  while(mapTiles.length > 0){//Clear the array
    deleteTile(0);
  }
  
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////FILE METADATA
  int fileVersion = int(mapTable.getInt(0,"x"));//File Version
  //int(mapTable.get(0,'y'));//blank
  //int(mapTable.get(0,'image'));//blank
  //int(mapTable.get(0,'r'));//blank
  //int(mapTable.get(0,'g'));//blank
  //int(mapTable.get(0,'b'));//blank
  //int(mapTable.get(0,'clear'));//blank
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////FILE METADATA
  
  if(fileVersion == 0){//whats the file version
    for(int i = 1; i < mapTable.getRowCount(); i++){//Loop through all the rows
      boolean CLEAR = true;//tile is clear
      if(mapTable.getInt(i,"clear") == 0){//Is Tile Clear
        CLEAR = false;//tile is not clear
      }
      mapTiles = (mTile[]) expand(mapTiles, mapTiles.length + 1);
      mapTiles[i - 1] = new mTile(mapTable.getInt(i,"x") * scl,//Tile X position
                              mapTable.getInt(i,"y") * scl,//Tile Y position
                              mapTable.getInt(i,"image"),//Tile Image
                              mapTable.getInt(i,"r") * scl,//Tile Red amount
                              mapTable.getInt(i,"g") * scl,//Tile Green amount
                              mapTable.getInt(i,"b") * scl,//Tile Blue amount
                              CLEAR);//,//Is Tile Clear
                              //mapTable.get(i,'lore'));//Tile LORE?
    }
  }else if(fileVersion == 1){//whats the file version
    for(int i = 1; i < mapTable.getRowCount(); i++){//Loop through all the rows
      boolean CLEAR = true;//tile is clear
      if(mapTable.getInt(i,"clear") == 0){//Is Tile Clear
        CLEAR = false;//tile is not clear
      }
      mapTiles = (mTile[]) expand(mapTiles, mapTiles.length + 1);
      mapTiles[i - 1] = new mTile(mapTable.getInt(i,"x"),//Tile X position
                              mapTable.getInt(i,"y"),//Tile Y position
                              mapTable.getInt(i,"image"),//Tile Image
                              mapTable.getInt(i,"r"),//Tile Red amount
                              mapTable.getInt(i,"g"),//Tile Green amount
                              mapTable.getInt(i,"b"),//Tile Blue amount
                              CLEAR);//,//Is Tile Clear
                              //mapTable.get(i,'lore'));//Tile LORE?
    }
  }else if(fileVersion == 2){//whats the file version
    for(int i = 1; i < mapTable.getRowCount(); i++){//Loop through all the rows
      boolean CLEAR = true;//tile is clear
      if(mapTable.getInt(i,"clear") == 0){//Is Tile Clear
        CLEAR = false;//tile is not clear
      }
      mapTiles = (mTile[]) expand(mapTiles, mapTiles.length + 1);
      mapTiles[i - 1] = new mTile(mapTable.getInt(i,"x") * scl,//Tile X position
                              mapTable.getInt(i,"y") * scl,//Tile Y position
                              mapTable.getInt(i,"image"),//Tile Image
                              mapTable.getInt(i,"r"),//Tile Red amount
                              mapTable.getInt(i,"g"),//Tile Green amount
                              mapTable.getInt(i,"b"),//Tile Blue amount
                              CLEAR);//,//Is Tile Clear
                              //mapTable.get(i,'lore'));//Tile LORE?
    }
  }else{//we don't know that file version
    println("File Version Error (Loading).");//throw error
  }
  
  if(mapTiles == null){//Is the array null
    while(mapTiles.length > 0){//Reset the map array
      deleteTile(0);
    }
  }
  //loop();
}//FileLoadMap() END