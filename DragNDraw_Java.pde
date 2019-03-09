import controlP5.*;//import the library

//Drag N' Draw Javascript Started April 9th, 2018 at 11:13:08am
//Drag N' Draw Java Started August 16, 2018 at ~4:30 PM

int cols = 256;//Columns
int rows = 256;//Rows

int _DEBUG_ = -1;//what are we debugging
int _DEBUGAMOUNT_ = 50000;//5000000;//how many are we debugging

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
  
  FileLoadTileMapInfo();//load tile map info file
  
  UIControls = new ControlP5(this);//set up all the control stuff
  UI.setup();//Setup all of the UI stuff
  
  //icons.add(new clickableIcon(scl * 13, scl * 13, "maps/map10.ddj", "TEST"));
  //icons.add(new clickableIcon(scl * 15, scl * 13, "maps/map10-1.ddj", "TEST2"));
  //icons.add(new clickableIcon(scl * 17, scl * 13, "maps/map10-2.ddj", "TEST3"));
  //icons.add(new clickableIcon(scl * 19, scl * 13, "maps/map10-3.ddj", "TEST4"));
  
  if(_DEBUG_ == 0){
    for(int i = 0; i < _DEBUGAMOUNT_; i++){
      mapTiles.get((int)random(256)).get((int)random(256)).add(new mTile((int)random(256),(int)random(256),(int)random(256),(int)random(256), (int)random(2)==1));//(int)random(256)
    }
  }
}//void setup() END

void draw(){//Draw the canvas
  surface.setTitle("Drag 'N' Draw Java - " + VERSION + " - FPS:" + padFPS());// + " : " + mapTiles.length);
  
  pushMatrix();//go back to crazy space?
  translate(SX, SY);//shift screen around
  
  BG.draw();//Draw the background and grid
  
  if(preloading != true){//if preloading
    drawnTiles = 0;//reset number of drawn tiles

    updateXY();//Update the XY position of the mouse and the page XY offset
  
    drawSpots();//draw tiles
  
    dragTile();//drag a grabbed tile
  
    BG.border();//Draw the RED border
  
    drawTileGroupOutlines();//draw the necessary outlines
  
    drawIcons();//draw all icons
  }
  
  popMatrix();//go back to normal space?
  
  UI.update();//Update the UI position
  UI.draw();//Draw the UI
}//void draw() END