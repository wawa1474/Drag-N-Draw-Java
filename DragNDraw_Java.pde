import controlP5.*;//import the library

//Drag N' Draw Javascript Started April 9th, 2018 at 11:13:08am
//Drag N' Draw Java Started August 16, 2018 at ~4:30 PM

int cols = 256;//Columns
int rows = 256;//Rows

int _DEBUG_ = -1;//what are we debugging
int _DEBUGAMOUNT_ = 50000;//5000000;//how many are we debugging

String VERSION = "PRE_ALPHA";//what version do we display
byte[] VERSIONB = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};//<- = pre-alpha

int drawnTiles = 0;//how many tiles are on the screen
boolean drawAll = false;//draw all tiles even if not on screen?

void setup(){//Setup everything
  size(960,540);//make a canvas (X, Y)
  surface.setResizable(true);//allow resizing of the window
  
  for(int x = 0; x < cols; x++){//for how many columns there are
    mapTiles.add(new ArrayList<ArrayList<mTile>>());//create a column
    for(int y = 0; y < rows; y++){//for how many rows there are
      mapTiles.get(x).add(new ArrayList<mTile>());//create a row
    }
  }
  
  //surface.setTitle("Drag 'N' Draw Java: " + VERSION);
  
  FileLoadTileMapInfo();//load tile map info file
  //preload();
  
  UIControls = new ControlP5(this);//set up all the control stuff
  UI.setup();//Setup all of the UI stuff
  
  //changeVisibility(false);
  
  icons.add(new clickableIcon(scl * 13, scl * 13, "maps/map10.ddj", "TEST"));
  icons.add(new clickableIcon(scl * 15, scl * 13, "maps/map10-1.ddj", "TEST2"));
  icons.add(new clickableIcon(scl * 17, scl * 13, "maps/map10-2.ddj", "TEST3"));
  icons.add(new clickableIcon(scl * 19, scl * 13, "maps/map10-3.ddj", "TEST4"));
  
  if(_DEBUG_ == 0){
    for(int i = 0; i < _DEBUGAMOUNT_; i++){
      //mapTiles = (mTile[]) expand(mapTiles, mapTiles.length + 1);//make sure we have room
      //mapTiles[mapTiles.length - 1] = new mTile(200*scl,200*scl,1,127,127,127, false);//test tiles
      //mapTiles.get(200).get(200).add(new mTile(1,127,127,127, false));//(int)random(256)//40
      mapTiles.get((int)random(256)).get((int)random(256)).add(new mTile((int)random(256),(int)random(256),(int)random(256),(int)random(256), (int)random(2)==1));//(int)random(256)
    }
  }
  //button.setup();
}//void setup() END

void draw(){//Draw the canvas
  String FPS = String.valueOf(frameRate);//grab the frame rate
  if(FPS.length() > 4){//if the frame rate has more than 2 decimal places
    FPS = FPS.substring(0, 5);//XX.XX truncate them
  }else if(FPS.length() > 3){//if it has 1 decimal place
    FPS = FPS.substring(0, 4) + "0";//XX.X0 pad it
  }else{//if it has no decimal places
    FPS = FPS.substring(0, 2) + ".00";//XX.00 pad it
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
  
  if(colorWheel.isVisible() || colorInputR.isVisible()){//if using color wheel or color inputs
    noTile = true;//disallow tile placement
  }
  
  pushMatrix();//go back to crazy space?
  translate(SX, SY);//shift screen around
  
  drawnTiles = 0;//reset number of drawn tiles

  updateXY();//Update the XY position of the mouse and the page XY offset
  
  BG.draw();//Draw the background and grid
  
  //resetSpots();//reset spots
  //setSpots();//get what tiles we're gonna draw
  drawSpots();//draw the selected tiles
  
  dragTile();//drag a grabbed tile
  
  BG.border();//Draw the RED border
  
  drawTileGroupOutlines();//draw the necessary outlines
  
  drawIcons();//draw all icons
  
  //strokeWeight(5);
  //line(0,0,width,0);
  //line(0,0,0,height);
  
  //button.draw();
  
  popMatrix();//go back to normal space?
  
  fill(0);//black
  noStroke();//no line around the ui background
  rect(0,0,width,scl * 2);//ui background
  
  //Update and Draw the UI
  UI.update();//Update the UI position
  UI.draw();//Draw the UI
  }
}//void draw() END

//boolean checkOffset(){//not used
//  //println("X: " + (floor(mouseX / scl) * scl) + ", Y: " + (floor(mouseY / scl) * scl) + ", SX: " + SX + ", SY: " + SY + ", H: " + height + ", W: " + width);
//  if(SX > 0 && (floor(mouseX / scl) * scl) < SX){
//    return true;
//  }else if(SY > 0 && (floor(mouseY / scl) * scl) < SY){
//    return true;
//  }if(SX < 0 && mouseX - width > abs(SX)){
//    return true;
//  }
  
//  return false;
//}//boolean checkOffset() END