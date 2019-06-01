import g4p_controls.*;//buttons
import controlP5.*;//sliders and color wheel
ControlP5 UIControls;//ui controls

final int scl = 32;//Square Scale
color currentTileColor = color(0,255,255);

//Drag N' Draw Javascript Started April 9th, 2018 at 11:13:08am
//Drag N' Draw Java Started August 16, 2018 at ~4:30 PM
final String _magicText = "wawa1474DragDraw";//make sure the file is ours

//PImage texttest1;

PImage options_menu_mockup;

PImage opening_mockup;

int oldScreenW = 0;
int oldScreenH = 0;

void setup(){//Setup everything
  //size(960,540);//make a canvas (X, Y)
  size(800, 600);
  surface.setResizable(true);//allow resizing of the window
  surface.setTitle("Drag 'N' Draw Java - " + VERSION);
  noSmooth();//text looks 'nicer'
  
  //texttest1 = loadImage("assets/texttest1.png");
  
  options_menu_mockup = loadImage("assets/options_menu_mockup_v2.png");//main_menu_button_selected
  
  opening_mockup = loadImage("assets/opening_mockup.png");//main_menu_button_selected
  
  //set title bar icon
  //PImage titlebaricon = loadImage("myicon.png");
  //surface.setIcon(titlebaricon);
  
  clearMapTilesArray();//setup map tiles array
  clearClickableTilesArray();//setup clickable tiles array
  loadTileMapInfo();//load tile map info files
  
  createGUI();
  //main_menu_button_VP.fireAllEvents(true);
  //main_menu_button_DND.fireAllEvents(true);
  //main_menu_button_PF.fireAllEvents(true);
  //main_menu_button_TNS.fireAllEvents(true);
  //main_menu_button_RNP.fireAllEvents(true);
  //main_menu_button_OPTIONS.fireAllEvents(true);
  //main_menu_button_EXIT.fireAllEvents(true);
  
  alphaBack = loadImage("assets/alphaBack.png");
  hueBack = loadImage("assets/hueBack.png");
  tmpGradient = createGraphics(100,16);
  setupGradientLabels();
  
  UIControls = new ControlP5(this);//set up all the control stuff
  setupUI();//Setup all of the UI stuff
  
  debug();//run whatever debug option is set
  
  registerMethod("pre", this);
}//void setup() END

void pre() {
  if (currentUI == _EDITORUI_ && (oldScreenW != width || oldScreenH != height)) {
    // Sketch window has resized
    oldScreenW = width;
    oldScreenH = height;
    editor_colorTools_panel.setDragArea();
  }
}

float zoom = 1;

void draw(){//Draw the canvas
  surface.setTitle("Drag 'N' Draw Java - " + VERSION + " - FPS:" + padFPS());// + " : " + mapTiles.length);
  
  updateScreenBounds();//where on the map is the screen
  updateMouseXY();//Update the XY position of the mouse
  
  background(137);//default grayish background
  
  pushMatrix();//go back to crazy space?
  translate(screenX, screenY + UIBottom);//shift screen around
  //scale(zoom);
  
  switch(currentUI){
    case _TILEMAPUI_:
      background(255);//white background
      if(tileMaps.size() != 0){
        image(tileMaps.get(tileMapShow).tileMapImage, 0, 0);//display tile map
      
        tileMap tmp = tileMaps.get(tileMapShow);
        drawBorder(0, tmp.tileMapCols * tmp.tileWidth, 0, tmp.tileMapRows * tmp.tileHeight, 1);//show image bounds
      }
      break;

    case _EDITORUI_:
      drawEditorBackground();//Draw the background and grid
      drawTilesAndIcons();//draw tiles
      drawBorder(1, (cols * scl) - 2, 1, (rows * scl) - 2, borderThickness);//Draw the RED border
      drawTileGroupOutlines();//draw the necessary outlines
      break;
  }
  
  popMatrix();//go back to normal space?
  
  switch(currentUI){
    case _OPENING_:
      //background(137);//white background
      image(opening_mockup,0,0);
      break;

    case _MAINMENU_:
      //background(137);//grayish background
      break;

    case _TILEMAPUI_:
      drawTileMapUI();//Draw the tile map selection ui
      break;

    case _EDITORUI_:
      updateEditorUI();//Update the Editors UI
      drawEditorUI();//Draw the Editor UI
      updateSliderBackgrounds();//figure out how to only update this when the background need to be redrawn
      break;
    
    case _OPTIONSMENU_:
      //background(137);//white background
      image(options_menu_mockup,scl,scl);
      break;
    
  }
}//void draw() END