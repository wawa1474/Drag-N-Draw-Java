import controlP5.*;//import the library

//Drag N' Draw Javascript Started April 9th, 2018 at 11:13:08am
//Drag N' Draw Java Started August 16, 2018 at ~4:30 PM

int cols = 256;//Columns
int rows = 256;//Rows

int _DEBUG_ = -1;//what are we debugging
int _DEBUGAMOUNT_ = 50000;//how many are we debugging

String VERSION = "PRE_ALPHA V0.0.1";

int drawnTiles = 0;//how many tiles are on the screen
boolean drawAll = false;//draw all tiles even if not on screen?

void setup(){//Setup everything
  size(960,540);//make a canvas (X, Y)
  surface.setResizable(true);//allow resizing of the window
  
  //surface.setTitle("Drag 'N' Draw Java: " + VERSION);
  
  FileLoadTileMapInfo();//load tile map info file
  //preload();
  
  UIControls = new ControlP5(this);//set up all the control stuff
  UI.setup();//Setup all of the UI stuff
  
  //changeVisibility(false);
  
  //mapTiles = (mTile[]) expand(mapTiles, mapTiles.length + 1);
  //mapTiles[mapTiles.length - 1] = new mTile(256,256,3,127,127,127,false);
  
  //icons = (clickableIcon[]) expand(icons, icons.length + 1);//make sure we have room
  //icons[icons.length - 1] = new clickableIcon(scl * 15, scl * 15, "maps/map5.ddj", "TEST");//Place a colored tile with no image
  
  //icons = (clickableIcon[]) expand(icons, icons.length + 1);//make sure we have room
  //icons[icons.length - 1] = new clickableIcon(scl * 17, scl * 15, "maps/map6.ddj", "TEST2");//Place a colored tile with no image
  
  //icons = (clickableIcon[]) expand(icons, icons.length + 1);//make sure we have room
  //icons[icons.length - 1] = new clickableIcon(scl * 19, scl * 15, "maps/map7.ddj", "TEST3");//Place a colored tile with no image
  
  //if(_DEBUG_ == 0){
  //  for(int i = 0; i < _DEBUGAMOUNT_; i++){
  //    mapTiles = (mTile[]) expand(mapTiles, mapTiles.length + 1);//make sure we have room
  //    mapTiles[mapTiles.length - 1] = new mTile(200*scl,200*scl,1,127,127,127, false);//test tiles
  //  }
  //}
  button.setup();
}//void setup() END

void draw(){//Draw the canvas
  String FPS = String.valueOf(frameRate);
  if(FPS.length() > 4){
    FPS = FPS.substring(0, 5);//XX.XX
  }else if(FPS.length() > 3){
    FPS = FPS.substring(0, 4) + "0";//XX.X0
  }else{
    FPS = FPS.substring(0, 2) + ".00";//XX.00
  }
  surface.setTitle("Drag 'N' Draw Java - " + VERSION + " - FPS:" + FPS);// + " : " + mapTiles.length);
  
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
    noTile = true;//disallow tile placement
  }
  
  pushMatrix();//go back to crazy space?
  translate(SX, SY);//shift screen around
  
  drawnTiles = 0;//reset number of drawn tiles

  updateXY();//Update the XY position of the mouse and the page XY offset
  
  BG.draw();//Draw the background and grid
  
  //If dragging a tile: update location
  if (dragging){//Are we dragging a tile
    //if(mapTiles[mapN] != null){//If tile exists
      //mapTiles[mapN].updateLocation();//Adjust XY location of tile
    //}
    if(mapTiles.get(mapN) != null){//If tile exists
      mapTiles.get(mapN).updateLocation();//Adjust XY location of tile
    }
  }
  
  //Display Map Tiles
  //for(int i = 0; i < mapTiles.length; i++){//Go through all the tiles
  //  if(mapTiles[i].tileOnScreen() || drawAll == true){//if tile is within screen bounds or drawAll is set
  //    mapTiles[i].draw();//Draw the tile
  for(int i = 0; i < mapTiles.size(); i++){//Go through all the tiles
    if(mapTiles.get(i).tileOnScreen() || drawAll == true){//if tile is within screen bounds or drawAll is set
      mapTiles.get(i).draw();//Draw the tile
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
  
  //for(int i = 0; i < icons.length; i++){//Go through all the clickable icons
  for(int i = 0; i < icons.size(); i++){//Go through all the clickable icons
    //icons[i].draw();//draw the icon
    //if(icons[i].hoveringOver()){//if mouse hovering over icon
    //  icons[i].drawText();//draw the icons text
    //}
    icons.get(i).draw();//draw the icon
    if(icons.get(i).hoveringOver()){//if mouse hovering over icon
      icons.get(i).drawText();//draw the icons text
    }
  }
  
  //strokeWeight(5);
  //line(0,0,width,0);
  //line(0,0,0,height);
  
  button.draw();
  
  popMatrix();//go back to normal space?
  
  fill(0);//black
  noStroke();
  rect(0,0,width,scl * 2);//ui background
  
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