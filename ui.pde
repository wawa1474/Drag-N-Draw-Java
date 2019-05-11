int totalImages = 32 * 4 - 1;//Total Images
final int rowLength = 16;//How many tiles per row?
int tileRow = 0;//Which row of tiles are we looking at?
int tileN = 0;//Which tile is the cursor over?
boolean colorTiles = true;//Are we placing colored tiles

int fullTotalImages = ceil((float)(totalImages + 1) / rowLength) * rowLength - 1;//make sure all tile rows are full

final int UIRight = 22;//How many tiles long is the UI?
final int UIBottom = scl * 3;//How many tiles tall is the UI?

final color RED = color(255,0,0);
final color BLACK = color(0);
final color WHITE = color(255);
final color GREY = color(127);
final color screen_Amber = #FFCC00;

float backgroundRed = 255;//red
float backgroundGreen = 255;//green
float backgroundBlue = 255;//blue

//Controller RSlider, GSlider, BSlider;//sliders
Controller scrollSlider;//slider
Controller colorInputR, colorInputG, colorInputB;//number input
Controller colorWheel;//color wheel
boolean RGBInputVis = false;//are the rgb number inputs visible

final int _OPENING_ = -1;
final int _MAINMENU_ = 0;
final int _TILEMAPUI_ = 1;//UI defines?
final int _EDITORUI_ = 2;//UI defines?
final int _OPTIONSMENU_ = 3;//UI defines?

int currentUI = _OPENING_;
int previousUI = -1;

final int borderThickness = 4;//how thick is the canvas border

int lowerx = 2147483647, lowery = 2147483647;//store lowest xy of tiles
int upperx = -2147483648, uppery = -2147483648;//store highest xy of tiles
boolean drawLines = true;//do we draw the background lines?

void drawEditorBackground(){//Draw the background
  int gUpper = 150;//middle-ish
  int gLower = 90;//middle-ish

  strokeWeight(1);//default
  background(backgroundRed, backgroundGreen, backgroundBlue);//Draw the background in whatever the color is

  if(backgroundRed > gLower && backgroundRed < gUpper && backgroundGreen > gLower && backgroundGreen < gUpper && backgroundBlue > gLower && backgroundBlue < gUpper){//if the color is gray-ish
    stroke(0);//Make it black
  }else{
    stroke(255 - backgroundRed, 255 - backgroundGreen, 255 - backgroundBlue);//Invert line color
  }

  if(drawLines){//if the tile xy is not reset and we're should draw lines
    for(int i = screenX1; i < screenX2 + 2; i++){//for however many horizontal squares there are
      line(i * scl, screenY1 * scl, i * scl, (screenY2 + 2) * scl);//draw lines
    }
    for(int i = screenY1; i < screenY2 + 2; i++){//for however many vertical squares there are
      line(screenX1 * scl, i * scl, (screenX2 + 2) * scl, i * scl);//draw lines
    }
  }
}//void draw() END

//---------------------------------------------------------------------------------------------------------------------------------------

void drawBorder(int x1_, int x2_, int y1_, int y2_, float thiccc_){//draw the red border
  strokeWeight(thiccc_);//Thicker
  stroke(255, 0, 0);//RED
  line(x1_, y1_, x1_, y2_);//Draw Left line
  line(x2_, y1_, x2_, y2_);//Draw Right line
  line(x1_, y1_, x2_, y1_);//Draw Top Line
  line(x1_, y2_, x2_, y2_);//Draw Bottom Line
}//void border() END

//---------------------------------------------------------------------------------------------------------------------------------------

void drawEditorUI(){
  fill(BLACK);//black
  noStroke();//no line around the ui background
  rect(0, 0, width, UIBottom);//ui background

  strokeWeight(1);//default
  stroke(0);
  fill(WHITE);//Set background color to white
  rect(0, scl, scl*rowLength, scl);//Create rectangle behind tiles UI
  for(int i = 0; i < rowLength && tileImages.length != 0; i++){//Go through all the tiles
    if((rowLength*tileRow)+i <= fullTotalImages){//If tile exists
      if((rowLength*tileRow)+i == tileN){//If displaying selected tile
        fill(currentTileColor);//Set background color to the RGB value set by user
        rect(scl*i, scl, scl, scl);//Display color behind the tile
      }
      if(tileImages[(rowLength*tileRow)+i] != null){
        image(tileImages[(rowLength*tileRow)+i], scl*i, scl);//Draw tile
      }
      if((rowLength*tileRow)+i == tileN){
        noFill();
        rect(scl*i, scl, scl - 1, scl - 1);//Display color behind the tile
      }
    }
  }//Went through all the tiles

  //fill(RED);//red text
  //stroke(0);//no outline
  //textSize(24);//larger text size

  //int tmp = 0;//how many tiles are there total

  //for(int x = 0; x < mapTiles.size(); x++){//go through all columns
  //  for(int y = 0; y < mapTiles.get(x).size(); y++){//go through all rows
  //    tmp += mapTiles.get(x).get(y).size();//add the number of tiles in the space
  //  }
  //}
  //if(tmpTile != null){//if we're dragging a tile
  //  tmp += 1;//count it too
  //}
      
  //float tmpX1 = (scl * 16) + (scl / 8);
  //float tmpX2 = scl * 25;
  //float tmpX3 = (scl * 27) + (scl / 2);
      
  //float tmpY1 = (scl / 1.25);
  //float tmpY2 = (scl * 1.75);

  //text("Tiles: " + tmp, tmpX1, tmpY1);//Tiles:(tmp)
  //text("Drawn: " + drawnTiles, tmpX1, tmpY2);//Drawn:(drawnTiles)

  //text("X:" + floor(-screenX/scl), tmpX2, tmpY1);//X:(screenX)
  //text("Y:" + floor(-screenY/scl), tmpX2, tmpY2);//Y:(screenY)

  //if(mouseY < UIBottom * scl){
  //  text("X:UI", tmpX3, tmpY1);//X:UI
  //  text("Y:UI", tmpX3, tmpY2);//Y:UI
  //}else{
  //  text("X:" + mouseTileX, tmpX3, tmpY1);//X:(mouseTileX)
  //  text("Y:" + mouseTileY, tmpX3, tmpY2);//Y:(mouseTileY)
  //}

  //textSize(12);//Default text size
}//void draw() END

//---------------------------------------------------------------------------------------------------------------------------------------

void updateEditorUI(){
  scrollAmount = (int)scrollSlider.getValue();//update scroll amount

  int tmpVal = 150;

  if(colorTiles){
    setButtonColors(button_editorUI_colorToggle, currentTileColor, color(tmpVal - red(currentTileColor), tmpVal - green(currentTileColor), blue(currentTileColor)));
  }else{
    setButtonColors(button_editorUI_colorToggle, BLACK, WHITE);
  }
  
  editor_slider_red.setLocalColor(5, color(red(currentTileColor), 0, 0));
  editor_slider_green.setLocalColor(5, color(0, green(currentTileColor), 0));
  editor_slider_blue.setLocalColor(5, color(0, 0, blue(currentTileColor)));
  
  color tmp;
  color tmp2;
  
  colorMode(HSB, 255);
  tmp = color(hue(currentTileColor), 255, 255);
  tmp2 = color(hue(currentTileColor), saturation(currentTileColor), 255);
  colorMode(RGB, 255);
  
  editor_slider_hue.setLocalColor(5, tmp);
  editor_slider_saturation.setLocalColor(5, tmp2);
  editor_slider_brightness.setLocalColor(5, (int)brightness(currentTileColor));
  //1 = ticks, 2 = text color, 3 = thumb/border, 4 = ticks, 5 = surface, 6 = background, 11 = thumb, 14 = thumb, 15 = thumb
}//void update() END

//---------------------------------------------------------------------------------------------------------------------------------------

void setupUI(){
  UIControls.addSlider("scrollSlider").setVisible(false).setDecimalPrecision(0).setPosition(scl * 9, 0).setSliderMode(Slider.FLEXIBLE).setSize(scl * 2, scl).setRange(0, 16).setValue(5).setColorBackground(color(50)).setCaptionLabel("");//create Slider
  scrollSlider = UIControls.getController("scrollSlider");//make it easier to use Slider

  UIControls.addColorWheel("colorWheel").setVisible(false).setRGB(currentTileColor).setCaptionLabel("")//create ColorWheel
    .onChange(new CallbackListener(){//when changed
    public void controlEvent(CallbackEvent theEvent){
      if(currentColorSlider == -1){
        currentColorSlider = 99;
      }
      
      if(currentColorSlider == 99){
        currentTileColor = UIControls.get(ColorWheel.class, "colorWheel").getRGB();
        
        editor_slider_red.setValue(red(currentTileColor));
        editor_slider_green.setValue(green(currentTileColor));
        editor_slider_blue.setValue(blue(currentTileColor));
        editor_slider_hue.setValue(hue(currentTileColor));
        editor_slider_saturation.setValue(saturation(currentTileColor));
        editor_slider_brightness.setValue(brightness(currentTileColor));
      }
    }
  }
  );
  colorWheel = UIControls.getController("colorWheel");//make it easier to use ColorWheel

  UIControls.addTextfield("colorInputR").setSize(scl, scl / 2).setVisible(false).setCaptionLabel("");//.setColorLabel(color(255, 0, 0));
  UIControls.addTextfield("colorInputG").setSize(scl, scl / 2).setVisible(false).setCaptionLabel("");//.setColorLabel(color(0, 255, 0));
  UIControls.addTextfield("colorInputB").setSize(scl, scl / 2).setVisible(false).setCaptionLabel("");//.setColorLabel(color(0, 0, 255));
  colorInputR = UIControls.getController("colorInputR");//make it easier to use Textfield
  colorInputG = UIControls.getController("colorInputG");//make it easier to use Textfield
  colorInputB = UIControls.getController("colorInputB");//make it easier to use Textfield

  buttons_editorUI.add(new button(scl * 8, 0, scl, scl, BLACK, "Color", WHITE, 12, button_editorUI_colorToggle, -1));

  buttons_editorUI.add(new button(scl * 11, 0, scl * 3.3, scl, BLACK, "Change Tile Map", WHITE, 12, button_editorUI_changeTileMap, -1));

  for(button b : buttons_editorUI){
    b.setup();
  }
  
  editor_slider_red.setValue(red(currentTileColor));
  editor_slider_green.setValue(green(currentTileColor));
  editor_slider_blue.setValue(blue(currentTileColor));
  editor_slider_hue.setValue(hue(currentTileColor));
  editor_slider_saturation.setValue(saturation(currentTileColor));
  editor_slider_brightness.setValue(brightness(currentTileColor));

  //changeUI(_MAINMENU_);//go to tile map selection display
  changeUI(_OPENING_);//go to tile map selection display
}//void setup() END

//---------------------------------------------------------------------------------------------------------------------------------------

void changeUI(int ui_){//change screen
  slidersSetVis(false);
  displayedMenuBar = -1;
  altHeld = false;
  ctrlHeld = false;
  shiftHeld = false;
  lastKey = -1;
  previousUI = currentUI;
  
  main_menu_button_panel.setVisible(false);
  menu_bar_button_panel.setVisible(false);
  menu_bar_FILE_dropDown_panel.setVisible(false);
  menu_bar_EDIT_dropDown_panel.setVisible(false);
  menu_bar_VIEW_dropDown_panel.setVisible(false);
  tilemap_button_panel.setVisible(false);
  editor_colorTools_panel.setVisible(false);
  colorWheel.setVisible(false);
  colorInputR.setVisible(false);//change visibility
  colorInputG.setVisible(false);//change visibility
  colorInputB.setVisible(false);//change visibility
  
  if(ui_ == _OPENING_){//are we going to the tile map loading screen
    surface.setSize(800, 600);
    currentUI = _OPENING_;
  }else if(ui_ == _MAINMENU_){//are we going to the tile map loading screen
    surface.setSize(298 + (scl * 2), 384 + 58 + (scl * 2));// 406 + (scl * 2));//298 x 406
    main_menu_button_panel.setVisible(true);
    currentUI = _MAINMENU_;
  }else if(ui_ == _TILEMAPUI_){//are we going to the tile map loading screen
    surface.setSize(960, 960);//458 x 254
    tilemap_button_panel.setVisible(true);
    currentUI = _TILEMAPUI_;
  }else if(ui_ == _EDITORUI_){//are we going to the editor screen
    surface.setSize(960, 960);//458 x 254
    slidersSetVis(true);
    menu_bar_button_panel.setVisible(true);
    editor_colorTools_panel.setVisible(true);
    editor_colorTools_panel.setDragArea();
    editor_colorTools_panel.setCollapsed(true);
    currentUI = _EDITORUI_;
  }else if(ui_ == _OPTIONSMENU_){//are we going to the editor screen
    surface.setSize(458 + (scl * 2), 254 + (scl * 2));//458 x 254 = 522 x 318
    currentUI = _OPTIONSMENU_;
  }else{
    println("ERROR: UI DOES NOT EXIST");
  }
}//void changeVisibility(boolean visibility) END

//---------------------------------------------------------------------------------------------------------------------------------------

void slidersSetVis(boolean vis_){//set visibility for all items on the editors UI
  scrollSlider.setVisible(vis_);
}

//---------------------------------------------------------------------------------------------------------------------------------------

void loadColors(mTile tile_){//Load RGB Sliders and RGB Inputs with value from tile
  if(tile_ != null){
    if(tile_.colored){//----------------------------------------------------------------------------do we want to check this?
      currentTileColor = tile_.tileColor;
    }
  }
}//void loadColors(int tile) END

//---------------------------------------------------------------------------------------------------------------------------------------

void nextTileC(){//Move To Next Tile
  updateTileRow();//Get the row to whatever tile were on
  tileN++;//Increment the tile number
  if(tileN > fullTotalImages){//Is the tile number greater than our total number of images?
    tileN = 0;//Loop the tile number back to the first tile
    tileRow = 0;//Loop the tile row back to the first row
  }
  if(tileN == rowLength*(tileRow+1)){//If the tile number is the last tile
    tileRow++;//Increment the tile row
    if (tileRow > fullTotalImages/rowLength){//Is the tile row greater than our total number of rows?
      tileRow = 0;//Loop the tile row back to the first row
    }
  }
}//void nextTileC() END

//---------------------------------------------------------------------------------------------------------------------------------------

void prevTileC(){//Move To Previous Tile
  updateTileRow();//Get the row to whatever tile were on
  tileN--;//Decrement the tile number
  if(tileN < 0){//Is the tile number less than zero?
    tileN = fullTotalImages;//Loop the tile number back to the last tile
    tileRow = floor(fullTotalImages/rowLength);//Loop the tile row back to the last row
  }
  if(tileN < rowLength*tileRow){//Is the tile number less than the lower end of the current row?
    tileRow--;//Decrement the tile row
    if(tileRow < 0){//Is the tile number less than zero?
      tileRow = floor(fullTotalImages/rowLength);//Loop the tile row back to the last row
    }
  }
}//void prevTileC() END

//---------------------------------------------------------------------------------------------------------------------------------------

void updateTileRow(){//Get the row to whatever tile were on
  while(floor(tileN/rowLength)*rowLength < rowLength*tileRow){//Is tileN lower than the row were on?
    tileRow--;//Decrement tileRow
    if(tileRow < 0){//Is the tile number less than zero?
      tileRow = floor(fullTotalImages/rowLength);//Loop the tile row back to the last row
    }
  }
  while(floor(tileN/rowLength)*rowLength > rowLength*tileRow){//Is tileN higher than the row were on?
    tileRow++;//Increment tileRow
    if(tileRow > fullTotalImages/rowLength){//Is the tile row greater than our total number of rows?
      tileRow = 0;//Loop the tile row back to the first row
    }
  }
}//void updateTileRow() END

//---------------------------------------------------------------------------------------------------------------------------------------

void nextRowC(){//Next Row
  if(tileN < rowLength * tileRow || tileN > rowLength * tileRow + rowLength){//Is tileN outside of our current row
    //Do Nothing
  }else{
    tileN += rowLength;//Keep the selected tile number in the same relative position
    if(tileN > fullTotalImages){//If the tile number is greater than our total number of tiles
      tileN = tileN - (fullTotalImages + 1);//Loop the tile number back to first row in the same relative position
    }
  }
  tileRow++;//Increment the row number
  if(tileRow > fullTotalImages / rowLength){//If the row number is greater than our total number of rows
    tileRow = 0;//Loop the row number back to the first
  }
}//void nextRowC() END

//---------------------------------------------------------------------------------------------------------------------------------------

void prevRowC(){//Previous Row
  if(tileN < rowLength * tileRow || tileN > rowLength * tileRow + rowLength){//Is tileN outside of our current row
    //Do Nothing
  }else{
    tileN -= rowLength;//Keep the selected tile number in the same relative position
    if(tileN < 0){//If the tile number is less than zero
      tileN = (fullTotalImages + 1) - (0 - tileN);//Loop the tile number back to last row in the same relative position
    }
  }
  tileRow--;//Decrement the row number
  if(tileRow < 0){//If the row number is less than our zero
    tileRow = floor(fullTotalImages / rowLength);//Loop the row number back to the last
  }
}//void prevRowC() END

//---------------------------------------------------------------------------------------------------------------------------------------

String padFPS(){
  String FPS = String.valueOf(frameRate);//grab the frame rate
  if(FPS.length() > 4){//if the frame rate has more than 2 decimal places
    FPS = FPS.substring(0, 5);//XX.XX truncate them
  }else if(FPS.length() > 3){//if it has 1 decimal place
    FPS = FPS.substring(0, 4) + "0";//XX.X0 pad it
  }else{//if it has no decimal places
    FPS = FPS.substring(0, 2) + ".00";//XX.00 pad it
  }

  return FPS;
}