import controlP5.*;//import the library

//Drag N' Draw Javascript Started April 9th, 2018 at 11:13:08am
//Drag N' Draw Java Started August 16, 2018 at ~4:30 PM

int cols = 100;//Columns
int rows = 100;//Rows

int _DEBUG_ = 0;//what are we debugging
int _DEBUGAMOUNT_ = 50000;//how many are we debugging

String VERSION = "0.0.1";

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
  
  icons = (clickableIcon[]) expand(icons, icons.length + 1);//make sure we have room
  icons[icons.length - 1] = new clickableIcon(scl * 15, scl * 15, "maps/map3.csv");//Place a colored tile with no image
}//void setup() END

void draw(){//Draw the canvas
  String FPS = String.valueOf(frameRate);
  if(FPS.length() > 4){
    FPS = FPS.substring(0, 5);
  }else if(FPS.length() > 3){
    FPS = FPS.substring(0, 4);
  }else{
    FPS = FPS.substring(0, 2);
  }
  surface.setTitle("Drag 'N' Draw Java - V" + VERSION + " - FPS:" + FPS);
  
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
  
  for(int i = 0; i < icons.length; i++){
    icons[i].draw();
  }
  
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