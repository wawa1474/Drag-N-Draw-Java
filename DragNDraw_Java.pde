//Drag N' Draw Javascript Started April 9th, 2018 at 11:13:08am
//Drag N' Draw Java Started August 16, 2018 at ~4:30 PM

//PImage texttest1;
PImage main_menu_button_background;
PImage main_menu_text;
PImage main_menu_button_selected;

PImage options_menu_mockup;

void setup(){//Setup everything
  size(960,540);//make a canvas (X, Y)
  surface.setResizable(true);//allow resizing of the window
  noSmooth();//text looks 'nicer'
  
  //texttest1 = loadImage("assets/texttest1.png");
  main_menu_button_background = loadImage("assets/main_menu_button_background.png");//main_menu_button_background
  main_menu_text = loadImage("assets/main_menu_text.png");//main_menu_text
  main_menu_button_selected = loadImage("assets/main_menu_button_selected.png");//main_menu_button_selected
  
  options_menu_mockup = loadImage("assets/options_menu_mockup.png");//main_menu_button_selected
  //set title bar icon
  //PImage titlebaricon = loadImage("myicon.png");
  //surface.setIcon(titlebaricon);
  
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
  
  //if(currentUI != _MAINMENU_){
  pushMatrix();//go back to crazy space?
  translate(screenX, screenY + (scl * 2));//shift screen around
  //}
  
  switch(currentUI){
    case _TILEMAPUI_:
      background(255);//white background
      if(tileMaps.size() != 0){
        image(tileMaps.get(tileMapShow).tileMapImage, 0, 0);//display tile map
      
        tileMap tmp = tileMaps.get(tileMapShow);
        drawBorder(0, tmp.tileMapCols * tmp.tileWidth, 0, tmp.tileMapRows * tmp.tileHeight);//show image bounds
      }
      break;

    case _EDITORUI_:
      drawEditorBackground();//Draw the background and grid
      drawTilesAndIcons();//draw tiles
      drawBorder(0, cols * scl, 0, rows * scl);//Draw the RED border
      drawTileGroupOutlines();//draw the necessary outlines
      break;
  }
  
  //if(currentUI != _MAINMENU_){
  popMatrix();//go back to normal space?
  //}
  
  switch(currentUI){
    case _MAINMENU_:
      background(137);//white background
      image(main_menu_button_background,scl,scl);
      image(main_menu_text,scl,scl);
      checkMenuButtons();
      break;

    case _TILEMAPUI_:
      drawTileMapUI();//Draw the tile map selection ui
      for(button b : buttons_tilemapUI){//loop through all buttons
        b.draw();//draw the button
      }
      break;

    case _EDITORUI_:
      updateEditorUI();//Update the Editors UI
      drawEditorUI();//Draw the Editor UI
      for(button b : buttons_editorUI){//loop through all buttons
        b.draw();//draw the button
      }
      break;
    
    case _OPTIONSMENU_:
      background(137);//white background
      image(options_menu_mockup,scl,scl);
      break;
    
  }
}//void draw() END