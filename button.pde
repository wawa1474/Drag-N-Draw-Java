//button button = new button(32,32,32,32,color(0,127,127),"LOAD",color(255), 8);
//ArrayList<clickRect> buttons_mainMenuUI = new ArrayList<clickRect>(0);
//ArrayList<button> buttons_tilemapUI = new ArrayList<button>(0);
ArrayList<button> buttons_editorUI = new ArrayList<button>(0);
//ArrayList<clickRect> buttons_menuBar = new ArrayList<clickRect>(0);
//PImage[] gui;

PImage[] menuBar_Images;
int displayedMenuBar = -1;

final int button_editorUI_hueWheelVis = 0;
final int button_editorUI_rgbInputVis = 1;
final int button_editorUI_colorToggle = 2;
final int button_editorUI_newMap = 3;
final int button_editorUI_saveMap = 4;
final int button_editorUI_loadMap = 5;
final int button_editorUI_saveImage = 6;
final int button_editorUI_changeTileMap = 7;

//final int button_tilemapUI_prevTileMap = 0;
//final int button_tilemapUI_nextTileMap = 1;
//final int button_tilemapUI_loadTileMap = 2;
//final int button_tilemapUI_loadMapAndTileMap = 3;

//int mainMenuButton = -1;//what menu button are we hovering over
//final int button_mainMenuUI_villagerPillager = 0;//Villager Pillager
//final int button_mainMenuUI_dragNDraw = 1;//Drag N' Draw
//final int button_mainMenuUI_playerFlayer = 2;//Player Flayer
//final int button_mainMenuUI_tileNStyle = 3;//Tile N' Style
//final int button_mainMenuUI_roleNPlay = 4;//Role N' Play
//final int button_mainMenuUI_options = 5;//Options
//final int button_mainMenuUI_exit = 99;//Exit


//int menuBarButton = -1;//what menu button are we hovering over
final int button_menuBar_file = 0;
final int button_menuBar_edit = 1;
final int button_menuBar_view = 2;
final int button_menuBar_color = 3;
final int button_menuBar_tools = 4;
final int button_menuBar_help = 5;

//void loadButtonImages(){
//  PImage ui = loadImage("/assets/UI/Icons_byVellidragon.png");
//  gui = new PImage[30];
//  int pos = 0;
//  for(int y = 0; y < 6; y++){
//    for(int x = 0; x < 5; x++){
//      PImage tmp = createImage(32, 32, ARGB);//create a temporary image
//      tmp.copy(ui, x * 16, y * 16, 16, 16, 0, 0, 32, 32);
//      gui[pos] = tmp;
//      pos++;
//    }
//  }
//}

GPanel main_menu_button_panel;
GImageButton main_menu_button_VP;
GImageButton main_menu_button_DND;
GImageButton main_menu_button_PF;
GImageButton main_menu_button_TNS;
GImageButton main_menu_button_RNP;
GImageButton main_menu_button_OPTIONS;
GImageButton main_menu_button_EXIT;

GPanel menu_bar_button_panel;
GImageButton menu_bar_button_FILE;
GImageButton menu_bar_button_EDIT;
GImageButton menu_bar_button_VIEW;
GImageButton menu_bar_button_COLOR;
GImageButton menu_bar_button_TOOLS;
GImageButton menu_bar_button_HELP;

GPanel tilemap_button_panel;
GImageButton tilemap_button_PREV;
GImageButton tilemap_button_NEXT;
GImageButton tilemap_button_LOADTILES;
GImageButton tilemap_button_LOADMAP;

GPanel editor_colorTools_panel;
int editor_colorTools_panel_Width = scl * 10;
int editor_colorTools_panel_Height = scl * 10;

//GButton test;

GSlider editor_slider_red;
GSlider editor_slider_green;
GSlider editor_slider_blue;

GSlider editor_slider_hue;
GSlider editor_slider_saturation;
GSlider editor_slider_brightness;

//GTextField textfield1;//GEvents.CHANGED, ENTERED, SELECTION_CHANGED

public void createGUI(){
  G4P.messagesEnabled(false);
  GButton.useRoundCorners(false);
  main_menu_button_panel = new GPanel(this, 0, 0, 1, 1, "");
  main_menu_button_panel.setCollapsible(false);
  main_menu_button_panel.setDraggable(false);
  main_menu_button_panel.setOpaque(false);
  //main_menu_panel.addEventHandler(this, "main_menu_panel");
  main_menu_button_VP = new GImageButton(this, 0, 0, new String[] {"assets/buttons/main menu/main_menu_VP_normal.png", "assets/buttons/main menu/main_menu_VP_mouseOver.png", "assets/buttons/main menu/main_menu_VP_pressed.png"});
  main_menu_button_VP.addEventHandler(this, "main_menu_button_handler");
  main_menu_button_DND = new GImageButton(this, 0, 64, new String[] {"assets/buttons/main menu/main_menu_DND_normal.png", "assets/buttons/main menu/main_menu_DND_mouseOver.png", "assets/buttons/main menu/main_menu_DND_pressed.png"});
  main_menu_button_DND.addEventHandler(this, "main_menu_button_handler");
  main_menu_button_PF = new GImageButton(this, 0, 128, new String[] {"assets/buttons/main menu/main_menu_PF_normal.png", "assets/buttons/main menu/main_menu_PF_mouseOver.png", "assets/buttons/main menu/main_menu_PF_pressed.png"});
  main_menu_button_PF.addEventHandler(this, "main_menu_button_handler");
  main_menu_button_TNS = new GImageButton(this, 0, 192, new String[] {"assets/buttons/main menu/main_menu_TNS_normal.png", "assets/buttons/main menu/main_menu_TNS_mouseOver.png", "assets/buttons/main menu/main_menu_TNS_pressed.png"});
  main_menu_button_TNS.addEventHandler(this, "main_menu_button_handler");
  main_menu_button_RNP = new GImageButton(this, 0, 256, new String[] {"assets/buttons/main menu/main_menu_RNP_normal.png", "assets/buttons/main menu/main_menu_RNP_mouseOver.png", "assets/buttons/main menu/main_menu_RNP_pressed.png"});
  main_menu_button_RNP.addEventHandler(this, "main_menu_button_handler");
  main_menu_button_OPTIONS = new GImageButton(this, 0, 320, new String[] {"assets/buttons/main menu/main_menu_OPTIONS_normal.png", "assets/buttons/main menu/main_menu_OPTIONS_mouseOver.png", "assets/buttons/main menu/main_menu_OPTIONS_pressed.png"});
  main_menu_button_OPTIONS.addEventHandler(this, "main_menu_button_handler");
  main_menu_button_EXIT = new GImageButton(this, 0, 384, new String[] {"assets/buttons/main menu/main_menu_EXIT_normal.png", "assets/buttons/main menu/main_menu_EXIT_mouseOver.png", "assets/buttons/main menu/main_menu_EXIT_pressed.png"});
  main_menu_button_EXIT.addEventHandler(this, "main_menu_button_handler");
  main_menu_button_panel.addControl(main_menu_button_VP);
  main_menu_button_panel.addControl(main_menu_button_DND);
  main_menu_button_panel.addControl(main_menu_button_PF);
  main_menu_button_panel.addControl(main_menu_button_TNS);
  main_menu_button_panel.addControl(main_menu_button_RNP);
  main_menu_button_panel.addControl(main_menu_button_OPTIONS);
  main_menu_button_panel.addControl(main_menu_button_EXIT);
  
  menu_bar_button_panel = new GPanel(this, 0, 0, 1, 1, "");
  menu_bar_button_panel.setCollapsible(false);
  menu_bar_button_panel.setDraggable(false);
  menu_bar_button_panel.setOpaque(false);
  //main_menu_panel.addEventHandler(this, "main_menu_panel");
  float menu_bar_panel_FILE_x = 0;
  menu_bar_button_FILE = new GImageButton(this, menu_bar_panel_FILE_x, 0, new String[] {"assets/buttons/menu bar/menu_bar_FILE.png", "assets/buttons/menu bar/menu_bar_FILE_mouseOver.png"});
  menu_bar_button_FILE.addEventHandler(this, "menu_bar_button_handler");
  float menu_bar_panel_EDIT_x = menu_bar_button_FILE.getWidth();
  menu_bar_button_EDIT = new GImageButton(this, menu_bar_panel_EDIT_x, 0, new String[] {"assets/buttons/menu bar/menu_bar_EDIT.png", "assets/buttons/menu bar/menu_bar_EDIT_mouseOver.png"});
  menu_bar_button_EDIT.addEventHandler(this, "menu_bar_button_handler");
  float menu_bar_panel_VIEW_x = menu_bar_panel_EDIT_x + menu_bar_button_EDIT.getWidth();
  menu_bar_button_VIEW = new GImageButton(this, menu_bar_panel_VIEW_x, 0, new String[] {"assets/buttons/menu bar/menu_bar_VIEW.png", "assets/buttons/menu bar/menu_bar_VIEW_mouseOver.png"});
  menu_bar_button_VIEW.addEventHandler(this, "menu_bar_button_handler");
  float menu_bar_panel_COLOR_x = menu_bar_panel_VIEW_x + menu_bar_button_VIEW.getWidth();
  menu_bar_button_COLOR = new GImageButton(this, menu_bar_panel_COLOR_x, 0, new String[] {"assets/buttons/menu bar/menu_bar_COLOR.png", "assets/buttons/menu bar/menu_bar_COLOR_mouseOver.png"});
  menu_bar_button_COLOR.addEventHandler(this, "menu_bar_button_handler");
  float menu_bar_panel_TOOLS_x = menu_bar_panel_COLOR_x + menu_bar_button_COLOR.getWidth();
  menu_bar_button_TOOLS = new GImageButton(this, menu_bar_panel_TOOLS_x, 0, new String[] {"assets/buttons/menu bar/menu_bar_TOOLS.png", "assets/buttons/menu bar/menu_bar_TOOLS_mouseOver.png"});
  menu_bar_button_TOOLS.addEventHandler(this, "menu_bar_button_handler");
  float menu_bar_panel_HELP_x = menu_bar_panel_TOOLS_x + menu_bar_button_TOOLS.getWidth();
  menu_bar_button_HELP = new GImageButton(this, menu_bar_panel_HELP_x, 0, new String[] {"assets/buttons/menu bar/menu_bar_HELP.png", "assets/buttons/menu bar/menu_bar_HELP_mouseOver.png"});
  menu_bar_button_HELP.addEventHandler(this, "menu_bar_button_handler");
  menu_bar_button_panel.addControl(menu_bar_button_FILE);
  menu_bar_button_panel.addControl(menu_bar_button_EDIT);
  menu_bar_button_panel.addControl(menu_bar_button_VIEW);
  menu_bar_button_panel.addControl(menu_bar_button_COLOR);
  menu_bar_button_panel.addControl(menu_bar_button_TOOLS);
  menu_bar_button_panel.addControl(menu_bar_button_HELP);
  
  tilemap_button_panel = new GPanel(this, 0, 0, 1, 1, "");
  tilemap_button_panel.setCollapsible(false);
  tilemap_button_panel.setDraggable(false);
  tilemap_button_panel.setOpaque(false);
  //main_menu_panel.addEventHandler(this, "main_menu_panel");
  tilemap_button_PREV = new GImageButton(this, 0, 0, new String[] {"assets/buttons/left_arrow_blue.png"});
  tilemap_button_PREV.addEventHandler(this, "tilemap_button_handler");
  tilemap_button_NEXT = new GImageButton(this, scl * 2, 0, new String[] {"assets/buttons/right_arrow.png"});
  tilemap_button_NEXT.addEventHandler(this, "tilemap_button_handler");
  tilemap_button_LOADTILES = new GImageButton(this, scl * 4, 0, new String[] {"assets/buttons/button_load.png"});
  tilemap_button_LOADTILES.addEventHandler(this, "tilemap_button_handler");
  tilemap_button_LOADMAP = new GImageButton(this, scl * 7, 0, new String[] {"assets/buttons/button_load_map.png"});
  tilemap_button_LOADMAP.addEventHandler(this, "tilemap_button_handler");
  tilemap_button_panel.addControl(tilemap_button_PREV);
  tilemap_button_panel.addControl(tilemap_button_NEXT);
  tilemap_button_panel.addControl(tilemap_button_LOADTILES);
  tilemap_button_panel.addControl(tilemap_button_LOADMAP);
  
  editor_colorTools_panel = new GPanel(this, scl * 3, scl * 3, editor_colorTools_panel_Width, editor_colorTools_panel_Height, "color tools");
  editor_colorTools_panel.addEventHandler(this, "editor_colorTools_panel_handler");
  
  //test = new GButton(this, scl * 7, scl * 7, 34, 34, "HUE");
  //test.setLocalColor(2, color(RSlider.getValue(), GSlider.getValue(), BSlider.getValue()));
  //2 = text color, 3 = border, 4 = background, 6 = mouse over, 14 = click
  
  editor_slider_red = new GSlider(this, scl * 9, 50, scl * 3, 16, 16);
  editor_slider_red.setLimits(127, 0, 255);
  editor_slider_red.setLocalColorScheme(0);//red = 0, green = 1, blue = 6
  editor_slider_red.setLocalColor(3, screen_Amber);
  editor_slider_red.setLocalColor(5, color(127, 0, 0));
  editor_slider_red.addEventHandler(this, "editor_RGBSlider_handler");
  
  editor_slider_green = new GSlider(this, scl * 9, 66, scl * 3, 16, 16);
  editor_slider_green.setLimits(127, 0, 255);
  editor_slider_green.setLocalColorScheme(1);//red = 0, green = 1, blue = 6
  editor_slider_green.setLocalColor(3, screen_Amber);
  editor_slider_green.setLocalColor(5, color(0, 127, 0));
  editor_slider_green.addEventHandler(this, "editor_RGBSlider_handler");
  
  editor_slider_blue = new GSlider(this, scl * 9, 82, scl * 3, 16, 16);
  editor_slider_blue.setLimits(127, 0, 255);
  editor_slider_blue.setLocalColorScheme(6);//red = 0, green = 1, blue = 6
  editor_slider_blue.setLocalColor(3, screen_Amber);
  editor_slider_blue.setLocalColor(5, color(0, 0, 127));
  editor_slider_blue.addEventHandler(this, "editor_RGBSlider_handler");
  //1 = ticks, 2 = text color, 3 = thumb/border, 4 = ticks, 5 = surface, 6 = background, 11 = thumb, 14 = thumb, 15 = thumb
  
  colorMode(HSB, 255);
  
  editor_slider_hue = new GSlider(this, scl * 13, 50, scl * 3, 16, 16);
  editor_slider_hue.setLimits(127, 0, 255);
  editor_slider_hue.setLocalColorScheme(0);//red = 0, green = 1, blue = 6
  editor_slider_hue.setLocalColor(3, screen_Amber);
  editor_slider_hue.setLocalColor(5, color(127, 127, 127));
  editor_slider_hue.addEventHandler(this, "editor_HSBSlider_handler");
  
  editor_slider_saturation = new GSlider(this, scl * 13, 66, scl * 3, 16, 16);
  editor_slider_saturation.setLimits(127, 0, 255);
  editor_slider_saturation.setLocalColorScheme(1);//red = 0, green = 1, blue = 6
  editor_slider_saturation.setLocalColor(3, screen_Amber);
  editor_slider_saturation.setLocalColor(5, color(127, 127, 127));
  editor_slider_saturation.addEventHandler(this, "editor_HSBSlider_handler");
  
  editor_slider_brightness = new GSlider(this, scl * 13, 82, scl * 3, 16, 16);
  editor_slider_brightness.setLimits(127, 0, 255);
  editor_slider_brightness.setLocalColorScheme(6);//red = 0, green = 1, blue = 6
  editor_slider_brightness.setLocalColor(3, screen_Amber);
  editor_slider_brightness.setLocalColor(5, color(127, 127, 127));
  editor_slider_brightness.addEventHandler(this, "editor_HSBSlider_handler");
  
  colorMode(RGB, 255);
  
  //editor_slider_red.setVisible(false);
  //editor_slider_green.setVisible(false);
  //editor_slider_blue.setVisible(false);
}

//public void main_menu_panel(GImageButton source, GEvent event) {}

boolean mouseOver_colorToolsPanel(){
  boolean Xinside = false;
  boolean Yinside = false;
  boolean inside = false;
  
  if(mouseX > editor_colorTools_panel.getX()){
    if(editor_colorTools_panel.isCollapsed()){
      
    }else if(mouseX < editor_colorTools_panel.getX() + editor_colorTools_panel_Width){
      Xinside = true;
    }
  }
  
  if(mouseY > editor_colorTools_panel.getY()){
    if(editor_colorTools_panel.isCollapsed()){
      
    }else if(mouseY < editor_colorTools_panel.getY() + editor_colorTools_panel_Height){
      Yinside = true;
    }
  }
  
  inside = editor_colorTools_panel.isOver(mouseX, mouseY) || editor_colorTools_panel.isDragging();
  
  return (Xinside && Yinside) || inside;
}

public void editor_colorTools_panel_handler(GPanel source, GEvent event){
  //GEvent.COLLAPSED, EXPANDED, DRAGGED
  if(event == GEvent.COLLAPSED){
    colorWheel.setVisible(false);
  }else if(event == GEvent.EXPANDED){
    colorWheel.setPosition(editor_colorTools_panel.getX() + 1, editor_colorTools_panel.getY() + 20);
    colorWheel.setVisible(true);
  }else if(event == GEvent.DRAGGED){
    colorWheel.setPosition(editor_colorTools_panel.getX() + 1, editor_colorTools_panel.getY() + 20);
  }
}

public void editor_RGBSlider_handler(GSlider source, GEvent event){
  //GEvent.VALUE_STEADY
  println(event);
  currentTileColor = color(editor_slider_red.getValueF(),editor_slider_green.getValueF(),editor_slider_blue.getValueF());
  
  //if(source != editor_slider_red){
  //  editor_slider_red.setValue(red(currentTileColor));
  //}
  
  //if(source != editor_slider_green){
  //  editor_slider_green.setValue(green(currentTileColor));
  //}
  
  //if(source != editor_slider_blue){
  //  editor_slider_blue.setValue(blue(currentTileColor));
  //}
  
  //editor_slider_hue.setValue(hue(currentTileColor));
  //editor_slider_saturation.setValue(saturation(currentTileColor));
  //editor_slider_brightness.setValue(brightness(currentTileColor));
}

public void editor_HSBSlider_handler(GSlider source, GEvent event){
  //GEvent.VALUE_STEADY
  
  colorMode(HSB, 255);
  currentTileColor = color(editor_slider_hue.getValueF(),editor_slider_saturation.getValueF(),editor_slider_brightness.getValueF());
  colorMode(RGB, 255);
  
  //if(source != editor_slider_hue){
  //  editor_slider_hue.setValue(hue(currentTileColor));
  //}
  
  //if(source != editor_slider_saturation){
  //  editor_slider_saturation.setValue(saturation(currentTileColor));
  //}
  
  //if(source != editor_slider_brightness){
  //  editor_slider_brightness.setValue(brightness(currentTileColor));
  //}
  
  //editor_slider_red.setValue(red(currentTileColor));
  //editor_slider_green.setValue(green(currentTileColor));
  //editor_slider_blue.setValue(blue(currentTileColor));
}

public void main_menu_button_handler(GImageButton source, GEvent event){
  if(event == GEvent.CLICKED){//GEvent.RELEASED, GEvent.PRESSED
    if(source == main_menu_button_DND){
      changeUI(_TILEMAPUI_);
    }else if(source == main_menu_button_OPTIONS){
      changeUI(_OPTIONSMENU_);
    }else if(source == main_menu_button_EXIT){
      exit();
    }else{
      //println("error");
    }
  }
}

public void menu_bar_button_handler(GImageButton source, GEvent event){
  if(event == GEvent.CLICKED){//GEvent.RELEASED, GEvent.PRESSED
    if(source == menu_bar_button_FILE){
      changeDisplayedMenuBar(button_menuBar_file);
    }else if(source == menu_bar_button_EDIT){
      changeDisplayedMenuBar(button_menuBar_edit);
    }else if(source == menu_bar_button_VIEW){
      changeDisplayedMenuBar(button_menuBar_view);
    }else if(source == menu_bar_button_COLOR){
      changeDisplayedMenuBar(button_menuBar_color);
    }else if(source == menu_bar_button_TOOLS){
      changeDisplayedMenuBar(button_menuBar_tools);
    }else if(source == menu_bar_button_HELP){
      changeDisplayedMenuBar(button_menuBar_help);
    }
  }
}

public void tilemap_button_handler(GImageButton source, GEvent event){
  if(event == GEvent.CLICKED){//GEvent.RELEASED, GEvent.PRESSED
    if(source == tilemap_button_PREV){
      tileMapShow--;//go to previous tile map
      if(tileMapShow < 0){//make sure we don't go below zero
        tileMapShow = tileMaps.size() - 1;//set to maxixmum tile map
      }
    }else if(source == tilemap_button_NEXT){
      tileMapShow++;//go to next tile map
      if(tileMapShow >= tileMaps.size()){//make sure we dont go above maximum tile map
        tileMapShow = 0;//set to 0
      }
    }else if(source == tilemap_button_LOADTILES){
      loadTileMap();//load selected tile map
      updateTileRow();//make sure we're on the correct row
      noTile = false;//allowed to place tiles
      changeUI(_EDITORUI_);//go to normal display
      screenX = tmpScreenX;//reload our position
      screenY = tmpScreenY;//reload our position
    }else if(source == tilemap_button_LOADMAP){
      noLoop();//don't allow drawing
      selectInput("Select a File to load:", "FileLoadMapSelect");//load a map
      while(loadingMap == true){delay(500);}//small delay
      loadTileMap();//load selected tile map
      updateTileRow();//make sure we're on the correct row
      noTile = false;//allowed to place tiles
      changeUI(_EDITORUI_);//normal screen
      screenX = tmpScreenX;//reload our position
      screenY = tmpScreenY;//reload our position
      loop();//allow drawing
    }
  }
}

class clickRect{
  float x;//button x position
  float y;//button y position
  float h;//button height
  float w;//button width
  
  int identifier;//button identifier
  
  clickRect(float x_, float y_, float w_, float h_, int identifier_){
    this.x = x_;
    this.y = y_;
    this.h = h_;
    this.w = w_;
    this.identifier = identifier_;
  }

  boolean wasClicked(){//are we clicking on a visible button
    return(mouseX > this.x + fudgeValue && mouseX < this.x + this.w - fudgeValue && mouseY > this.y + fudgeValue && mouseY < this.y + this.h - fudgeValue);//Are we clicking on the button
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------

class button extends clickRect{
  String t;//button text
  float tSize = 0;//button text size
  float tX;//button text x position
  float tY;//button text y position
  color bColor;//button background color
  color tColor;//button text color
  int image;//button image
  
  public button(float x_, float y_, float w_, float h_, color bC_, String t_, color tC_, float tS_, int identifier_, int image_){
    super(x_, y_, w_, h_, identifier_);
    
    this.bColor = bC_;
    
    this.t = t_;
    this.tColor = tC_;
    this.tSize = tS_;

    this.image = image_;
  }
  
  void setup(){
    if(this.tSize == 0){//if we've set text size to auto
      this.tSize = (this.h - 4) / 2;//figure out the available size and set the text size accordingly
    }
    this.tY = this.y + (this.h / 2) + 4;//figure out the text y position

    int tmp = floor((this.w - textWidth(this.t)) / 2);//try and figure out the text x position
    if(tmp < 0){
      this.tX = this.x - tmp;
    }else{
      this.tX = this.x + tmp;
    }
  }
  
  void draw(){
    stroke(color(255 - red(this.bColor), 255 - green(this.bColor), 255 - blue(this.bColor)));//set the outline to red
    strokeWeight(1);//small outline
    fill(this.bColor);//Set button background color
    rect(this.x, this.y, this.w, this.h);//draw button background
    
    textSize(this.tSize);//set text size
    fill(this.tColor);//Set button text color
    text(this.t, this.tX, this.tY);//draw button text
      
    //if(this.image != -1){//if the button has an image
      //image(gui[this.image], this.x, this.y);//draw it
    //}
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------

//void setButtonColorBack(int button_, color c_){//set a buttons background color
//  for(button b : buttons_editorUI){//go through all the buttons
//    if(b.identifier == button_){//if we've found our button
//      b.bColor = c_;//update its background color
//    }
//  }
//}

//---------------------------------------------------------------------------------------------------------------------------------------

//void setButtonColorText(int button_, color c_){//set a buttons text color
//  for(button b : buttons_editorUI){//go through all the buttons
//    if(b.identifier == button_){//if we've found our button
//      b.tColor = c_;//update its text color
//    }
//  }
//}

//---------------------------------------------------------------------------------------------------------------------------------------

void setButtonColors(int button_, color bC_, color tC_){//set a buttons text color
  for(button b : buttons_editorUI){//go through all the buttons
    if(b.identifier == button_){//if we've found our button
      b.bColor = bC_;//update its background color
      b.tColor = tC_;//update its text color
    }
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------

//void setButtonVis(int button, boolean vis){//set a buttons visibility
//  for(button b : buttons){//go through all the buttons
//    if(b.identifier == button){//if we've found our button
//      b.visible = vis;//update its visibility
//    }
//  }
//}

//---------------------------------------------------------------------------------------------------------------------------------------

//void setButtonPos(int button, int x, int y){//set a buttons xy position
//  for(button b : buttons){//go through all the buttons
//    if(b.identifier == button){//if we've found our button
//      b.x = x;//update its x position
//      b.y = y;//update its y position
//      b.setup();//update its properties so its text is drawn correctly
//    }
//  }
//}

//---------------------------------------------------------------------------------------------------------------------------------------

boolean checkButtons(){
  switch(currentUI){
    case _MAINMENU_:
      //mainMenuButton = -1;
      //for(clickRect b : buttons_mainMenuUI){
      //  if(b.wasClicked()){
      //    mainMenuButton = b.identifier;
      //    switch(b.identifier){
      //      case button_mainMenuUI_villagerPillager:
      //        //image(main_menu_button_selected,scl,scl + vpTop);
      //        text("not yet implemented", mouseX, mouseY);
      //        break;
          
      //      case button_mainMenuUI_dragNDraw:
      //        image(main_menu_button_selected,b.x,b.y);
      //        text("a tile based map maker", mouseX, mouseY);
      //        break;
          
      //      case button_mainMenuUI_playerFlayer:
      //        //image(main_menu_button_selected,scl,scl + pfTop);
      //        text("not yet implemented", mouseX, mouseY);
      //        break;
          
      //      case button_mainMenuUI_tileNStyle:
      //        //image(main_menu_button_selected,scl,scl + tnsTop);
      //        text("not yet implemented", mouseX, mouseY);
      //        break;
            
      //      case button_mainMenuUI_roleNPlay:
      //        //image(main_menu_button_selected,scl,scl + rnpTop);
      //        text("not yet implemented", mouseX, mouseY);
      //        break;
          
      //      case button_mainMenuUI_options:
      //        image(main_menu_button_selected,b.x,b.y);
      //        text("change things", mouseX, mouseY);
      //        break;
          
      //      case button_mainMenuUI_exit:
      //        image(main_menu_button_selected,b.x,b.y);
      //        text("exit the program", mouseX, mouseY);
      //        break;
      //    }
      //  }
      //}
      break;//_MAINMENU_ END

    case _TILEMAPUI_:
      //for(button b : buttons_tilemapUI){
      //  if(b.wasClicked()){
      //    switch(b.identifier){
      //      case button_tilemapUI_prevTileMap:
      //        tileMapShow--;//go to previous tile map
      //        if(tileMapShow < 0){//make sure we don't go below zero
      //          tileMapShow = tileMaps.size() - 1;//set to maxixmum tile map
      //        }
      //        return true;
          
      //      case button_tilemapUI_nextTileMap:
      //        tileMapShow++;//go to next tile map
      //        if(tileMapShow >= tileMaps.size()){//make sure we dont go above maximum tile map
      //          tileMapShow = 0;//set to 0
      //        }
      //        return true;
          
      //      case button_tilemapUI_loadTileMap:
      //        loadTileMap();//load selected tile map
      //        updateTileRow();//make sure we're on the correct row
      //        noTile = false;//allowed to place tiles
      //        changeUI(_EDITORUI_);//go to normal display
      //        screenX = tmpScreenX;//reload our position
      //        screenY = tmpScreenY;//reload our position
      //        return true;
          
      //      case button_tilemapUI_loadMapAndTileMap:
      //        noLoop();//don't allow drawing
      //        selectInput("Select a File to load:", "FileLoadMapSelect");//load a map
      //        while(loadingMap == true){delay(500);}//small delay
      //        loadTileMap();//load selected tile map
      //        updateTileRow();//make sure we're on the correct row
      //        noTile = false;//allowed to place tiles
      //        changeUI(_EDITORUI_);//normal screen
      //        screenX = tmpScreenX;//reload our position
      //        screenY = tmpScreenY;//reload our position
      //        loop();//allow drawing
      //        return true;
      //    }
      //  }
      //}
      break;//_TILEMAPUI_ END

    case _EDITORUI_:
      for(button b : buttons_editorUI){//go through all the buttons
        if(b.wasClicked()){//if we clicked this button
          switch(b.identifier){//go do whatever its function is
            case button_editorUI_hueWheelVis:
              colorWheel.setVisible(!colorWheel.isVisible());//invert visibility
              noTile = !noTile;//ivert whether tiles can be placed
              return true;
          
            case button_editorUI_rgbInputVis:
              RGBInputVis = !RGBInputVis;//invert visibility
              colorInputR.setVisible(RGBInputVis);//change visibility
              colorInputG.setVisible(RGBInputVis);//change visibility
              colorInputB.setVisible(RGBInputVis);//change visibility
              noKeyboard = !noKeyboard;//invert whether keyboard functions work
              noTile = !noTile;//ivert whether tiles can be placed
              return true;
          
            case button_editorUI_colorToggle:
              colorTiles = !colorTiles;//invert whether we're placing colored tile or not
              return true;
          
            case button_editorUI_changeTileMap:
              changeUI(_TILEMAPUI_);//tile map loading screen
              tmpScreenX = screenX;//save our position
              tmpScreenY = screenY;//save our position
              screenX = 0;//go back to the top left for looking at tile maps
              screenY = (UIBottom);//go back to the top left for looking at tile maps
              return true;
          
            case button_editorUI_newMap:
              clearMapTilesArray();//clear the map
              return true;
          
            case button_editorUI_saveMap:
              selectOutput("Select a file to write to:", "fileSaveMapSelect");//map save dialog
              return true;
          
            case button_editorUI_loadMap:
              selectInput("Select a file to load:", "FileLoadMapSelect");//map load dialog
              return true;
          
            case button_editorUI_saveImage:
              selectOutput("Select a PNG to write to:", "FileSaveCanvasSelect");//canvas save dialog
              return true;
          }
        }
      }
      
      //for(clickRect b : buttons_menuBar){
      //  if(b.wasClicked()){
      //    if(changeDisplayedMenuBar(b.identifier)){
      //      return true;
      //    }
      //    switch(b.identifier){
      //      case button_menuBar_file:
      //        println("file");
      //        return true;
          
      //      case button_menuBar_edit:
      //        println("edit");
      //        return true;
          
      //      case button_menuBar_view:
      //        println("view");
      //        return true;
          
      //      case button_menuBar_color:
      //        println("color");
      //        return true;
            
      //      case button_menuBar_tools:
      //        println("tools");
      //        return true;
          
      //      case button_menuBar_help:
      //        println("help");
      //        return true;
      //    }
      //  }
      //}
      //displayedMenuBar = -1;
      break;//_EDITORUI_ END
  }
  
  return false;
}

//---------------------------------------------------------------------------------------------------------------------------------------

boolean changeDisplayedMenuBar(int bar_){
  if(displayedMenuBar == bar_){
    displayedMenuBar = -1;
    return true;
  }
  displayedMenuBar = bar_;
  return false;
}