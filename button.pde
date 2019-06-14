GPanel main_menu_button_panel;
GImageButton main_menu_button_VP;
GImageButton main_menu_button_DND;
GImageButton main_menu_button_PF;
GImageButton main_menu_button_TNS;
GImageButton main_menu_button_RNP;
GImageButton main_menu_button_OPTIONS;
GImageButton main_menu_button_EXIT;

GButton editor_button_coloredToggle;
GButton editor_button_changeTileMap;

final int button_menuBar_NONE = -1;
final int button_menuBar_file = 0;
final int button_menuBar_edit = 1;
final int button_menuBar_view = 2;
final int button_menuBar_color = 3;
final int button_menuBar_tools = 4;
final int button_menuBar_help = 5;

GPanel menu_bar_button_panel;
int displayedMenuBar = button_menuBar_NONE;
GImageButton menu_bar_button_FILE;
GImageButton menu_bar_button_EDIT;
GImageButton menu_bar_button_VIEW;
GImageButton menu_bar_button_COLOR;
GImageButton menu_bar_button_TOOLS;
GImageButton menu_bar_button_HELP;

GPanel menu_bar_FILE_dropDown_panel;
GImageButton menu_bar_FILE_dropDown_NEW;
GImageButton menu_bar_FILE_dropDown_OPEN;
GImageButton menu_bar_FILE_dropDown_SAVE;
GImageButton menu_bar_FILE_dropDown_SAVEAS;
GImageButton menu_bar_FILE_dropDown_EXPORT;
GImageButton menu_bar_FILE_dropDown_EXIT;

GPanel menu_bar_EDIT_dropDown_panel;
GImageButton menu_bar_EDIT_dropDown_CUT;
GImageButton menu_bar_EDIT_dropDown_COPY;
GImageButton menu_bar_EDIT_dropDown_PASTE;

GPanel menu_bar_VIEW_dropDown_panel;
GImageButton menu_bar_VIEW_dropDown_VP;
GImageButton menu_bar_VIEW_dropDown_DND;
GImageButton menu_bar_VIEW_dropDown_PF;
GImageButton menu_bar_VIEW_dropDown_TNS;
GImageButton menu_bar_VIEW_dropDown_RNP;
GImageButton menu_bar_VIEW_dropDown_OPTIONS;

GPanel tilemap_button_panel;
GImageButton tilemap_button_PREV;
GImageButton tilemap_button_NEXT;
GButton tilemap_button_LOADTILES;
GButton tilemap_button_LOADMAP;

GPanel editor_colorTools_panel;
int editor_colorTools_panel_Width = UIscl * 11;
int editor_colorTools_panel_Height = UIscl * 10;
int currentColorSlider = -1;
GCustomSlider editor_slider_red;
GCustomSlider editor_slider_green;
GCustomSlider editor_slider_blue;
GCustomSlider editor_slider_hue;
GCustomSlider editor_slider_saturation;
GCustomSlider editor_slider_brightness;

PImage alphaBack;
PImage hueBack;

PGraphics tmpGradient;

GLabel redLabel;
GLabel greenLabel;
GLabel blueLabel;

GLabel hueLabel;
GLabel saturationLabel;
GLabel brightnessLabel;

GLabel alphaLabel;

//GTextField textfield1;//GEvents.CHANGED, ENTERED, SELECTION_CHANGED, GETS_FOCUS, LOST_FOCUS

public void createGUI(){
  G4P.messagesEnabled(false);
  GButton.useRoundCorners(false);
  G4P.mouseWheelDirection(G4P.REVERSE);
  main_menu_button_panel = new GPanel(this, 0, 0, 1, 1, "");
  main_menu_button_panel.setCollapsible(false);
  main_menu_button_panel.setDraggable(false);
  main_menu_button_panel.setOpaque(false);
  //main_menu_panel.addEventHandler(this, "main_menu_panel");
  
  File menuButtonsDir = new File(programDirectory + "/assets/buttons/main menu/");
  main_menu_button_VP = new GImageButton(this, 0, 0, new String[] {menuButtonsDir + "/main_menu_VP_normal.png", menuButtonsDir + "/main_menu_VP_mouseOver.png", menuButtonsDir + "/main_menu_VP_pressed.png"});
  main_menu_button_VP.addEventHandler(this, "main_menu_button_handler");
  main_menu_button_DND = new GImageButton(this, 0, 64, new String[] {menuButtonsDir + "/main_menu_DND_normal.png", menuButtonsDir + "/main_menu_DND_mouseOver.png", menuButtonsDir + "/main_menu_DND_pressed.png"});
  main_menu_button_DND.addEventHandler(this, "main_menu_button_handler");
  main_menu_button_PF = new GImageButton(this, 0, 128, new String[] {menuButtonsDir + "/main_menu_PF_normal.png", menuButtonsDir + "/main_menu_PF_mouseOver.png", menuButtonsDir + "/main_menu_PF_pressed.png"});
  main_menu_button_PF.addEventHandler(this, "main_menu_button_handler");
  main_menu_button_TNS = new GImageButton(this, 0, 192, new String[] {menuButtonsDir + "/main_menu_TNS_normal.png", menuButtonsDir + "/main_menu_TNS_mouseOver.png", menuButtonsDir + "/main_menu_TNS_pressed.png"});
  main_menu_button_TNS.addEventHandler(this, "main_menu_button_handler");
  main_menu_button_RNP = new GImageButton(this, 0, 256, new String[] {menuButtonsDir + "/main_menu_RNP_normal.png", menuButtonsDir + "/main_menu_RNP_mouseOver.png", menuButtonsDir + "/main_menu_RNP_pressed.png"});
  main_menu_button_RNP.addEventHandler(this, "main_menu_button_handler");
  main_menu_button_OPTIONS = new GImageButton(this, 0, 320, new String[] {menuButtonsDir + "/main_menu_OPTIONS_normal.png", menuButtonsDir + "/main_menu_OPTIONS_mouseOver.png", menuButtonsDir + "/main_menu_OPTIONS_pressed.png"});
  main_menu_button_OPTIONS.addEventHandler(this, "main_menu_button_handler");
  main_menu_button_EXIT = new GImageButton(this, 0, 384, new String[] {menuButtonsDir + "/main_menu_EXIT_normal.png", menuButtonsDir + "/main_menu_EXIT_mouseOver.png", menuButtonsDir + "/main_menu_EXIT_pressed.png"});
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
  
  float tmpX = 0;
  File barButtonsDir = new File(programDirectory + "/assets/buttons/menu bar/");
  menu_bar_button_FILE = new GImageButton(this, tmpX, 0, new String[] {barButtonsDir + "/menu_bar_FILE.png", barButtonsDir + "/menu_bar_FILE_mouseOver.png"});
  menu_bar_button_FILE.addEventHandler(this, "menu_bar_button_handler");
  tmpX = menu_bar_button_FILE.getWidth();
  menu_bar_button_EDIT = new GImageButton(this, tmpX, 0, new String[] {barButtonsDir + "/menu_bar_EDIT.png", barButtonsDir + "/menu_bar_EDIT_mouseOver.png"});
  menu_bar_button_EDIT.addEventHandler(this, "menu_bar_button_handler");
  tmpX = tmpX + menu_bar_button_EDIT.getWidth();
  menu_bar_button_VIEW = new GImageButton(this, tmpX, 0, new String[] {barButtonsDir + "/menu_bar_VIEW.png", barButtonsDir + "/menu_bar_VIEW_mouseOver.png"});
  menu_bar_button_VIEW.addEventHandler(this, "menu_bar_button_handler");
  tmpX = tmpX + menu_bar_button_VIEW.getWidth();
  menu_bar_button_COLOR = new GImageButton(this, tmpX, 0, new String[] {barButtonsDir + "/menu_bar_COLOR.png", barButtonsDir + "/menu_bar_COLOR_mouseOver.png"});
  menu_bar_button_COLOR.addEventHandler(this, "menu_bar_button_handler");
  tmpX = tmpX + menu_bar_button_COLOR.getWidth();
  menu_bar_button_TOOLS = new GImageButton(this, tmpX, 0, new String[] {barButtonsDir + "/menu_bar_TOOLS.png", barButtonsDir + "/menu_bar_TOOLS_mouseOver.png"});
  menu_bar_button_TOOLS.addEventHandler(this, "menu_bar_button_handler");
  tmpX = tmpX + menu_bar_button_TOOLS.getWidth();
  menu_bar_button_HELP = new GImageButton(this, tmpX, 0, new String[] {barButtonsDir + "/menu_bar_HELP.png", barButtonsDir + "/menu_bar_HELP_mouseOver.png"});
  menu_bar_button_HELP.addEventHandler(this, "menu_bar_button_handler");
  menu_bar_button_panel.addControl(menu_bar_button_FILE);
  menu_bar_button_panel.addControl(menu_bar_button_EDIT);
  menu_bar_button_panel.addControl(menu_bar_button_VIEW);
  menu_bar_button_panel.addControl(menu_bar_button_COLOR);
  menu_bar_button_panel.addControl(menu_bar_button_TOOLS);
  menu_bar_button_panel.addControl(menu_bar_button_HELP);
  
  float tmpY = 0;
  File fileButtonsDir = new File(programDirectory + "/assets/buttons/menu bar/file dropdown/");
  menu_bar_FILE_dropDown_NEW = new GImageButton(this, 0, tmpY, new String[] {fileButtonsDir + "/menu_bar_FILE_NEW.png", fileButtonsDir + "/menu_bar_FILE_NEW_mouseOver.png"});
  menu_bar_FILE_dropDown_NEW.addEventHandler(this, "menu_bar_FILE_dropDown_button_handler");
  tmpY = menu_bar_FILE_dropDown_NEW.getHeight();
  menu_bar_FILE_dropDown_OPEN = new GImageButton(this, 0, tmpY, new String[] {fileButtonsDir + "/menu_bar_FILE_OPEN.png", fileButtonsDir + "/menu_bar_FILE_OPEN_mouseOver.png"});
  menu_bar_FILE_dropDown_OPEN.addEventHandler(this, "menu_bar_FILE_dropDown_button_handler");
  tmpY = tmpY + menu_bar_FILE_dropDown_OPEN.getHeight();
  menu_bar_FILE_dropDown_SAVE = new GImageButton(this, 0, tmpY, new String[] {fileButtonsDir + "/menu_bar_FILE_SAVE.png", fileButtonsDir + "/menu_bar_FILE_SAVE_mouseOver.png"});
  menu_bar_FILE_dropDown_SAVE.addEventHandler(this, "menu_bar_FILE_dropDown_button_handler");
  tmpY = tmpY + menu_bar_FILE_dropDown_SAVE.getHeight();
  menu_bar_FILE_dropDown_SAVEAS = new GImageButton(this, 0, tmpY, new String[] {fileButtonsDir + "/menu_bar_FILE_SAVEAS.png", fileButtonsDir + "/menu_bar_FILE_SAVEAS_mouseOver.png"});
  menu_bar_FILE_dropDown_SAVEAS.addEventHandler(this, "menu_bar_FILE_dropDown_button_handler");
  tmpY = tmpY + menu_bar_FILE_dropDown_SAVEAS.getHeight();
  menu_bar_FILE_dropDown_EXPORT = new GImageButton(this, 0, tmpY, new String[] {fileButtonsDir + "/menu_bar_FILE_EXPORT.png", fileButtonsDir + "/menu_bar_FILE_EXPORT_mouseOver.png"});
  menu_bar_FILE_dropDown_EXPORT.addEventHandler(this, "menu_bar_FILE_dropDown_button_handler");
  tmpY = tmpY + menu_bar_FILE_dropDown_EXPORT.getHeight();
  menu_bar_FILE_dropDown_EXIT = new GImageButton(this, 0, tmpY, new String[] {fileButtonsDir + "/menu_bar_FILE_EXIT.png", fileButtonsDir + "/menu_bar_FILE_EXIT_mouseOver.png"});
  menu_bar_FILE_dropDown_EXIT.addEventHandler(this, "menu_bar_FILE_dropDown_button_handler");
  menu_bar_FILE_dropDown_panel = new GPanel(this, 0, menu_bar_button_FILE.getHeight(), menu_bar_FILE_dropDown_EXPORT.getX() + menu_bar_FILE_dropDown_EXPORT.getWidth(), menu_bar_FILE_dropDown_EXPORT.getY() + menu_bar_FILE_dropDown_EXPORT.getHeight() + scl, "");
  menu_bar_FILE_dropDown_panel.setCollapsible(false);
  menu_bar_FILE_dropDown_panel.setDraggable(false);
  menu_bar_FILE_dropDown_panel.setOpaque(false);
  menu_bar_FILE_dropDown_panel.addControl(menu_bar_FILE_dropDown_NEW);
  menu_bar_FILE_dropDown_panel.addControl(menu_bar_FILE_dropDown_OPEN);
  menu_bar_FILE_dropDown_panel.addControl(menu_bar_FILE_dropDown_SAVE);
  menu_bar_FILE_dropDown_panel.addControl(menu_bar_FILE_dropDown_SAVEAS);
  menu_bar_FILE_dropDown_panel.addControl(menu_bar_FILE_dropDown_EXPORT);
  menu_bar_FILE_dropDown_panel.addControl(menu_bar_FILE_dropDown_EXIT);
  
  tmpY = 0;
  File editButtonsDir = new File(programDirectory + "/assets/buttons/menu bar/edit dropdown/");
  menu_bar_EDIT_dropDown_CUT = new GImageButton(this, 0, tmpY, new String[] {editButtonsDir + "/menu_bar_EDIT_CUT.png", editButtonsDir + "/menu_bar_EDIT_CUT_mouseOver.png"});
  menu_bar_EDIT_dropDown_CUT.addEventHandler(this, "menu_bar_EDIT_dropDown_button_handler");
  tmpY = menu_bar_EDIT_dropDown_CUT.getHeight();
  menu_bar_EDIT_dropDown_COPY = new GImageButton(this, 0, tmpY, new String[] {editButtonsDir + "/menu_bar_EDIT_COPY.png", editButtonsDir + "/menu_bar_EDIT_COPY_mouseOver.png"});
  menu_bar_EDIT_dropDown_COPY.addEventHandler(this, "menu_bar_EDIT_dropDown_button_handler");
  tmpY = tmpY + menu_bar_EDIT_dropDown_COPY.getHeight();
  menu_bar_EDIT_dropDown_PASTE = new GImageButton(this, 0, tmpY, new String[] {editButtonsDir + "/menu_bar_EDIT_PASTE.png", editButtonsDir + "/menu_bar_EDIT_PASTE_mouseOver.png"});
  menu_bar_EDIT_dropDown_PASTE.addEventHandler(this, "menu_bar_EDIT_dropDown_button_handler");
  menu_bar_EDIT_dropDown_panel = new GPanel(this, menu_bar_button_FILE.getWidth(), menu_bar_button_EDIT.getHeight(), menu_bar_EDIT_dropDown_PASTE.getX() + menu_bar_EDIT_dropDown_PASTE.getWidth(), menu_bar_EDIT_dropDown_PASTE.getY() + menu_bar_EDIT_dropDown_PASTE.getHeight() + scl, "");
  menu_bar_EDIT_dropDown_panel.setCollapsible(false);
  menu_bar_EDIT_dropDown_panel.setDraggable(false);
  menu_bar_EDIT_dropDown_panel.setOpaque(false);
  menu_bar_EDIT_dropDown_panel.addControl(menu_bar_EDIT_dropDown_CUT);
  menu_bar_EDIT_dropDown_panel.addControl(menu_bar_EDIT_dropDown_COPY);
  menu_bar_EDIT_dropDown_panel.addControl(menu_bar_EDIT_dropDown_PASTE);
  
  tmpY = 0;
  File viewButtonsDir = new File(programDirectory + "/assets/buttons/menu bar/view dropdown/");
  menu_bar_VIEW_dropDown_VP = new GImageButton(this, 0, tmpY, new String[] {viewButtonsDir + "/menu_bar_VIEW_VP.png", viewButtonsDir + "/menu_bar_VIEW_VP_mouseOver.png"});
  menu_bar_VIEW_dropDown_VP.addEventHandler(this, "menu_bar_VIEW_dropDown_button_handler");
  tmpY = menu_bar_VIEW_dropDown_VP.getHeight();
  menu_bar_VIEW_dropDown_DND = new GImageButton(this, 0, tmpY, new String[] {viewButtonsDir + "/menu_bar_VIEW_DND.png", viewButtonsDir + "/menu_bar_VIEW_DND_mouseOver.png"});
  menu_bar_VIEW_dropDown_DND.addEventHandler(this, "menu_bar_VIEW_dropDown_button_handler");
  tmpY = tmpY + menu_bar_VIEW_dropDown_DND.getHeight();
  menu_bar_VIEW_dropDown_PF = new GImageButton(this, 0, tmpY, new String[] {viewButtonsDir + "/menu_bar_VIEW_PF.png", viewButtonsDir + "/menu_bar_VIEW_PF_mouseOver.png"});
  menu_bar_VIEW_dropDown_PF.addEventHandler(this, "menu_bar_VIEW_dropDown_button_handler");
  tmpY = tmpY + menu_bar_VIEW_dropDown_PF.getHeight();
  menu_bar_VIEW_dropDown_TNS = new GImageButton(this, 0, tmpY, new String[] {viewButtonsDir + "/menu_bar_VIEW_TNS.png", viewButtonsDir + "/menu_bar_VIEW_TNS_mouseOver.png"});
  menu_bar_VIEW_dropDown_TNS.addEventHandler(this, "menu_bar_VIEW_dropDown_button_handler");
  tmpY = tmpY + menu_bar_VIEW_dropDown_TNS.getHeight();
  menu_bar_VIEW_dropDown_RNP = new GImageButton(this, 0, tmpY, new String[] {viewButtonsDir + "/menu_bar_VIEW_RNP.png", viewButtonsDir + "/menu_bar_VIEW_RNP_mouseOver.png"});
  menu_bar_VIEW_dropDown_RNP.addEventHandler(this, "menu_bar_VIEW_dropDown_button_handler");
  tmpY = tmpY + menu_bar_VIEW_dropDown_RNP.getHeight();
  menu_bar_VIEW_dropDown_OPTIONS = new GImageButton(this, 0, tmpY, new String[] {viewButtonsDir + "/menu_bar_VIEW_OPTIONS.png", viewButtonsDir + "/menu_bar_VIEW_OPTIONS_mouseOver.png"});
  menu_bar_VIEW_dropDown_OPTIONS.addEventHandler(this, "menu_bar_VIEW_dropDown_button_handler");
  menu_bar_VIEW_dropDown_panel = new GPanel(this, menu_bar_button_FILE.getWidth() + menu_bar_button_EDIT.getWidth(), menu_bar_button_VIEW.getHeight(), menu_bar_VIEW_dropDown_OPTIONS.getX() + menu_bar_VIEW_dropDown_OPTIONS.getWidth(), menu_bar_VIEW_dropDown_OPTIONS.getY() + menu_bar_VIEW_dropDown_OPTIONS.getHeight() + scl, "");
  menu_bar_VIEW_dropDown_panel.setCollapsible(false);
  menu_bar_VIEW_dropDown_panel.setDraggable(false);
  menu_bar_VIEW_dropDown_panel.setOpaque(false);
  menu_bar_VIEW_dropDown_panel.addControl(menu_bar_VIEW_dropDown_VP);
  menu_bar_VIEW_dropDown_panel.addControl(menu_bar_VIEW_dropDown_DND);
  menu_bar_VIEW_dropDown_panel.addControl(menu_bar_VIEW_dropDown_PF);
  menu_bar_VIEW_dropDown_panel.addControl(menu_bar_VIEW_dropDown_TNS);
  menu_bar_VIEW_dropDown_panel.addControl(menu_bar_VIEW_dropDown_RNP);
  menu_bar_VIEW_dropDown_panel.addControl(menu_bar_VIEW_dropDown_OPTIONS);
  
  tilemap_button_panel = new GPanel(this, 0, 0, 1, 1, "");
  tilemap_button_panel.setCollapsible(false);
  tilemap_button_panel.setDraggable(false);
  tilemap_button_panel.setOpaque(false);
  tilemap_button_PREV = new GImageButton(this, 0, 0, new String[] {"assets/buttons/left_arrow_blue.png"});
  tilemap_button_PREV.addEventHandler(this, "tilemap_imageButton_handler");
  tilemap_button_NEXT = new GImageButton(this, UIscl * 2, 0, new String[] {"assets/buttons/right_arrow.png"});
  tilemap_button_NEXT.addEventHandler(this, "tilemap_imageButton_handler");
  tilemap_button_LOADTILES = new GButton(this, UIscl * 4, 0, UIscl * 3 + 1, UIscl + 1, "Load Tile Map");
  tilemap_button_LOADTILES.addEventHandler(this, "tilemap_button_handler");
  tilemap_button_LOADMAP = new GButton(this, UIscl * 8, 0, UIscl * 2 + 1, UIscl + 1, "Load Map");
  tilemap_button_LOADMAP.addEventHandler(this, "tilemap_button_handler");
  tilemap_button_panel.addControl(tilemap_button_PREV);
  tilemap_button_panel.addControl(tilemap_button_NEXT);
  tilemap_button_panel.addControl(tilemap_button_LOADTILES);
  tilemap_button_panel.addControl(tilemap_button_LOADMAP);
  
  editor_colorTools_panel = new GPanel(this, UIscl * 16, 0, editor_colorTools_panel_Width, editor_colorTools_panel_Height, "color tools");
  editor_colorTools_panel.addEventHandler(this, "editor_colorTools_panel_handler");
  editor_colorTools_panel.setCollapsed(true);
  
  File customSlider = new File(programDirectory + "/assets/sliders/blank3/");
  String customSliderPath = customSlider.getAbsolutePath();
  
  editor_slider_red = new GCustomSlider(this, 204, 20, 122, 16, customSliderPath);
  editor_slider_red.setLimits(127, 0, 255);
  editor_slider_red.addEventHandler(this, "editor_RGBSlider_handler");
  
  editor_slider_green = new GCustomSlider(this, 204, 36, 122, 16, customSliderPath);
  editor_slider_green.setLimits(127, 0, 255);
  editor_slider_green.addEventHandler(this, "editor_RGBSlider_handler");
  
  editor_slider_blue = new GCustomSlider(this, 204, 52, 122, 16, customSliderPath);
  editor_slider_blue.setLimits(127, 0, 255);
  editor_slider_blue.addEventHandler(this, "editor_RGBSlider_handler");
  //1 = ticks, 2 = text color, 3 = thumb/border, 4 = ticks, 5 = surface, 6 = background, 11 = thumb, 14 = thumb, 15 = thumb
  
  colorMode(HSB, 255);
  
  editor_slider_hue = new GCustomSlider(this, 204, 84, 122, 16, customSliderPath);
  editor_slider_hue.setLimits(127, 0, 255);
  editor_slider_hue.addEventHandler(this, "editor_HSBSlider_handler");
  
  editor_slider_saturation = new GCustomSlider(this, 204, 100, 122, 16, customSliderPath);
  editor_slider_saturation.setLimits(127, 0, 255);
  editor_slider_saturation.addEventHandler(this, "editor_HSBSlider_handler");
  
  editor_slider_brightness = new GCustomSlider(this, 204, 116, 122, 16, customSliderPath);
  editor_slider_brightness.setLimits(127, 0, 255);
  editor_slider_brightness.addEventHandler(this, "editor_HSBSlider_handler");
  
  colorMode(RGB, 255);
  
  editor_slider_red.setValue(red(currentTileColor));
  editor_slider_green.setValue(green(currentTileColor));
  editor_slider_blue.setValue(blue(currentTileColor));
  editor_slider_hue.setValue(hue(currentTileColor));
  editor_slider_saturation.setValue(saturation(currentTileColor));
  editor_slider_brightness.setValue(brightness(currentTileColor));
  
  editor_colorTools_panel.addControl(editor_slider_red);
  editor_colorTools_panel.addControl(editor_slider_green);
  editor_colorTools_panel.addControl(editor_slider_blue);
  editor_colorTools_panel.addControl(editor_slider_hue);
  editor_colorTools_panel.addControl(editor_slider_saturation);
  editor_colorTools_panel.addControl(editor_slider_brightness);
  
  editor_button_coloredToggle = new GButton(this, UIscl * 8, 0, UIscl + 8, UIscl + 1, "Color");
  editor_button_coloredToggle.addEventHandler(this, "editor_button_handler");
  editor_button_changeTileMap = new GButton(this, editor_button_coloredToggle.getX() + editor_button_coloredToggle.getWidth() + UIscl * 2, 0, UIscl * 3 + 16, UIscl + 1, "Change Tile Map");
  editor_button_changeTileMap.addEventHandler(this, "editor_button_handler");
  
  
  
  tmpGradient = createGraphics(100,16);
  
  redLabel = new GLabel(this, 215, 20, 100, 16, "");
  greenLabel = new GLabel(this, 215, 36, 100, 16, "");
  blueLabel = new GLabel(this, 215, 52, 100, 16, "");
  
  hueLabel = new GLabel(this, 215, 84, 100, 16, "");
  saturationLabel = new GLabel(this, 215, 100, 100, 16, "");
  brightnessLabel = new GLabel(this, 215, 116, 100, 16, "");
  
  hueLabel.setIcon(hueBack, 1, null, null);
  
  alphaLabel = new GLabel(this, 215, 340, 100, 16, "");
  
  editor_colorTools_panel.addControl(redLabel);
  editor_colorTools_panel.addControl(greenLabel);
  editor_colorTools_panel.addControl(blueLabel);
  editor_colorTools_panel.addControl(hueLabel);
  editor_colorTools_panel.addControl(saturationLabel);
  editor_colorTools_panel.addControl(brightnessLabel);
  editor_colorTools_panel.addControl(alphaLabel);
}

//public void main_menu_panel(GImageButton source, GEvent event) {}

public void editor_button_handler(GButton source, GEvent event){
  if(event == GEvent.CLICKED){//GEvent.RELEASED, GEvent.PRESSED
    if(source == editor_button_coloredToggle){
      colorTiles = !colorTiles;//invert whether we're placing colored tile or not
    }else if(source == editor_button_changeTileMap){
      changeUI(_TILEMAPUI_);//tile map loading screen
      tmpScreenX = screenX;//save our position
      tmpScreenY = screenY;//save our position
      screenX = 0;//go back to the top left for looking at tile maps
      screenY = (0);//go back to the top left for looking at tile maps
    }else{
      //println("error");
    }
  }
}

public void editor_colorTools_panel_handler(GPanel source, GEvent event){
  //GEvent.COLLAPSED, EXPANDED, DRAGGED
  if(event == GEvent.COLLAPSED){
    colorWheel.setVisible(false);
    colorInputR.setVisible(false);//change visibility
    colorInputG.setVisible(false);//change visibility
    colorInputB.setVisible(false);//change visibility
  }else if(event == GEvent.EXPANDED){
    colorWheel.setPosition(editor_colorTools_panel.getX() + 1, editor_colorTools_panel.getY() + 20);
    colorWheel.setVisible(true);
    colorInputR.setVisible(true);//change visibility
    colorInputG.setVisible(true);//change visibility
    colorInputB.setVisible(true);//change visibility
    colorWheel.setPosition(editor_colorTools_panel.getX() + 1, editor_colorTools_panel.getY() + 20);
    colorInputR.setPosition(editor_colorTools_panel.getX() + (UIscl * 6.5), editor_colorTools_panel.getY() + 20 + 132);
    colorInputG.setPosition(editor_colorTools_panel.getX() + (UIscl * 6.5), editor_colorTools_panel.getY() + 20 + 148);
    colorInputB.setPosition(editor_colorTools_panel.getX() + (UIscl * 6.5), editor_colorTools_panel.getY() + 20 + 164);
  }else if(event == GEvent.DRAGGED){
    colorWheel.setPosition(editor_colorTools_panel.getX() + 1, editor_colorTools_panel.getY() + 20);
    colorInputR.setPosition(editor_colorTools_panel.getX() + (UIscl * 6.5), editor_colorTools_panel.getY() + 20 + 132);
    colorInputG.setPosition(editor_colorTools_panel.getX() + (UIscl * 6.5), editor_colorTools_panel.getY() + 20 + 148);
    colorInputB.setPosition(editor_colorTools_panel.getX() + (UIscl * 6.5), editor_colorTools_panel.getY() + 20 + 164);
  }
}

public void editor_RGBSlider_handler(GCustomSlider source, GEvent event){
  //GEvent.VALUE_STEADY
  //println(event);
  
  if(currentColorSlider == 3){
    currentTileColor = color(editor_slider_red.getValueF(),green(currentTileColor),blue(currentTileColor));
  }
  if(currentColorSlider == 4){
    currentTileColor = color(red(currentTileColor),editor_slider_green.getValueF(),blue(currentTileColor));
  }
  if(currentColorSlider == 5){
    currentTileColor = color(red(currentTileColor),green(currentTileColor),editor_slider_blue.getValueF());
  }
  
  if(currentColorSlider == 3 || currentColorSlider == 4 || currentColorSlider == 5){
    editor_slider_hue.setValue(hue(currentTileColor));
    editor_slider_saturation.setValue(saturation(currentTileColor));
    editor_slider_brightness.setValue(brightness(currentTileColor));
    UIControls.get(ColorWheel.class,"colorWheel").setRGB(currentTileColor);
  }
  
  if(source == editor_slider_red && currentColorSlider == -1){
    currentColorSlider = 3;
  }
  
  if(source == editor_slider_green && currentColorSlider == -1){
    currentColorSlider = 4;
  }
  
  if(source == editor_slider_blue && currentColorSlider == -1){
    currentColorSlider = 5;
  }
  
  //updateSliderBackgrounds();
}

public void editor_HSBSlider_handler(GCustomSlider source, GEvent event){
  //GEvent.VALUE_STEADY
  colorMode(HSB, 255);
  if(currentColorSlider == 0){
    currentTileColor = color(editor_slider_hue.getValueF(),saturation(currentTileColor),brightness(currentTileColor));
  }
  if(currentColorSlider == 1){
    currentTileColor = color(hue(currentTileColor),editor_slider_saturation.getValueF(),brightness(currentTileColor));
  }
  if(currentColorSlider == 2){
    currentTileColor = color(hue(currentTileColor),saturation(currentTileColor),editor_slider_brightness.getValueF());
  }
  colorMode(RGB, 255);
  
  if(currentColorSlider == 0 || currentColorSlider == 1 || currentColorSlider == 2){
    editor_slider_red.setValue(red(currentTileColor));
    editor_slider_green.setValue(green(currentTileColor));
    editor_slider_blue.setValue(blue(currentTileColor));
    UIControls.get(ColorWheel.class,"colorWheel").setRGB(currentTileColor);
  }
  
  if(source == editor_slider_hue && currentColorSlider == -1){
    currentColorSlider = 0;
  }
  
  if(source == editor_slider_saturation && currentColorSlider == -1){
    currentColorSlider = 1;
  }
  
  if(source == editor_slider_brightness && currentColorSlider == -1){
    currentColorSlider = 2;
  }
  
  //updateSliderBackgrounds();
}

void updateSliderBackgrounds(){
  drawRedGradient();
  redLabel.setIcon(tmpGradient, 1, null, null);
  
  drawGreenGradient();
  greenLabel.setIcon(tmpGradient, 1, null, null);
  
  drawBlueGradient();
  blueLabel.setIcon(tmpGradient, 1, null, null);
  
  
  drawSaturationGradient();
  saturationLabel.setIcon(tmpGradient, 1, null, null);
  
  drawBrightnessGradient();
  brightnessLabel.setIcon(tmpGradient, 1, null, null);
  
  
  drawAlphaGradient();
  alphaLabel.setIcon(tmpGradient, 1, null, null);
}

public void main_menu_button_handler(GImageButton source, GEvent event){
  if(event == GEvent.CLICKED){//GEvent.RELEASED, GEvent.PRESSED
    if(source == main_menu_button_DND){
      changeUI(_TILEMAPUI_);
    }else if(source == main_menu_button_OPTIONS){
      changeUI(_OPTIONSMENU_);
    }else if(source == main_menu_button_EXIT){
      _EXIT_ = true;
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

public void menu_bar_FILE_dropDown_button_handler(GImageButton source, GEvent event){
  if(event == GEvent.CLICKED){//GEvent.RELEASED, GEvent.PRESSED
    changeDisplayedMenuBar(button_menuBar_NONE);
    if(source == menu_bar_FILE_dropDown_NEW){
      clearMapTilesArray();//clear the map
      clearClickableTilesArray();//clear the map
    }else if(source == menu_bar_FILE_dropDown_OPEN){
      selectInput("Select a file to load:", "FileLoadMapSelect");//map load dialog
    }else if(source == menu_bar_FILE_dropDown_SAVE){
      if(fileName.equals("Error")){//if no file was selected
        selectOutput("Select a file to write to:", "fileSaveMapSelect");//map save dialog
      }else{
        fileSaveMap();
      }
    }else if(source == menu_bar_FILE_dropDown_SAVEAS){
      selectOutput("Select a file to write to:", "fileSaveMapSelect");//map save dialog
    }else if(source == menu_bar_FILE_dropDown_EXPORT){
      selectOutput("Select a PNG to write to:", "FileSaveCanvasSelect");//canvas save dialog
    }else if(source == menu_bar_FILE_dropDown_EXIT){
      _EXIT_ = true;
      exit();
    }else{
      //println("error");
    }
  }
}

public void menu_bar_EDIT_dropDown_button_handler(GImageButton source, GEvent event){
  if(event == GEvent.CLICKED){//GEvent.RELEASED, GEvent.PRESSED
    changeDisplayedMenuBar(button_menuBar_NONE);
    if(source == menu_bar_EDIT_dropDown_CUT){
      if(tileGroupStep == 2){//we're on step two of group selection
        tileGroupCutCopy('x');//cut group selection
      }
    }else if(source == menu_bar_EDIT_dropDown_COPY){
      if(tileGroupStep == 2){//we're on step two of group selection
        tileGroupCutCopy('c');//copy group selection
      }
    }else if(source == menu_bar_EDIT_dropDown_PASTE){
      if(tileGroupStep != 3){//set it up for pasting
        tileGroupStep = 3;//paste step is 3
      }else if(tileGroupStep == 3){//cancel pasting
        tileGroupStep = 0;//paste step is 0
      }
    }else{
      //println("error");
    }
  }
}

public void menu_bar_VIEW_dropDown_button_handler(GImageButton source, GEvent event){
  if(event == GEvent.CLICKED){//GEvent.RELEASED, GEvent.PRESSED
    changeDisplayedMenuBar(button_menuBar_NONE);
    if(source == menu_bar_VIEW_dropDown_VP){
      
    }else if(source == menu_bar_VIEW_dropDown_DND){
      changeUI(_TILEMAPUI_);//tile map loading screen
    }else if(source == menu_bar_VIEW_dropDown_PF){
      
    }else if(source == menu_bar_VIEW_dropDown_TNS){
      
    }else if(source == menu_bar_VIEW_dropDown_RNP){
      
    }else if(source == menu_bar_VIEW_dropDown_OPTIONS){
      changeUI(_OPTIONSMENU_);
    }else{
      //println("error");
    }
  }
}

public void tilemap_imageButton_handler(GImageButton source, GEvent event){
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
    }
  }
}

public void tilemap_button_handler(GButton source, GEvent event){
  if(event == GEvent.CLICKED){//GEvent.RELEASED, GEvent.PRESSED
    if(source == tilemap_button_LOADTILES){
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

boolean mouseOver_colorToolsPanel(){
  boolean Xinside = false;
  boolean Yinside = false;
  boolean inside = false;
  
  if(mouseX > editor_colorTools_panel.getX()){
    if(editor_colorTools_panel.isCollapsed()){
      
    }else if(mouseX < editor_colorTools_panel.getX() + editor_colorTools_panel.getWidth()){
      Xinside = true;
    }
  }
  
  if(mouseY > editor_colorTools_panel.getY()){
    if(editor_colorTools_panel.isCollapsed()){
      
    }else if(mouseY < editor_colorTools_panel.getY() + editor_colorTools_panel.getHeight()){
      Yinside = true;
    }
  }
  
  inside = editor_colorTools_panel.isOver(mouseX, mouseY) || editor_colorTools_panel.isDragging();
  
  return (Xinside && Yinside) || inside;
}

boolean mouseOver_FILEdropDownPanel(){
  boolean Xinside = false;
  boolean Yinside = false;
  boolean inside = false;
  
  if(mouseX > menu_bar_FILE_dropDown_panel.getX()){
    if(menu_bar_FILE_dropDown_panel.isCollapsed()){
      
    }else if(mouseX < menu_bar_FILE_dropDown_panel.getX() + menu_bar_FILE_dropDown_panel.getWidth()){
      Xinside = true;
    }
  }
  
  if(mouseY > menu_bar_FILE_dropDown_panel.getY()){
    if(menu_bar_FILE_dropDown_panel.isCollapsed()){
      
    }else if(mouseY < menu_bar_FILE_dropDown_panel.getY() + menu_bar_FILE_dropDown_panel.getHeight() + fudgeValue){
      Yinside = true;
    }
  }
  
  inside = menu_bar_FILE_dropDown_panel.isOver(mouseX, mouseY) || menu_bar_FILE_dropDown_panel.isDragging();
  
  return ((Xinside && Yinside) || inside) && menu_bar_FILE_dropDown_panel.isVisible();
}

boolean mouseOver_EDITdropDownPanel(){
  boolean Xinside = false;
  boolean Yinside = false;
  boolean inside = false;
  
  if(mouseX > menu_bar_EDIT_dropDown_panel.getX()){
    if(menu_bar_EDIT_dropDown_panel.isCollapsed()){
      
    }else if(mouseX < menu_bar_EDIT_dropDown_panel.getX() + menu_bar_EDIT_dropDown_panel.getWidth()){
      Xinside = true;
    }
  }
  
  if(mouseY > menu_bar_EDIT_dropDown_panel.getY()){
    if(menu_bar_EDIT_dropDown_panel.isCollapsed()){
      
    }else if(mouseY < menu_bar_EDIT_dropDown_panel.getY() + menu_bar_EDIT_dropDown_panel.getHeight() + fudgeValue){
      Yinside = true;
    }
  }
  
  inside = menu_bar_EDIT_dropDown_panel.isOver(mouseX, mouseY) || menu_bar_EDIT_dropDown_panel.isDragging();
  
  return ((Xinside && Yinside) || inside) && menu_bar_EDIT_dropDown_panel.isVisible();
}

boolean mouseOver_VIEWdropDownPanel(){
  boolean Xinside = false;
  boolean Yinside = false;
  boolean inside = false;
  
  if(mouseX > menu_bar_VIEW_dropDown_panel.getX()){
    if(menu_bar_VIEW_dropDown_panel.isCollapsed()){
      
    }else if(mouseX < menu_bar_VIEW_dropDown_panel.getX() + menu_bar_VIEW_dropDown_panel.getWidth()){
      Xinside = true;
    }
  }
  
  if(mouseY > menu_bar_VIEW_dropDown_panel.getY()){
    if(menu_bar_VIEW_dropDown_panel.isCollapsed()){
      
    }else if(mouseY < menu_bar_VIEW_dropDown_panel.getY() + menu_bar_VIEW_dropDown_panel.getHeight() + fudgeValue){
      Yinside = true;
    }
  }
  
  inside = menu_bar_VIEW_dropDown_panel.isOver(mouseX, mouseY) || menu_bar_VIEW_dropDown_panel.isDragging();
  
  return ((Xinside && Yinside) || inside) && menu_bar_VIEW_dropDown_panel.isVisible();
}

//---------------------------------------------------------------------------------------------------------------------------------------

boolean changeDisplayedMenuBar(int bar_){
  menu_bar_FILE_dropDown_panel.setVisible(false);
  menu_bar_EDIT_dropDown_panel.setVisible(false);
  menu_bar_VIEW_dropDown_panel.setVisible(false);
  
  if(displayedMenuBar == bar_){
    displayedMenuBar = button_menuBar_NONE;
    return true;
  }
  displayedMenuBar = bar_;
  switch(displayedMenuBar){
    case button_menuBar_file:
      menu_bar_FILE_dropDown_panel.setVisible(true);
      break;

    case button_menuBar_edit:
      menu_bar_EDIT_dropDown_panel.setVisible(true);
      break;

    case button_menuBar_view:
      menu_bar_VIEW_dropDown_panel.setVisible(true);
      break;
  }
  return false;
}

void drawRedGradient(){
  tmpGradient.beginDraw();
  tmpGradient.noStroke();
  for(float i = 0; i <= 1; i+=0.02){
    tmpGradient.fill(lerpColor(color(0, green(currentTileColor), blue(currentTileColor)), color(255, green(currentTileColor), blue(currentTileColor)), i));
    tmpGradient.rect((i*100), 0, 2, 16);
  }
  tmpGradient.endDraw();
}

void drawGreenGradient(){
  tmpGradient.beginDraw();
  tmpGradient.noStroke();
  for(float i = 0; i <= 1; i+=0.02){
    tmpGradient.fill(lerpColor(color(red(currentTileColor), 0, blue(currentTileColor)), color(red(currentTileColor), 255, blue(currentTileColor)), i));
    tmpGradient.rect((i*100), 0, 2, 16);
  }
  tmpGradient.endDraw();
}

void drawBlueGradient(){
  tmpGradient.beginDraw();
  tmpGradient.noStroke();
  for(float i = 0; i <= 1; i+=0.02){
    tmpGradient.fill(lerpColor(color(red(currentTileColor), green(currentTileColor), 0), color(red(currentTileColor), green(currentTileColor), 255), i));
    tmpGradient.rect((i*100), 0, 2, 16);
  }
  tmpGradient.endDraw();
}

void drawSaturationGradient(){
  colorMode(HSB, 255);
  color lowSat = color(hue(currentTileColor), 0, brightness(currentTileColor));
  color highSat = color(hue(currentTileColor), 255, brightness(currentTileColor));
  colorMode(RGB, 255);
  tmpGradient.beginDraw();
  tmpGradient.noStroke();
  for(float i = 0; i <= 1; i+=0.02){
    tmpGradient.fill(lerpColor(lowSat, highSat, i));
    tmpGradient.rect((i*100), 0, 2, 16);
  }
  tmpGradient.endDraw();
}

void drawBrightnessGradient(){
  colorMode(HSB, 255);
  color lowBright = color(hue(currentTileColor), saturation(currentTileColor), 0);
  color highBright = color(hue(currentTileColor), saturation(currentTileColor), 255);
  colorMode(RGB, 255);
  tmpGradient.beginDraw();
  tmpGradient.noStroke();
  for(float i = 0; i <= 1; i+=0.02){
    tmpGradient.fill(lerpColor(lowBright, highBright, i));
    tmpGradient.rect((i*100), 0, 2, 16);
  }
  tmpGradient.endDraw();
}

void drawAlphaGradient(){
  tmpGradient.beginDraw();
  tmpGradient.noStroke();
  tmpGradient.clear();
  tmpGradient.image(alphaBack, 0, 0);
  for(float i = 0; i <= 1; i+=0.020001){
    tmpGradient.fill(color(red(currentTileColor), green(currentTileColor), blue(currentTileColor), i*255));
    tmpGradient.rect((i*100), 0, 2, 16);
    //println(i*100);
  }
  tmpGradient.endDraw();
}