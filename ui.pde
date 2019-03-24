int totalImages = 32 * 4 - 1;//Total Images
int rowLength = 16;//How many tiles per row?
int tileRow = 0;//Which row of tiles are we looking at?
int tileN = 1;//Which tile is the cursor over?
boolean colorTiles = true;//Are we placing clear tiles

int fullTotalImages = ceil((float)(totalImages + 1) / rowLength) * rowLength - 1;//make sure all tile rows are full

int UIRight = 22;//How many tiles long is the UI?
int UIBottom = 2;//How many tiles tall is the UI?

color BLACK = color(0);
color WHITE = color(255);
color GREY = color(127);

int backgroundRed = 255;//red
int backgroundGreen = 255;//green
int backgroundBlue = 255;//blue

import controlP5.*;//import the library
ControlP5 UIControls;//ui controls
Controller RSlider, GSlider, BSlider;//sliders
Controller scrollSlider;//slider
Controller colorInputR, colorInputG, colorInputB;//number input
Controller colorWheel;//color wheel

int _TILEMAPUI_ = 0;
int _MAPUI_ = 1;

int borderThickness = 4;//how thick is the canvas border

int lowerx = 2147483647, lowery = 2147483647;//store lowest xy of tiles
int upperx = -2147483648, uppery = -2147483648;//store highest xy of tiles
boolean drawLines = true;//do we draw the background lines?

void drawBackground(){//Draw the background
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

void drawBorder(){//draw the red border
  strokeWeight(borderThickness);//Thicker
  stroke(255, 0, 0);//RED
  line(1, 0, 1, rows*scl);//Draw Left line
  line((scl * cols) - 1, 0, (scl * cols) - 1, rows*scl);//Draw Right line
  line(0, 1, cols*scl, 1);//Draw Top Line
  line(0, (scl * rows) - 1, cols*scl, (scl * rows) - 1);//Draw Bottom Line
}//void border() END

//---------------------------------------------------------------------------------------------------------------------------------------

void drawUI(){
  fill(0);//black
  noStroke();//no line around the ui background
  rect(0, 0, width, scl * 2);//ui background

  strokeWeight(1);//default
  stroke(0);
  fill(255);//Set background color to white
  rect(0, 0, scl*rowLength, scl);//Create rectangle behind tiles UI
  for(int i = 0; i < rowLength && tileImages.length != 0; i++){//Go through all the tiles
    if((rowLength*tileRow)+i <= fullTotalImages){//If tile exists
      if((rowLength*tileRow)+i == tileN){//If displaying selected tile
        fill(RSlider.getValue(), GSlider.getValue(), BSlider.getValue());//Set background color to the RGB value set by user
        rect(scl*i, 0, scl, scl);//Display color behind the tile
      }
      if(tileImages[(rowLength*tileRow)+i] != null){
        image(tileImages[(rowLength*tileRow)+i], scl*i, 0);//Draw tile
      }
      if((rowLength*tileRow)+i == tileN){
        noFill();
        rect(scl*i, 0, scl - 1, scl - 1);//Display color behind the tile
      }
    }
  }//Went through all the tiles

  fill(255, 0, 0);//red text
  stroke(0);//no outline
  textSize(24);//larger text size

  int tmp = 0;//how many tiles are there total

  for(int x = 0; x < mapTiles.size(); x++){//go through all columns
    for(int y = 0; y < mapTiles.get(x).size(); y++){//go through all rows
      tmp += mapTiles.get(x).get(y).size();//add the number of tiles in the space
    }
  }
  if(tmpTile != null){//if we're dragging a tile
    tmp += 1;//count it too
  }
      
  float tmpX1 = (scl * 16) + (scl / 8);
  float tmpX2 = scl * 25;
  float tmpX3 = (scl * 27) + (scl / 2);
      
  float tmpY1 = (scl / 1.25);
  float tmpY2 = (scl * 1.75);

  text("Tiles: " + tmp, tmpX1, tmpY1);//Tiles:(tmp)
  text("Drawn: " + drawnTiles, tmpX1, tmpY2);//Drawn:(drawnTiles)

  text("X:" + floor(-screenX/scl), tmpX2, tmpY1);//X:(screenX)
  text("Y:" + floor(-screenY/scl), tmpX2, tmpY2);//Y:(screenY)

  if(mouseY < UIBottom * scl){
    text("X:UI", tmpX3, tmpY1);//X:UI
    text("Y:UI", tmpX3, tmpY2);//Y:UI
  }else{
    text("X:" + mouseTileX, tmpX3, tmpY1);//X:(mouseTileX)
    text("Y:" + mouseTileY, tmpX3, tmpY2);//Y:(mouseTileY)
  }

  textSize(12);//Default text size
}//void draw() END

//---------------------------------------------------------------------------------------------------------------------------------------

void updateUI(){
  if(colorWheel.isVisible() || colorInputR.isVisible()){//if using color wheel or color inputs
    noTile = true;//disallow tile placement
  }

  scrollAmount = (int)scrollSlider.getValue();//update scroll amount

  RSlider.setColorBackground(color(RSlider.getValue(), 0, 0));//update background color (Red)
  GSlider.setColorBackground(color(0, GSlider.getValue(), 0));//update background color (Green)
  BSlider.setColorBackground(color(0, 0, BSlider.getValue()));//update background color (Blue)

  setButtonColorBack("hue", color(RSlider.getValue(), GSlider.getValue(), BSlider.getValue()));
  setButtonColorBack("rgb", color(RSlider.getValue(), GSlider.getValue(), BSlider.getValue()));

  int tmpVal = 150;
  setButtonColorText("hue", color(tmpVal - RSlider.getValue(), tmpVal - GSlider.getValue(), tmpVal - BSlider.getValue()));
  setButtonColorText("rgb", color(tmpVal - RSlider.getValue(), tmpVal - GSlider.getValue(), tmpVal - BSlider.getValue()));

  if(colorTiles){
    setButtonColorBack("clear", color(RSlider.getValue(), GSlider.getValue(), BSlider.getValue()));
    setButtonColorText("clear", color(tmpVal - RSlider.getValue(), tmpVal - GSlider.getValue(), tmpVal - BSlider.getValue()));
  }else{
    setButtonColorBack("clear", BLACK);
    setButtonColorText("clear", WHITE);
  }
}//void update() END

//---------------------------------------------------------------------------------------------------------------------------------------

void setupUI(){
  //loadButtonImages();

  UIControls.addSlider("RSlider").setDecimalPrecision(0).setPosition(scl, (scl + 1.3) - 1).setSliderMode(Slider.FLEXIBLE).setSize(scl * 3, 10).setRange(0, 255).setValue(127).setCaptionLabel("");//create Slider
  UIControls.addSlider("GSlider").setDecimalPrecision(0).setPosition(scl, (scl + 12.3) - 1).setSliderMode(Slider.FLEXIBLE).setSize(scl * 3, 10).setRange(0, 255).setValue(127).setCaptionLabel("");//create Slider
  UIControls.addSlider("BSlider").setDecimalPrecision(0).setPosition(scl, (scl + 23.3) - 1).setSliderMode(Slider.FLEXIBLE).setSize(scl * 3, 10).setRange(0, 255).setValue(127).setCaptionLabel("");//create Slider
  RSlider = UIControls.getController("RSlider");//make it easier to use Slider
  GSlider = UIControls.getController("GSlider");//make it easier to use Slider
  BSlider = UIControls.getController("BSlider");//make it easier to use Slider

  UIControls.addSlider("scrollSlider").setDecimalPrecision(0).setPosition(scl * 6.05, scl).setSliderMode(Slider.FLEXIBLE).setSize(scl * 2, scl).setRange(1, 10).setValue(5).setColorBackground(color(50)).setCaptionLabel("");//create Slider
  scrollSlider = UIControls.getController("scrollSlider");//make it easier to use Slider

  UIControls.addColorWheel("colorWheel").setPosition(0, scl * 2).setVisible(false).setRGB(color(127, 127, 127)).setCaptionLabel("")//create ColorWheel
    .onChange(new CallbackListener(){//when changed
    public void controlEvent(CallbackEvent theEvent){
      RSlider.setValue(UIControls.get(ColorWheel.class, "colorWheel").r());//make sure all values are the same
      GSlider.setValue(UIControls.get(ColorWheel.class, "colorWheel").g());//make sure all values are the same
      BSlider.setValue(UIControls.get(ColorWheel.class, "colorWheel").b());//make sure all values are the same
    }
  }
  );
  colorWheel = UIControls.getController("colorWheel");//make it easier to use ColorWheel

  UIControls.addTextfield("colorInputR").setPosition(scl * 4, scl * 2).setSize(scl, scl / 2).setVisible(false).setCaptionLabel("");//.setColorLabel(color(255, 0, 0));
  UIControls.addTextfield("colorInputG").setPosition(scl * 4, scl * 2.5).setSize(scl, scl / 2).setVisible(false).setCaptionLabel("");//.setColorLabel(color(0, 255, 0));
  UIControls.addTextfield("colorInputB").setPosition(scl * 4, scl * 3).setSize(scl, scl / 2).setVisible(false).setCaptionLabel("");//.setColorLabel(color(0, 0, 255));
  colorInputR = UIControls.getController("colorInputR");//make it easier to use Textfield
  colorInputG = UIControls.getController("colorInputG");//make it easier to use Textfield
  colorInputB = UIControls.getController("colorInputB");//make it easier to use Textfield

  buttons.add(new button(0, scl, scl - 1, scl, BLACK, "HUE", WHITE, 12, false, "hue", -1));
  buttons.add(new button(scl * 4, scl, scl - 1, scl, BLACK, "RGB", WHITE, 12, false, "rgb", -1));
  buttons.add(new button(scl * 5, scl, scl, scl, BLACK, "Color", WHITE, 12, false, "clear", -1));

  buttons.add(new button(scl * 8.1, scl, scl, scl, BLACK, "New", WHITE, 12, false, "new", 0));//5
  buttons.add(new button(scl * 9.1, scl, scl * 1.1, scl, BLACK, "Save", WHITE, 12, false, "save", 4));
  buttons.add(new button(scl * 10.2, scl, scl * 1.1, scl, BLACK, "Load", WHITE, 12, false, "load", 2));
  buttons.add(new button(scl * 11.3, scl, scl * 1.3, scl, BLACK, "Image", WHITE, 12, false, "image", -1));
  buttons.add(new button(scl * 12.6, scl, scl * 3.3, scl, BLACK, "Change Tile Map", WHITE, 12, true, "change map", -1));

  buttons.add(new button(0, 0, scl * 1.5, scl, BLACK, "Prev", WHITE, 12, true, "prev", 10));
  buttons.add(new button(scl * 2, 0, scl * 1.5, scl, BLACK, "Next", WHITE, 12, true, "next", 11));
  buttons.add(new button(scl * 4, 0, scl * 1.5, scl, BLACK, "Load", WHITE, 12, true, "load tile", -1));
  buttons.add(new button(scl * 7, 0, scl * 2, scl, BLACK, "Load Map", WHITE, 12, true, "load map", 2));

  for(button b : buttons){
    b.setup();
  }

  changeVisibility(_TILEMAPUI_);//go to tile map selection display
}//void setup() END

//---------------------------------------------------------------------------------------------------------------------------------------

void changeVisibility(int ui){//change screen
  if(ui == _TILEMAPUI_){//are we going to the tile map loading screen
    tilemapUIButtonsSetVis(true);
    mapUIButtonsSetVis(false);
  }else if(ui == _MAPUI_){
    tilemapUIButtonsSetVis(false);
    mapUIButtonsSetVis(true);
  }else{
    println("ERROR UI TYPE DOES NOT EXIST");
  }
}//void changeVisibility(boolean visibility) END

//---------------------------------------------------------------------------------------------------------------------------------------

void tilemapUIButtonsSetVis(boolean vis){
  setButtonVis("prev", vis);
  setButtonVis("next", vis);
  setButtonVis("load tile", vis);
  setButtonVis("load map", vis);
}

//---------------------------------------------------------------------------------------------------------------------------------------

void mapUIButtonsSetVis(boolean vis){
  setButtonVis("hue", vis);
  setButtonVis("rgb", vis);
  setButtonVis("clear", vis);
  setButtonVis("new", vis);
  setButtonVis("save", vis);
  setButtonVis("load", vis);
  setButtonVis("image", vis);
  setButtonVis("change map", vis);
  scrollSlider.setVisible(vis);//scrollSlider is visible
  RSlider.setVisible(vis);//RSlider is visible
  GSlider.setVisible(vis);//GSlider is visible
  BSlider.setVisible(vis);//BSlider is visible
}

//---------------------------------------------------------------------------------------------------------------------------------------

void buttonPrevTileMap(){
  tileMapShow--;//go to previous tile map
  if(tileMapShow < 0){//make sure we don't go below zero
    tileMapShow = tileMaps.size() - 1;//set to maxixmum tile map
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------

void buttonNextTileMap(){
  tileMapShow++;//go to next tile map
  if(tileMapShow >= tileMaps.size()){//make sure we dont go above maximum tile map
    tileMapShow = 0;//set to 0
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------

void buttonLoadTileMap(){
  loadTileMap();//load selected tile map
  tileN = 1;//make sure were on tile 1
  updateTileRow();//make sure we're on the correct row
  noTile = false;//allowed to place tiles
  selectingTileMap = false;//no longer selecting a tile map
  changeVisibility(_MAPUI_);//go to normal display
  screenX = tmpScreenX;//reload our position
  screenY = tmpScreenY;//reload our position
}

//---------------------------------------------------------------------------------------------------------------------------------------

void clearToggle(){//called when clearToggle is clicked
  if(colorTiles){//is variable set
    colorTiles = false;//don't place clear tiles
  }else{
    colorTiles = true;//place clear tiles
  }
}//void clearToggle() END

//---------------------------------------------------------------------------------------------------------------------------------------

void colorSelect(){//called when colorSelect is clicked
  colorWheel.setVisible(!colorWheel.isVisible());//invert visibility
  noTile = !noTile;//ivert whether tiles can be placed
}//void colorSelect() END

//---------------------------------------------------------------------------------------------------------------------------------------

void colorInput(){//called when colorInput is clicked
  //UIControls.get(Textfield.class, "colorInputR").setVisible(!UIControls.get(Textfield.class, "colorInputR").isVisible());
  colorInputR.setVisible(!colorInputR.isVisible());//invert visibility
  colorInputG.setVisible(!colorInputG.isVisible());//invert visibility
  colorInputB.setVisible(!colorInputB.isVisible());//invert visibility
  noKeyboard = !noKeyboard;//invert whether keyboard keys work
  noTile = !noTile;//ivert whether tiles can be placed
}//void colorInput() END

//---------------------------------------------------------------------------------------------------------------------------------------

void colorInputR(String value){//called when colorInputR updates
  RSlider.setValue(int(value));//make sure all values are the same
}//void colorInputR(String value) END

//---------------------------------------------------------------------------------------------------------------------------------------

void colorInputG(String value){//called when colorInputG updates
  GSlider.setValue(int(value));//make sure all values are the same
}//void colorInputG(String value) END

//---------------------------------------------------------------------------------------------------------------------------------------

void colorInputB(String value){//called when colorInputB updates
  BSlider.setValue(int(value));//make sure all values are the same
}//void colorInputB(String value) END

//---------------------------------------------------------------------------------------------------------------------------------------

void loadColors(mTile tmp){//Load RGB Sliders and RGB Inputs with value from tile
  if(tmp != null){
    if(tmp.colored){//----------------------------------------------------------------------------do we want to check this?
      RSlider.setValue(tmp.r);//Set Red Slider value to Red value of the tile
      GSlider.setValue(tmp.g);//Set Green Slider value to Green value of the tile
      BSlider.setValue(tmp.b);//Set Blue Slider value to Blue value of the tile
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