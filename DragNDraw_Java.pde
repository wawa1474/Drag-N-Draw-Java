//Drag N' Draw Javascript Started April 9th, 2018 at 11:13:08am
//Drag N' Draw Java Started August 16, 2018 at ~4:30 PM

void setup(){//Setup everything
  size(960,540);//make a canvas (X, Y)
  surface.setResizable(true);//allow resizing of the window
  noSmooth();//text looks 'nicer'
  
  clearMapTilesArray();//setup map tiles array
  loadTileMapInfo();//load tile map info files
  
  UIControls = new ControlP5(this);//set up all the control stuff
  setupUI();//Setup all of the UI stuff
  
  debug();//run whatever debug option is set
}//void setup() END

void draw(){//Draw the canvas
  surface.setTitle("Drag 'N' Draw Java - " + VERSION + " - FPS:" + padFPS());// + " : " + mapTiles.length);
  
  updateScreenBounds();//where on the map is the screen
  updateMouseXY();//Update the XY position of the mouse
  
  pushMatrix();//go back to crazy space?
  translate(screenX, screenY + (scl * 2));//shift screen around
  
  if(selectingTileMap == true){//are we selecting a tile map
    background(255);//white background
    if(tileMaps.size() != 0){
      image(tileMaps.get(tileMapShow).tileMapImage, 0, 0);//display tile map
      
      tileMap tmp = tileMaps.get(tileMapShow);
      drawBorder(0, tmp.tileMapCols * tmp.tileWidth, 0, tmp.tileMapRows * tmp.tileHeight);//show image bounds
    }
  }else{
    drawEditorBackground();//Draw the background and grid
    
    drawTilesAndIcons();//draw tiles
  
    drawBorder(0, cols * scl, 0, rows * scl);//Draw the RED border
  
    drawTileGroupOutlines();//draw the necessary outlines
  }
  
  popMatrix();//go back to normal space?
  
  updateUI();//Update the UI position
  
  if(selectingTileMap == true){//are we selecting a tile map
    drawTileMapUI();//Draw the tile map selection ui
  }else{
    drawEditorUI();//Draw the Editor UI
  }
  
  for(button b : buttons){//loop through all buttons
    b.draw();//draw the button
  }
}//void draw() END