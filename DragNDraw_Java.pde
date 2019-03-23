//Drag N' Draw Javascript Started April 9th, 2018 at 11:13:08am
//Drag N' Draw Java Started August 16, 2018 at ~4:30 PM

void setup(){//Setup everything
  size(960,540);//make a canvas (X, Y)
  surface.setResizable(true);//allow resizing of the window
  noSmooth();//text looks 'nicer'
  
  clearMapTilesArray();//setup map tiles array
  loadTileMapInfo();//load tile map info files
  
  UIControls = new ControlP5(this);//set up all the control stuff
  UI.setup();//Setup all of the UI stuff
  
  debug();//run whatever debug option is set
}//void setup() END

void draw(){//Draw the canvas
  surface.setTitle("Drag 'N' Draw Java - " + VERSION + " - FPS:" + padFPS());// + " : " + mapTiles.length);
  
  updateScreenBounds();//where on the map is the screen
  updateMouseXY();//Update the XY position of the mouse
  
  pushMatrix();//go back to crazy space?
  translate(screenX, screenY + (scl * 2));//shift screen around
  
  BG.draw();//Draw the background and grid
  
  if(preloading != true){//if preloading
    drawSpots();//draw tiles
  
    BG.border();//Draw the RED border
  
    drawTileGroupOutlines();//draw the necessary outlines
  
    drawIcons();//draw all icons
  }
  
  popMatrix();//go back to normal space?
  
  UI.update();//Update the UI position
  UI.draw();//Draw the UI
}//void draw() END