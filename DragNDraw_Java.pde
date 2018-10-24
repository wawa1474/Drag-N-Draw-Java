import controlP5.*;//import the library

//Drag N' Draw Javascript Started April 9th, 2018 at 11:13:08am
//Drag N' Draw Java Started August 16, 2018 at ~4:30 PM

int _DEBUG_ = 0;//what are we debugging
int _DEBUGAMOUNT_ = 50000;//how many are we debugging

int _FILEVERSION_ = 2;//what version of file saving and loading

//File Version Map
  //Version 0:
    //0 = File MetaData
    //Compressed Color/Position Tile Data
  
  //Version 1:
    //0 = File MetaData
    //No Compression
  
  //Version 2:
    //0 = File MetaData
    //Compressed Position

boolean dragging = false;// Is a tile being dragged?
boolean deleting = false;//Are we deleting tiles?
boolean noTile = false;//Are we blocking placement of tiles?

boolean noKeyboard = false;//Are We Blocking keyTyped() and keyPressed()?

int mapN = 0;//Which map peice are we messing with
int totalImages = 32 * 4 - 1;//Total Images
int rowLength = 16;//How many tiles per row?
int tileRow = 0;//Which row of tiles are we looking at?
int tileN = 1;//Which tile is the cursor over?
boolean CClear = false;//Ar ewe placing clear tiles

int fullTotalImages = ceil((float)totalImages / rowLength) * rowLength - 1;//make sure all tile rows are full

int drawnTiles = 0;//how many tiles are on the screen
boolean drawAll = false;//draw all tiles even if not on screen?

int tileGroupStep = 0;//what step are we in setting tile group
boolean tileGroupDeleting = false;//are we deleting the tile group
int sx1, sy1, sx2, sy2;//tileGroup XY corners
int tileGrouSXLines = 0;//how many X lines of copied tiles
int tileGrouSYLines = 0;//how many Y lines of copied tiles

int tileBorderNumber = 0;//What number in img[] is the border (its just a null tile)

int offsetX = 0, offsetY = 0;//Mouseclick offset

int scl = 32;//Square Scale

int cols = 100;//Columns
int rows = 100;//Rows

int SX = 0, SY = 0;//Screen XY
int mX = 0, mY = 0;//Mouse XY
int fV = 1;//Fudge Value
int UIRight = 22;//How many tiles long is the UI?
int UIBottom = 2;//How many tiles tall is the UI?

int scrollAmount = 1;//How many squares to scroll when pressing WASD

PImage[] img = new PImage[0];//Tile Images Array
mTile[] mapTiles = new mTile[0];//Map Tiles Array
mTile[] mapTilesCopy = new mTile[0];//copied tiles
PImage BACKGROUND;//background image
PImage missingTexture;//missingTexture Image

Table mapTable;//Map Table
String fileName = "Error";//File Name

ControlP5 UIControls;//ui controls
Controller RSlider, GSlider, BSlider;//sliders
Controller scrollSlider;//slider
ButtonBar fileSaveLoad;//button bar
Controller colorSelect, colorInput;//buttons
Controller colorInputR, colorInputG, colorInputB;//number input
Controller colorWheel;//color whee;
Controller clearToggle;//button

tileUI UI = new tileUI();//Create a UI
boolean UISetup = false;//Are we setting up the ui?
canvasBG BG = new canvasBG();//Create a background
int borderThickness = 4;//how thick is the canvas border

Table tileInfoTable;//tile map info table
PImage[] tileMaps = new PImage[0];//tile maps images
boolean preloading = true;//are we preloading
boolean prepreloading = true;//are we prepreloading
int tileMapShow = 0;//display which tile map
String tileMapLocation = "assets/tileMap.png";//wheres the tilemap located
boolean loadMapLocaion = false;//load tile map location
int tileMapHeight = 32;//how tiles high
int tileMapWidth = 32;//how many tile wide
int tileMapTileX = 32;//tile width
int tileMapTileY = 32;//tile height
String tileMapName = "Classic";//tile map name
Controller loadMap;//button
boolean loadingTileMap = true;//are we loading the tile map

void preload(){//Preload all of the images
  //FileLoadTileInfo();
  PImage tileMap = loadImage(tileMapLocation);//load the tile map image
  tileMap.loadPixels();//load the images pixels
  
  for(int i = 0; i < img.length; i++){//delete all the images
    img = (PImage[]) shorten(img);//Shorten the Tile Images Array by 1
  }
  
  for(int i = 0; i <= totalImages; i++){//Go through all the images
    img = (PImage[]) expand(img, img.length + 1);//make sure we have room
    img[i] = createImage(32, 32, ARGB);//create a new image
    img[i].loadPixels();//load the images pixels
    for(int y = 0; y < 32; y++){//for tile height
      for(int x = 0; x < 32; x++){//for tile width
        img[i].set(x, y, tileMap.get(x + (scl * floor(i % tileMapWidth)), y + (scl * floor(i / tileMapHeight))));//set pixel
      }
    }
    img[i].updatePixels();//update the image pixels
  }
  
  missingTexture = loadImage("assets/missingTexture.png");//load missing texture image
  
  println(totalImages + ": " + fullTotalImages);
  if(totalImages != fullTotalImages){//is there empty sapce
    for(int i = totalImages + 1; i <= fullTotalImages; i++){//fill the empty space
      img = (PImage[]) expand(img, img.length + 1);//make sure we have room
      img[i] = missingTexture;//make the empty spaces be missing textures
    }
  }
  
  BACKGROUND = loadImage("assets/background.png");//load background image
}//void preload() END

void FileLoadTileInfo(){//load map from file
  tileInfoTable = loadTable("assets/tileMapInfo.csv", "header, csv");// + ".csv", "header");//Load the csv
  
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////FILE METADATA
  int fileVersion = int(tileInfoTable.getInt(0,"location"));//File Version
  //int(mapTable.get(0,'y'));//blank
  //int(mapTable.get(0,'image'));//blank
  //int(mapTable.get(0,'r'));//blank
  //int(mapTable.get(0,'g'));//blank
  //int(mapTable.get(0,'b'));//blank
  //int(mapTable.get(0,'clear'));//blank
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////FILE METADATA
  
  if(fileVersion == 0){//whats the file version
    for(int i = 1; i < tileInfoTable.getRowCount(); i++){//Loop through all the rows
      tileMaps = (PImage[]) expand(tileMaps, tileMaps.length + 1);//make sure we have room
      tileMaps[tileMaps.length - 1] = loadImage(tileInfoTable.getString(i,"location"));//load tile map image
      println(tileInfoTable.getString(i,"location") + ", " +//Tile X position
                              tileInfoTable.getInt(i,"tileMapHeight") + ", " +//Tile Y position
                              tileInfoTable.getInt(i,"tileMapWidth") + ", " +//Tile Image
                              tileInfoTable.getInt(i,"tileMapTileX") + ", " +//Tile Red amount
                              tileInfoTable.getInt(i,"tileMapTileY") + ", " +//Tile Red amount
                              tileInfoTable.getInt(i,"images") + ", " +//Tile Red amount
                              tileInfoTable.getString(i,"name"));//,//Is Tile Clear
      if(tileMapName.equals(tileInfoTable.getString(i,"name"))){//does the map name and tile map name match
        tileMapLocation = tileInfoTable.getString(i,"location");//update tile map location
        tileMapHeight = tileInfoTable.getInt(i,"tileMapHeight");//how tiles high
        tileMapWidth = tileInfoTable.getInt(i,"tileMapWidth");//how many tile wide
        //tileMapTileX = 32;//tile width
        //tileMapTileY = 32;//tile height
      }
    }
  }else{//we don't know that file version
    println("File Version Error (Loading).");//throw error
  }
  //image(tileMaps[1],0,0);
}//FileLoadMap() END

void setup(){//Setup everything
  size(960,540);//make a canvas (X, Y)
  surface.setResizable(true);//allow resizing of the window
  
  FileLoadTileInfo();//load tile map info file
  //preload();
  
  UIControls = new ControlP5(this);//set up all the control stuff
  UI.setup();//Setup all of the UI stuff
  
  //changeVisibility(false);
  
  //mapTiles = (mTile[]) expand(mapTiles, mapTiles.length + 1);
  //mapTiles[mapTiles.length - 1] = new mTile(256,256,3,127,127,127,false);
}//void setup() END

void loadMap(){//called when loadMap is pressed
  if(loadingTileMap == true){//if loading tile map
    noLoop();//don't allow drawing
    loadMapLocaion = true;//make sure to update the map location
    selectInput("Select a CSV to read from:", "FileLoadMapSelect");//load a map
    println("File Selected!");
    while(prepreloading == true){delay(500);}//small delay
    println("File Loaded");
    FileLoadTileInfo();//load tile map info file
    preload();//preload stuff
    tileN = 1;//make sure we're on the first tile
    noTile = false;//allowed to place tiles
    changeVisibility(false);//normal screen
    loadingTileMap = false;//not loading tile map
    preloading = false;//no longer preloading
    loop();//allow drawing
  }else{
    preloading = true;//now preloading
    prepreloading = true;//now prepreloading
    UISetup = false;//ui is setup
    loadingTileMap = true;//loading tile map
    changeVisibility(true);//tile map loading screen
  }
}//void loadMap() END

void changeVisibility(boolean visibility){//change screen
  if(visibility){//are we going to the tile map loading screen
    loadMap.setPosition(scl * 5, 0);//change position
    loadMap.setLabel("Load Map");//change label
    
    fileSaveLoad.setPosition(0,0);//change position
    fileSaveLoad.changeItem("Save","text","Prev");//"Prev Next Load"
    fileSaveLoad.changeItem("Load","text","Next");//"Prev Next Load"
    fileSaveLoad.changeItem("Image","text","Load");//"Prev Next Load"
    
    clearToggle.setVisible(false);//clearToggle is not visible
    colorInput.setVisible(false);//colorInput is not visible
    colorSelect.setVisible(false);//colorSelect is not visible
    scrollSlider.setVisible(false);//scrollSlider is not visible
    RSlider.setVisible(false);//RSlider is not visible
    GSlider.setVisible(false);//GSlider is not visible
    BSlider.setVisible(false);//BSlider is not visible
  }else{
    loadMap.setPosition(scl * 14, scl);//change position
    loadMap.setLabel("Change Tileset");//change label
    
    fileSaveLoad.setPosition(scl * 7,scl);//change position
    fileSaveLoad.changeItem("Save","text","Save");//"Save Load Image"
    fileSaveLoad.changeItem("Load","text","Load");//"Save Load Image"
    fileSaveLoad.changeItem("Image","text","Image");//"Save Load Image"
    
    clearToggle.setVisible(true);//clearToggle is visible
    colorInput.setVisible(true);//colorInput is visible
    colorSelect.setVisible(true);//colorSelect is visible
    scrollSlider.setVisible(true);//scrollSlider is visible
    RSlider.setVisible(true);//RSlider is visible
    GSlider.setVisible(true);//GSlider is visible
    BSlider.setVisible(true);//BSlider is visible
  }
}//void changeVisibility(boolean visibility) END

void draw(){//Draw the canvas
  if(preloading == true){//if preloading
    pushMatrix();//go back to crazy space?
    background(255);//white background
    translate(SX, SY);//shift screen around
    image(tileMaps[tileMapShow],0,scl);//display tile map
    //image(tileMaps[0],tileMaps[1].width,scl);
    fill(0);//black box
    rect(scl * 11.5 - SX, 0 - SY, scl * 5, scl);//text box background
    fill(255);//white text
    text(tileInfoTable.getString(tileMapShow + 1,"name"), scl * 12 - SX, scl / 2 - SY);//display tile map name
    popMatrix();//go back to normal space?
  }else{
    if(UISetup == false){//is ui not setup
      //preload();
      //changeVisibility(true);
      //UI.setup();
      UISetup = true;//ui is setup
    }
  
  if(colorWheel.isVisible() || colorInputR.isVisible()){//if not using color wheel or color inputs
    noTile = true;//Allow tile placement
  }
  
  pushMatrix();//go back to crazy space?
  translate(SX, SY);//shift screen around
  
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
  
  stroke(255,0,0);
  //rect(scl * 5, scl * 5, scl, scl);
  strokeWeight(borderThickness); // Thicker
  line(scl * 5, scl * 5, scl * 5 + scl, scl * 5);
  line(scl * 5, scl * 5, scl * 5, scl * 5 + scl);
  line(scl * 5, scl * 5 + scl, scl * 5 + scl, scl * 5 + scl);
  line(scl * 5 + scl, scl * 5 + scl, scl * 5 + scl, scl * 5);
  strokeWeight(1); // Thicker
  stroke(0);
  
  popMatrix();//go back to normal space?
  
  //Update and Draw the UI
  UI.update();//Update the UI position
  UI.draw();//Draw the UI
  }
}//void draw() END

boolean checkOffset(){//not used
  //println("X: " + (floor(mouseX / scl) * scl) + ", Y: " + (floor(mouseY / scl) * scl) + ", SX: " + SX + ", SY: " + SY + ", H: " + height + ", W: " + width);
  if(SX > 0 && (floor(mouseX / scl) * scl) < SX){
    return true;
  }else if(SY > 0 && (floor(mouseY / scl) * scl) < SY){
    return true;
  }if(SX < 0 && mouseX - width > abs(SX)){
    return true;
  }
  
  return false;
}//boolean checkOffset() END

void mousePressed(){//We pressed a mouse button
  if(preloading == true || UISetup == false){}else{//if preloading or UI not setup do nothing
  //updateXY();
  
  if(mouseX > scl * 5 && mouseY > scl * 5 && mouseX < scl * 5 + scl && mouseY < scl * 5 + scl){
    fileName = "F:/Programming/DragNDraw_Java/map3.csv";
    FileLoadMap();
  }
  
  /*if(checkOffset()){
    return;
  }*/
  
  if(noTile){
    return;
  }
  
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
      mapTiles[mapTiles.length - 1] = new mTile(scl*i + SX - SX,0 + SY - SY,tileN,(int)RSlider.getValue(),(int)GSlider.getValue(),(int)BSlider.getValue(), CClear);//Create a tile
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
  }
}//void mousePressed() END

void mouseDragged(){//We dragged the mouse while holding a button
  if(preloading == true || UISetup == false){}else{//if preloading or UI not setup do nothing
  //updateXY();
  
  /*if(checkOffset()){
    return;
  }*/
  
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
  }
}//void mouseDragged() END

void mouseReleased(){//We released the mouse button
  if(preloading == true || UISetup == false){}else{//if preloading or UI not setup do nothing
  if(dragging){//Are we dragging a tile
    if(mapTiles[mapN] != null){//If tile exists
      snapTileLocation(mapN);//Snap XY location of tile to grid
    }
  }
  
  deleting = false;//Quit deleting
  dragging = false;//Quit dragging
  if(!colorWheel.isVisible() && !colorInputR.isVisible()){//if not using color wheel or color inputs
    noTile = false;//Allow tile placement
  }

  if(mapN != -1 && mapTiles.length > mapN){//If tile exists
    if(mapTiles[mapN].x >= SX && mapTiles[mapN].x < scl*rowLength + SX && mapTiles[mapN].y == SY){//Is the tile we just dropped on the UI
      deleteTile(mapN);//Delete a tile and update the array
      //return false;
    }
  }
  }
}//void mouseReleased() END

void mouseWheel(MouseEvent event){//We Scrolled The Mouse Wheel
  if(event.getCount() < 0){//If Scrolling Up
    nextTileC();//Move To Next Tile
  }else{
    prevTileC();//Move To Previous Tile
  }
}//void mouseWheel(event) END

void keyPressed(){//We pressed a key
  if(noKeyboard == false){//are we blocking keyboard functions?
    //console.log(keyCode);//What key did we press?
    if (keyCode == /*SHIFT*/16){//We pressed shift
      prevRowC();//Previous Tile row
    }else if (keyCode == /*SPACE*/32){//We pressed space
      nextRowC();//Next Tile Row
    }
  }
}//void keyPressed() END

void keyTyped(){//We typed a key
  if(noKeyboard == false){//are we blocking keyboard functions?
    if(key == 'f'){//We pressed 'F'
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
    }
    
    if(key == 'w'){//We pressed 'W'
      if(SY < scl * 5){//if we're not outside of the boundaries
        SY += (scl * scrollAmount);//Scroll Screen UP
      }
      if(SY > scl * 5){//we're outside of the boundaries
        SY = scl * 5;//get back inside of the boundaries
      }
    }
    if(key == 'a'){//We pressed 'A'
      if(SX < scl * 5){//if we're not outside of the boundaries
        SX += (scl * scrollAmount);//Scroll Screen LEFT
      }
      if(SX > scl * 5){//we're outside of the boundaries
        SX = scl * 5;//get back inside of the boundaries
      }
    }
    if(key == 's'){//We pressed 'S'
      if(SY > -((scl * 105) - height)){//if we're not outside of the boundaries
        SY -= (scl * scrollAmount);//Scroll Screen RIGHT
      }
      if(SY < -((scl * 105) - height)){//we're outside of the boundaries
        SY = -((scl * 105) - (floor(height / scl) * scl));//get back inside of the boundaries
      }
    }
    if(key == 'd'){//We pressed 'D'
      if(SX > -((scl * 105) - width)){//if we're not outside of the boundaries
        SX -= (scl * scrollAmount);//Scroll Screen DOWN
      }
      if(SX < -((scl * 105) - width)){//we're outside of the boundaries
        SX = -((scl * 105) - (floor(width / scl) * scl));//get back inside of the boundaries
      }
    }
  }
}//void keyTyped() END

class tileUI{
  void draw(){
    //fill(RSlider.getValue(),GSlider.getValue(),BSlider.getValue());//Set background color to the RGB value set by user
    //rect(0, scl, scl, scl);//Display color behind RGB Sliders
    
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
    
    /*if(colorInputR.isVisible()){
      fill(128);
      rect(scl / 2, scl * 2, scl * 4, scl);
    }*/
    
    fill(255,0,0);//red text
    stroke(0);//no outline
    textSize(24);//larger text size
    //String FPS = String.valueOf(frameRate);
    //text("FPS: " + FPS.substring(0, 4), ((scl * 12) + scl / 8), (scl * 1.75));//FPS: (fps.fp)
    
    text("Tiles: " + mapTiles.length, ((scl * 16) + scl / 8), (scl / 1.25));//Tiles: (tiles)
  
    text("Drawn: " + drawnTiles, ((scl * 16) + scl / 8), (scl * 1.75));//Drawn: (drawn)
    textSize(12);//Default text size
  }//void draw() END
  
  void update(){
    scrollAmount = (int)scrollSlider.getValue();//update scroll amount
    
    RSlider.setColorBackground(color(RSlider.getValue(), 0, 0));//update background color (Red)
    GSlider.setColorBackground(color(0, GSlider.getValue(), 0));//update background color (Green)
    BSlider.setColorBackground(color(0, 0, BSlider.getValue()));//update background color (Blue)
    
    colorSelect.setColorBackground(color(RSlider.getValue(), GSlider.getValue(), BSlider.getValue()));//update background color
    colorInput.setColorBackground(color(RSlider.getValue(), GSlider.getValue(), BSlider.getValue()));//update background color
    
    colorSelect.setColorLabel(color(200 - RSlider.getValue(), 200 - GSlider.getValue(), 200 - BSlider.getValue()));//update inverted label color
    colorInput.setColorLabel(color(200 - RSlider.getValue(), 200 - GSlider.getValue(), 200 - BSlider.getValue()));//update inverted label color
  }//void update() END
  
  void setup(){
    UIControls.addSlider("RSlider").setDecimalPrecision(0).setPosition(scl, scl + 1.3).setSliderMode(Slider.FLEXIBLE).setSize(scl * 3,10).setRange(0,255).setValue(127).setCaptionLabel("");//create Slider
    UIControls.addSlider("GSlider").setDecimalPrecision(0).setPosition(scl, scl + 12.3).setSliderMode(Slider.FLEXIBLE).setSize(scl * 3,10).setRange(0,255).setValue(127).setCaptionLabel("");//create Slider
    UIControls.addSlider("BSlider").setDecimalPrecision(0).setPosition(scl, scl + 23.3).setSliderMode(Slider.FLEXIBLE).setSize(scl * 3,10).setRange(0,255).setValue(127).setCaptionLabel("");//create Slider
    RSlider = UIControls.getController("RSlider");//make it easier to use Slider
    GSlider = UIControls.getController("GSlider");//make it easier to use Slider
    BSlider = UIControls.getController("BSlider");//make it easier to use Slider
    
    UIControls.addSlider("scrollSlider").setDecimalPrecision(0).setPosition(scl * 5,scl).setSliderMode(Slider.FLEXIBLE).setSize(scl * 2,scl).setRange(1,10).setValue(5).setColorBackground(color(50)).setCaptionLabel("");//create Slider
    scrollSlider = UIControls.getController("scrollSlider");//make it easier to use Slider
    
    fileSaveLoad = UIControls.addButtonBar("fileSaveLoad").addItems(split("Save Load Image", " ")).setSize(scl * 4, scl).setPosition(scl * 7,scl).setColorBackground(color(0, 127, 127));//create ButtonBar
    //fileSaveLoad = UIControls.getController("fileSaveLoad");
    
    UIControls.addColorWheel("colorWheel").setPosition(0, scl * 2).setVisible(false).setRGB(color(127, 127, 127)).setCaptionLabel("")//create ColorWheel
      .onChange(new CallbackListener(){//when changed
        public void controlEvent(CallbackEvent theEvent){
          //println(theEvent);
          RSlider.setValue(UIControls.get(ColorWheel.class, "colorWheel").r());//make sure all values are the same
          GSlider.setValue(UIControls.get(ColorWheel.class, "colorWheel").g());//make sure all values are the same
          BSlider.setValue(UIControls.get(ColorWheel.class, "colorWheel").b());//make sure all values are the same
        }
      });
    colorWheel = UIControls.getController("colorWheel");//make it easier to use ColorWheel
    
    
    UIControls.addButton("colorSelect").setSize(scl, scl).setPosition(0, scl).setCaptionLabel("Wheel");//create button
    colorSelect = UIControls.getController("colorSelect");//make it easier to use button
    
    UIControls.addTextfield("colorInputR").setPosition(scl * 4, scl * 2).setSize(scl, scl / 2).setVisible(false).setCaptionLabel("");//.setColorLabel(color(255, 0, 0));
    UIControls.addTextfield("colorInputG").setPosition(scl * 4, scl * 2.5).setSize(scl, scl / 2).setVisible(false).setCaptionLabel("");//.setColorLabel(color(0, 255, 0));
    UIControls.addTextfield("colorInputB").setPosition(scl * 4, scl * 3).setSize(scl, scl / 2).setVisible(false).setCaptionLabel("");//.setColorLabel(color(0, 0, 255));
    colorInputR = UIControls.getController("colorInputR");//make it easier to use Textfield
    colorInputG = UIControls.getController("colorInputG");//make it easier to use Textfield
    colorInputB = UIControls.getController("colorInputB");//make it easier to use Textfield
    
    UIControls.addButton("colorInput").setSize(scl, scl).setPosition(scl * 4, scl).setCaptionLabel("RGB");//create button
    colorInput = UIControls.getController("colorInput");//make it easier to use button
    
    UIControls.addButton("clearToggle").setSize(scl, scl).setPosition(scl * 11, scl).setCaptionLabel("Clear").setColorLabel(color(0, 0, 0)).setColorBackground(color(127, 127, 127));//create button
    clearToggle = UIControls.getController("clearToggle");//make it easier to use button
    
    UIControls.addButton("loadMap").setSize(scl * 2, scl).setPosition(scl * 6, 0).setCaptionLabel("Load Map");//create button
    loadMap = UIControls.getController("loadMap");//make it easier to use button
    
    changeVisibility(true);//go to tile map selection display
  }//void setup() END
}//class tileUI END

void clearToggle(){//called when clearToggle is clicked
  if(CClear){//is variable set
    CClear = false;//don't place clear tiles
    clearToggle.setColorLabel(color(0, 0, 0));//make text black
  }else{
    CClear = true;//place clear tiles
    clearToggle.setColorLabel(color(255, 255, 255));//make text white
  }
  
}//void clearToggle() END

void colorSelect(){//called when colorSelect is clicked
  colorWheel.setVisible(!colorWheel.isVisible());//invert visibility
  noTile = !noTile;//ivert whether tiles can be placed
}//void colorSelect() END

void colorInput(){//called when colorInput is clicked
  //UIControls.get(Textfield.class, "colorInputR").setVisible(!UIControls.get(Textfield.class, "colorInputR").isVisible());
  colorInputR.setVisible(!colorInputR.isVisible());//invert visibility
  colorInputG.setVisible(!colorInputG.isVisible());//invert visibility
  colorInputB.setVisible(!colorInputB.isVisible());//invert visibility
  noKeyboard = !noKeyboard;//invert whether keyboard keys work
  noTile = !noTile;//ivert whether tiles can be placed
}//void colorInput() END

void colorInputR(String value){//called when colorInputR updates
  RSlider.setValue(int(value));//make sure all values are the same
}//void colorInputR(String value) END

void colorInputG(String value){//called when colorInputG updates
  GSlider.setValue(int(value));//make sure all values are the same
}//void colorInputG(String value) END

void colorInputB(String value){//called when colorInputB updates
  BSlider.setValue(int(value));//make sure all values are the same
}//void colorInputB(String value) END

void fileSaveLoad(int n){
  //println(n);
  if(loadingTileMap == true){
    if(n == 0){//Prev
      tileMapShow--;//go to previous tile map
      if(tileMapShow <= 0){//make sure we don't go below zero
        tileMapShow = 0;//set to 0
      }
    }else if(n == 1){//Next
      tileMapShow++;//go to next tile map
      if(tileMapShow >= tileInfoTable.getRowCount() - 2){//make sure we dont go above maximum tile map
        tileMapShow = tileInfoTable.getRowCount() - 2;//set to maxixmum tile map
      }
    }else if(n == 2){//Load
      tileMapLocation = tileInfoTable.getString(tileMapShow + 1,"location");//load location
      totalImages = tileInfoTable.getInt(tileMapShow + 1,"images") - 1;//load number of images
      tileMapWidth = tileInfoTable.getInt(tileMapShow + 1,"tileMapWidth");//load number of tiles wide
      tileMapHeight = tileInfoTable.getInt(tileMapShow + 1,"tileMapHeight");//load number of tiles tall
      tileMapName = tileInfoTable.getString(tileMapShow + 1,"name");//load name
      fullTotalImages = ceil((float)totalImages / rowLength) * rowLength - 1;//adjust total images
      preload();//preload stuff
      tileN = 1;//make sure were on tile 1
      noTile = false;//allowed to place tiles
      loadingTileMap = false;//no longer loading map
      preloading = false;//no longer preloading
      changeVisibility(false);//go to normal display
    }else{
      println("Button Does Not Exist");//Tell me your secrets
    }
  }else{
    if(n == 0){//Save
      selectOutput("Select a CSV to write to:", "fileSaveLoadSelect");//map save dialog
    }else if(n == 1){//Load
      selectInput("Select a CSV to read from:", "FileLoadMapSelect");//map load dialog
    }else if(n == 2){//Image
      selectOutput("Select a PNG to write to:", "FileSaveCanvasSelect");//canvas save dialog
    }else{
      println("Button Does Not Exist");//Tell me your secrets
    }
  }
}//void fileSaveLoad(int n) END

class canvasBG{//The background
  void draw(){//Draw the background
    background(255);//Draw the white background
    image(BACKGROUND, 0, 0);//Draw background
  }//void draw() END
  
  void border(){//draw the red border
    strokeWeight(borderThickness); // Thicker
    stroke(255,0,0);//RED
    line(1, 0, 1, rows*scl);//Draw Verticle lines
    line((scl * cols) - 1, 0, (scl * cols) - 1, rows*scl);//Draw Verticle lines
    line(0, 1, cols*scl, 1);//Draw Horizontal Lines
    line(0, (scl * rows) - 1, cols*scl, (scl * rows) - 1);//Draw Horizontal Lines
    strokeWeight(1); // Default
    stroke(0);//BLACK
  }//void border() END
}//class canvasBG END

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

void updateXY(){//Update the XY position of the mouse and the page XY offset
  mX = mouseX - SX;//Update the X position of the mouse
  mY = mouseY - SY;//Update the Y position of the mouse
  //SX = window.pageXOffset;//Update the page X offset
  //SY = window.pageYOffset;//Update the page Y offset
}//void updateXY() END

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

void loadTile(int tile){//Set current image to tile image
  tileN = mapTiles[tile].image;//Set current image to tile image
}//void loadTile() END

void updateOffset(int tile){//Update mouse XY offset relative to upper-left corner of tile
  offsetX = mapTiles[tile].x-mX;//keep track of relative X location of click to corner of rectangle
  offsetY = mapTiles[tile].y-mY;//keep track of relative Y location of click to corner of rectangle
}//void updateOffset() END

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
}//void nextTileC() END

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
}//void prevTileC() END

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
}//void updateTileRow() END

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
}//void nextRowC() END

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
}//void prevRowC() END

boolean isCursorOnTile(int tile){//Is the mouse cursor on the tile we're checking?
  return(mX > mapTiles[tile].x - fV && mX < mapTiles[tile].x + scl + fV && mY > mapTiles[tile].y - fV && mY < mapTiles[tile].y + scl + fV);//Are we clicking on the tile
}//boolean isCursorOnTile(int tile) END

boolean isCursorOnTileXY(int tile, int tX, int tY){//Is the mouse cursor on the tile we're checking?
  return(tX > mapTiles[tile].x - fV && tX < mapTiles[tile].x + scl + fV && tY > mapTiles[tile].y - fV && tY < mapTiles[tile].y + scl + fV);//Are we clicking on the tile
}//boolean isCursorOnTileXY(int tile, int tX, int tY) END

boolean isCursorOnTileNoFV(int tile){//Is the mouse cursor on the tile we're checking?
  return(mX > mapTiles[tile].x && mX < mapTiles[tile].x + scl && mY > mapTiles[tile].y && mY < mapTiles[tile].y + scl);//Are we clicking on the tile
}//boolean isCursorOnTileNoFV(int tile) END

boolean isCursorOnTileNoFVXY(int tile, int tX, int tY){//Is the mouse cursor on the tile we're checking?
  return(tX > mapTiles[tile].x && tX < mapTiles[tile].x + scl && tY > mapTiles[tile].y && tY < mapTiles[tile].y + scl);//Are we clicking on the tile
}//boolean isCursorOnTileNoFVXY(int tile, int tX, int tY) END

void updateTileLocation(int tile){//Adjust XY location of tile
  mapTiles[tile].x = mX + offsetX;//Adjust X location of tile
  mapTiles[tile].y = mY + offsetY;//Adjust Y location of tile
}//void updateTileLocation(int tile) END

void snapTileLocation(int tile){//Snap XY location of tile to grid
  mapTiles[tile].x = floor(mouseX / scl) * scl - SX;//Adjust X location of tile
  mapTiles[tile].y = floor(mouseY / scl) * scl - SY;//Adjust Y location of tile
}//void snapTileLocation(int tile) END

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

void loadColors(int tile){//Load RGB Sliders and RGB Inputs with value from tile
  RSlider.setValue(mapTiles[tile].r);//Set Red Slider value to Red value of the tile
  GSlider.setValue(mapTiles[tile].g);//Set Green Slider value to Green value of the tile
  BSlider.setValue(mapTiles[tile].b);//Set Blue Slider value to Blue value of the tile
}//void loadColors(int tile) END

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
}//void tileGroup(String button) END

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
}//void tileGroupCutCopy(char button) END

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

void FileSaveCanvasSelect(File selection){//map canvas save select callback
  if (selection == null) {//we didn't select a file
    println("Window was closed or the user hit cancel.");
  } else {//we selected a file
    println("User selected " + selection.getAbsolutePath() + " for saving");
    fileName = selection.getAbsolutePath();//get the path to the file
    String[] fileNameSplit = split(fileName, '.');//split the filename into parts
    String[] fileNamePNG = {fileNameSplit[0], "png"};//array of filename and png
    if(fileNameSplit.length > 1){//does the file have an extension
      //Already has file type
    }else{
      fileName = join(fileNamePNG, '.');//make sure the filename ends with .png
    }
    FileSaveCanvas();//save the canvas
  }
}//void FileSaveCanvasSelect(File selection) END

void fileSaveLoadSelect(File selection){//map file save select callback
  if (selection == null) {//we didn't select a file
    println("Window was closed or the user hit cancel.");
  } else {//we selected a file
    println("User selected " + selection.getAbsolutePath() + " for saving");
    fileName = selection.getAbsolutePath();//get the path to the file
    String[] fileNameSplit = split(fileName, '.');//split the filename into parts
    String[] fileNameCSV = {fileNameSplit[0], "csv"};//array of filename and csv
    if(fileNameSplit.length > 1){//does the file have an extension
      //Already has file type
    }else{
      fileName = join(fileNameCSV, '.');//make sure the filename ends with .csv
    }
    fileSaveLoad();//save the map
  }
}//void fileSaveLoadSelect(File selection) END

void FileLoadMapSelect(File selection){//map file load select callback
  if (selection == null) {//we didn't select a file
    println("Window was closed or the user hit cancel.");
  } else {//we selected a file
    println("User selected " + selection.getAbsolutePath() + " for loading");
    fileName = selection.getAbsolutePath();//get the path to the file
    FileLoadMap();//load the map
  }
}//void FileLoadMapSelect(File selection) END

void FileSaveCanvas(){//Save the Canvas to a file
  int lowX = scl * cols;//make it all the way to the right
  int highX = 0;//make it all the way to the left
  int lowY = scl * rows;//make it all the way down
  int highY = 0;//make it all the way up
  
  for(int i = 0; i < mapTiles.length; i++){//Go through all the tiles
    if(mapTiles[i].x < lowX){//if theres a tile further left
      lowX = mapTiles[i].x;//set that as the left
    }
    if(mapTiles[i].x > highX){//if theres a tile further right
      highX = mapTiles[i].x;//set that as the right
    }
    if(mapTiles[i].y < lowY){//if theres a tile further up
      lowY = mapTiles[i].y;//set that as the up
    }
    if(mapTiles[i].y > highY){//if theres a tile further down
      highY = mapTiles[i].y;//set that as the down
    }
  }//Went through all the tiles

  PGraphics fullCanvas = createGraphics(highX - lowX + scl + 1, highY - lowY + scl + 1);//make the canvas slightly larger than needed
  fullCanvas.beginDraw();//start drawing the canvas
  fullCanvas.background(255);//make the background white
  fullCanvas.image(BACKGROUND, 0, 0);//Draw the background
  //Display Map Tiles
  for(int i = 0; i < mapTiles.length; i++){//Go through all the tiles
    if(!mapTiles[i].clear){//Is the tile colored
      fullCanvas.fill(mapTiles[i].r,mapTiles[i].g,mapTiles[i].b);//Set Tile background color
      fullCanvas.rect(mapTiles[i].x - lowX,mapTiles[i].y - lowY,scl,scl);//Draw colored square behind tile
    }
    fullCanvas.image(img[mapTiles[i].image], mapTiles[i].x - lowX, mapTiles[i].y - lowY);//Draw tile
  }//Went through all the tiles
  fullCanvas.endDraw();//stop drawing the canvas
  fullCanvas.save(fileName);// + ".png");//Save the map to a PNG file
}//void FileSaveCanvas() END

void fileSaveLoad(){//Save the Map to file
  if(loadingTileMap == true){
    tileMapLocation = tileInfoTable.getString(tileMapShow + 1,"location");//load location
    totalImages = tileInfoTable.getInt(tileMapShow + 1,"images") - 1;//load number of images
    tileMapWidth = tileInfoTable.getInt(tileMapShow + 1,"tileMapWidth");//load number of tiles wide
    tileMapHeight = tileInfoTable.getInt(tileMapShow + 1,"tileMapHeight");//load number of tiles tall
    tileMapName = tileInfoTable.getString(tileMapShow + 1,"name");//load name
    fullTotalImages = ceil((float)totalImages / rowLength) * rowLength - 1;//adjust total images
    preload();//preload stuff
    tileN = 1;//make sure were on tile 1
    noTile = false;//allowed to place tiles
    loadingTileMap = false;//no longer loading map
    preloading = false;//no longer preloading
    changeVisibility(false);//go to normal display
    return;
  }

  mapTable = new Table();//create new p5 table
  mapTable.addColumn("x");//Tile X position
  mapTable.addColumn("y");//Tile Y position
  mapTable.addColumn("image");//Tile Image
  mapTable.addColumn("r");//Tile Red amount
  mapTable.addColumn("g");//Tile Green amount
  mapTable.addColumn("b");//Tile Blue amount
  mapTable.addColumn("clear");//Is Tile Clear
  //mapTable.addColumn('lore');//Tile LORE?
  TableRow newRow;//create a new row
  
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////FILE METADATA
  newRow = mapTable.addRow();//Add a row to table
  newRow.setInt("x",_FILEVERSION_);//File Version
  newRow.setString("y",tileMapName);//tile map name
  newRow.setInt("image",0);//blank
  newRow.setInt("r",0);//blank
  newRow.setInt("g",0);//blank
  newRow.setInt("b",0);//blank
  newRow.setInt("clear",0);//blank
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////FILE METADATA
  
  /*if(_FILEVERSION_ == 0){//whats the file version
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
  }else if(_FILEVERSION_ == 1){//whats the file version
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
  }else*/ if(_FILEVERSION_ == 2){//whats the file version
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
}//void fileSaveLoad() END

void FileLoadMap(){//load map from file
  noLoop();//dont allow drawing
  mapTable = loadTable(fileName, "header, csv");// + ".csv", "header");//Load the csv
  
  while(mapTiles.length > 0){//Clear the array
    deleteTile(0);//shorten the array
  }
  
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////FILE METADATA
  int fileVersion = int(mapTable.getInt(0,"x"));//File Version
  println(mapTable.getString(0,"y"));
  if(!tileMapName.equals(mapTable.getString(0,"y"))){//if map names aren't equal
    println("Changing Tile Map");
    tileMapName = mapTable.getString(0,"y");//Tile Map Name
    FileLoadTileInfo();
    preload();
  }else{
    
  }
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
      mapTiles = (mTile[]) expand(mapTiles, mapTiles.length + 1);//Make sure we have room
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
      mapTiles = (mTile[]) expand(mapTiles, mapTiles.length + 1);//Make sure we have room
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
      mapTiles = (mTile[]) expand(mapTiles, mapTiles.length + 1);//Make sure we have room
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
      deleteTile(0);//shorten the array
    }
  }
  loop();//allow drawing
  prepreloading = false;//no longer prepreloading
}//void FileLoadMap() END