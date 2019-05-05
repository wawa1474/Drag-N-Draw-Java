import g4p_controls.*;//buttons
import controlP5.*;//sliders and color wheel

//Drag N' Draw Javascript Started April 9th, 2018 at 11:13:08am
//Drag N' Draw Java Started August 16, 2018 at ~4:30 PM
final String _magicText = "wawa1474DragDraw";//make sure the file is ours

//PImage texttest1;
PImage main_menu_button_background;
PImage main_menu_text;
PImage main_menu_button_selected;

PImage options_menu_mockup;

PImage menu_bar_mockup;

PImage opening_mockup;

void setup(){//Setup everything
  //size(960,540);//make a canvas (X, Y)
  size(800, 600);
  surface.setResizable(true);//allow resizing of the window
  surface.setTitle("Drag 'N' Draw Java - " + VERSION);
  noSmooth();//text looks 'nicer'
  createGUI();
  main_menu_button_VP.fireAllEvents(true);
  main_menu_button_DND.fireAllEvents(true);
  main_menu_button_PF.fireAllEvents(true);
  main_menu_button_TNS.fireAllEvents(true);
  main_menu_button_RNP.fireAllEvents(true);
  main_menu_button_OPTIONS.fireAllEvents(true);
  main_menu_button_EXIT.fireAllEvents(true);
  //main_menu_panel.setCollapsed(true);
  //main_menu_panel.setVisible(false);
  //main_menu_panel.moveTo(0,0);
  
  //texttest1 = loadImage("assets/texttest1.png");
  main_menu_button_background = loadImage("assets/main_menu_button_background.png");//main_menu_button_background
  main_menu_text = loadImage("assets/main_menu_text.png");//main_menu_text
  main_menu_button_selected = loadImage("assets/main_menu_button_selected.png");//main_menu_button_selected
  
  options_menu_mockup = loadImage("assets/options_menu_mockup_v2.png");//main_menu_button_selected
  
  menu_bar_mockup = loadImage("assets/menu_bar_mockup.png");//main_menu_button_selected
  
  menuBar_Images = new PImage[3];
  menuBar_Images[button_menuBar_file] = loadImage("assets/menu_bar_file_mockup.png");
  menuBar_Images[button_menuBar_edit] = loadImage("assets/menu_bar_edit_mockup.png");
  menuBar_Images[button_menuBar_view] = loadImage("assets/menu_bar_view_mockup.png");
  
  opening_mockup = loadImage("assets/opening_mockup.png");//main_menu_button_selected
  
  //set title bar icon
  //PImage titlebaricon = loadImage("myicon.png");
  //surface.setIcon(titlebaricon);
  
  clearMapTilesArray();//setup map tiles array
  clearClickableTilesArray();//setup clickable tiles array
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
      background(137);//white background
      image(opening_mockup,0,0);
      break;

    case _MAINMENU_:
      background(137);//grayish background
      //image(main_menu_button_background,scl,scl);
      //image(main_menu_text,scl,scl);
      //checkButtons();
      break;

    case _TILEMAPUI_:
      drawTileMapUI();//Draw the tile map selection ui
      //for(button b : buttons_tilemapUI){//loop through all buttons
      //  b.draw();//draw the button
      //}
      break;

    case _EDITORUI_:
      updateEditorUI();//Update the Editors UI
      drawEditorUI();//Draw the Editor UI
      for(button b : buttons_editorUI){//loop through all buttons
        b.draw();//draw the button
      }
      image(menu_bar_mockup, 0,0);
      if(displayedMenuBar != -1){
        switch(displayedMenuBar){
          case button_menuBar_file:
            image(menuBar_Images[button_menuBar_file],0 ,17);
            break;

          case button_menuBar_edit:
            image(menuBar_Images[button_menuBar_edit],30 ,17);
            break;

          case button_menuBar_view:
            image(menuBar_Images[button_menuBar_view],62 ,17);
            break;
        }
      }
      break;
    
    case _OPTIONSMENU_:
      background(137);//white background
      image(options_menu_mockup,scl,scl);
      break;
    
  }
}//void draw() END