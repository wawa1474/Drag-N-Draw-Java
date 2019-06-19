import g4p_controls.*;//buttons
import controlP5.*;//sliders and color wheel
ControlP5 UIControls;//ui controls

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import java.io.BufferedOutputStream;
import java.io.BufferedInputStream;
import java.util.zip.ZipInputStream;

//import java.util.Date;

final int UIscl = 32;
final int scl = 32;//Square Scale
color currentTileColor = color(0,255,255);

//Drag N' Draw Javascript Started April 9th, 2018 at 11:13:08am
//Drag N' Draw Java Started August 16, 2018 at ~4:30 PM
final String _magicText = "wawa1474DragDraw";//make sure the file is ours

PImage options_menu_mockup;
PImage opening_mockup;

int oldScreenW = 0;
int oldScreenH = 0;

final int BUFFER_SIZE = 2048;
File programDirectory;

boolean _EXIT_ = false;

void setup(){//Setup everything
  size(800, 600);
  surface.setResizable(true);//allow resizing of the window
  surface.setTitle("Drag 'N' Draw Java - " + _PROGRAMVERSION_TITLE_);
  noSmooth();//text looks 'nicer'
  
  programDirectory = new File(sketchPath());
  loadAssets();
  loadSettings();
  
  if(_EXIT_ == false){
    //PImage titlebaricon = loadImage("myicon.png");//get title bar icon
    //surface.setIcon(titlebaricon);//set title bar icon
    
    clearMapTilesArray();//setup map tiles array
    clearClickableTilesArray();//setup clickable tiles array
    loadTileMapInfo();//load tile map info files
    
    createGUI();
    
    //control p5 stuff must be setup AFTER G4P otherwise
    //control p5 will be drawn UNDER G4P elements
    UIControls = new ControlP5(this);//set up all the control stuff
    setupUI();//Setup all of the UI stuff
    
    debug();//run whatever debug option is set
  }
}//void setup() END

float zoom = 1;

void draw(){//Draw the canvas
  if(_EXIT_ == false){
    surface.setTitle("Drag 'N' Draw Java - " + _PROGRAMVERSION_TITLE_ + " - FPS:" + padFPS());// + " : " + mapTiles.length);
    
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
        image(opening_mockup,0,0);
        break;
  
      case _MAINMENU_:
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
        image(options_menu_mockup,scl,scl);
        if(ctrlHeld){
          text("CTRL", 50,50);
        }
        if(altHeld){
          text("ALT", 90,50);
        }
        if(shiftHeld){
          text("SHIFT", 120,50);
        }
        break;
      
    }
  }
}//void draw() END