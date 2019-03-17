int totalImages = 32 * 4 - 1;//Total Images
int rowLength = 16;//How many tiles per row?
int tileRow = 0;//Which row of tiles are we looking at?
int tileN = 1;//Which tile is the cursor over?
boolean CClear = false;//Are we placing clear tiles

int fullTotalImages = ceil((float)(totalImages + 1) / rowLength) * rowLength - 1;//make sure all tile rows are full

int UIRight = 22;//How many tiles long is the UI?
int UIBottom = 2;//How many tiles tall is the UI?

color BLACK = color(0);
color WHITE = color(255);

ControlP5 UIControls;//ui controls
Controller RSlider, GSlider, BSlider;//sliders
Controller scrollSlider;//slider
Controller colorInputR, colorInputG, colorInputB;//number input
Controller colorWheel;//color wheel

tileUI UI = new tileUI();//Create a UI
boolean UISetup = false;//Are we setting up the ui?
canvasBG BG = new canvasBG();//Create a background
int borderThickness = 4;//how thick is the canvas border

int lowerx = 2147483647, lowery = 2147483647;//store lowest xy of tiles
int upperx = -2147483648, uppery = -2147483648;//store highest xy of tiles
boolean drawLines = true;//do we draw the background lines?


class canvasBG{//The background
  int r = 255;//red
  int g = 255;//green
  int b = 255;//blue
  int gUpper = 150;//middle-ish
  int gLower = 90;//middle-ish
  
  void draw(){//Draw the background
    if(preloading == true){
      background(255);//white background
      if(tileMaps.size() != 0){
        image(tileMaps.get(tileMapShow).tileMapImage,0,scl);//display tile map
      }
    }else{
      strokeWeight(1);//default
      background(this.r, this.g, this.b);//Draw the background in whatever the color is
    
      if(this.r > gLower && this.r < gUpper && this.g > gLower && this.g < gUpper && this.b > gLower && this.b < gUpper){//if the color is gray-ish
        stroke(0);//Make it black
      }else{
        stroke(255-this.r, 255-this.g, 255-this.b);//Invert line color
      }
      
      if(drawLines){//if the tile xy is not reset and we're should draw lines
        for(int i = screenX1; i < screenX2 + 2; i++){//for however many horizontal squares there are
          line(i * scl,screenY1 * scl, i * scl, (screenY2 + 2) * scl);//draw lines
        }
        for(int i = screenY1; i < screenY2 + 2; i++){//for however many vertical squares there are
          line(screenX1 * scl, i * scl, (screenX2 + 2) * scl, i * scl);//draw lines
        }
      }
    }
  }//void draw() END
  
  void border(){//draw the red border
    strokeWeight(borderThickness);//Thicker
    stroke(255,0,0);//RED
    line(1, 0, 1, rows*scl);//Draw Left line
    line((scl * cols) - 1, 0, (scl * cols) - 1, rows*scl);//Draw Right line
    line(0, 1, cols*scl, 1);//Draw Top Line
    line(0, (scl * rows) - 1, cols*scl, (scl * rows) - 1);//Draw Bottom Line
  }//void border() END
}//class canvasBG END

//---------------------------------------------------------------------------------------------------------------------------------------

class tileUI{
  void draw(){
    if(preloading == true){
      fill(0);//black box
      //rect(scl * 11.5 - SX, 0 - SY, scl * 5, scl);//text box background
      rect(scl * 11.5, 0, scl * 5, scl);//text box background
      fill(255);//white text
      //text(tileInfoTable.getString(tileMapShow + 1,"name"), scl * 12 - SX, scl / 2 - SY);//display tile map name
      if(tileMaps.size() != 0){
        text(tileMaps.get(tileMapShow).tileMapName, scl * 12, scl / 2);//display tile map name
      }else{
        text("No Tile Maps Exist!", scl * 12, scl / 2);//display tile map name
      }
      
      for(button b : buttons){
        b.draw();
      }
    }else{
      fill(0);//black
      noStroke();//no line around the ui background
      rect(0,0,width,scl * 2);//ui background
    
      strokeWeight(1);//default
      stroke(0);
      fill(255);//Set background color to white
      rect(0, 0, scl*rowLength, scl);//Create rectangle behind tiles UI
      for(int i = 0; i < rowLength && tileImages.length != 0; i++){//Go through all the tiles
        if((rowLength*tileRow)+i <= fullTotalImages){//If tile exists
          if((rowLength*tileRow)+i == tileN){//If displaying selected tile
            fill(RSlider.getValue(),GSlider.getValue(),BSlider.getValue());//Set background color to the RGB value set by user
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
    
      fill(255,0,0);//red text
      stroke(0);//no outline
      textSize(24);//larger text size

      int tmp = 0;//how many tiles are there total
    
      for(int x = 0; x < mapTiles.size(); x++){//go through all columns
        for(int y = 0; y < mapTiles.get(x).size(); y++){//go through all rows
          tmp += mapTiles.get(x).get(y).size();//add the number of tiles in the space
        }
      }
      if(tmpTile != null){//if we're dragging a tile
        tmp += 1;//count it to
      }
    
      text("Tiles: " + tmp, ((scl * 16) + scl / 8), (scl / 1.25));//Tiles: (tiles)
    
      tmp = drawnTiles;//number of tiles that are being drawn
      if(tmpTile != null){//if we're dragging a tile
        tmp += 1;//count it to
      }
  
      text("Drawn: " + tmp, ((scl * 16) + scl / 8), (scl * 1.75));//Drawn: (drawn)
    
      text("X:" + floor(-SX/scl),((scl * 25)),(scl / 1.25));//X: (screen x)
      text("Y:" + floor(-(SY-64)/scl),((scl * 25)),(scl * 1.75));//Y: (screen y)
    
      text("X:" + floor((mouseX+(-SX))/scl),((scl * 27) + scl / 2),(scl / 1.25));//X: (mouse x)
    
      if(mY < (UIBottom * scl) - SY){
        text("Y:" + "UI",((scl * 27) + scl / 2),(scl * 1.75));//Y: (mouse Y)
      }else{
        text("Y:" + floor(mY / scl),((scl * 27) + scl / 2),(scl * 1.75));//Y: (mouse Y)
      }
    
      textSize(12);//Default text size
      
      for(button b : buttons){
        b.draw();
      }
    }
  }//void draw() END
  
  void update(){
    if(UISetup == false){//is ui not setup
      UISetup = true;//ui is setup
    }
    
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
  }//void update() END
  
  void setup(){
    UIControls.addSlider("RSlider").setDecimalPrecision(0).setPosition(scl, (scl + 1.3) - 1).setSliderMode(Slider.FLEXIBLE).setSize(scl * 3,10).setRange(0,255).setValue(127).setCaptionLabel("");//create Slider
    UIControls.addSlider("GSlider").setDecimalPrecision(0).setPosition(scl, (scl + 12.3) - 1).setSliderMode(Slider.FLEXIBLE).setSize(scl * 3,10).setRange(0,255).setValue(127).setCaptionLabel("");//create Slider
    UIControls.addSlider("BSlider").setDecimalPrecision(0).setPosition(scl, (scl + 23.3) - 1).setSliderMode(Slider.FLEXIBLE).setSize(scl * 3,10).setRange(0,255).setValue(127).setCaptionLabel("");//create Slider
    RSlider = UIControls.getController("RSlider");//make it easier to use Slider
    GSlider = UIControls.getController("GSlider");//make it easier to use Slider
    BSlider = UIControls.getController("BSlider");//make it easier to use Slider
    
    UIControls.addSlider("scrollSlider").setDecimalPrecision(0).setPosition(scl * 5,scl).setSliderMode(Slider.FLEXIBLE).setSize(scl * 2,scl).setRange(1,10).setValue(5).setColorBackground(color(50)).setCaptionLabel("");//create Slider
    scrollSlider = UIControls.getController("scrollSlider");//make it easier to use Slider
    
    UIControls.addColorWheel("colorWheel").setPosition(0, scl * 2).setVisible(false).setRGB(color(127, 127, 127)).setCaptionLabel("")//create ColorWheel
      .onChange(new CallbackListener(){//when changed
        public void controlEvent(CallbackEvent theEvent){
          //println(theEvent);
          RSlider.setValue(UIControls.get(ColorWheel.class, "colorWheel").r());//make sure all values are the same
          GSlider.setValue(UIControls.get(ColorWheel.class, "colorWheel").g());//make sure all values are the same
          BSlider.setValue(UIControls.get(ColorWheel.class, "colorWheel").b());//make sure all values are the same
        }
      });
    colorWheel = UIControls.getController("colorWheel");//make it easier to use ColorWheel
    
    UIControls.addTextfield("colorInputR").setPosition(scl * 4, scl * 2).setSize(scl, scl / 2).setVisible(false).setCaptionLabel("");//.setColorLabel(color(255, 0, 0));
    UIControls.addTextfield("colorInputG").setPosition(scl * 4, scl * 2.5).setSize(scl, scl / 2).setVisible(false).setCaptionLabel("");//.setColorLabel(color(0, 255, 0));
    UIControls.addTextfield("colorInputB").setPosition(scl * 4, scl * 3).setSize(scl, scl / 2).setVisible(false).setCaptionLabel("");//.setColorLabel(color(0, 0, 255));
    colorInputR = UIControls.getController("colorInputR");//make it easier to use Textfield
    colorInputG = UIControls.getController("colorInputG");//make it easier to use Textfield
    colorInputB = UIControls.getController("colorInputB");//make it easier to use Textfield
    
    buttons.add(new button(0, scl, scl - 1, scl, BLACK, "HUE", WHITE, 12, false, "hue"));
    
    buttons.add(new button(scl * 4, scl, scl - 1, scl, BLACK, "RGB", WHITE, 12, false, "rgb"));

    buttons.add(new button(scl * 11, scl, scl, scl, BLACK, "Clear", WHITE, 12, false, "clear"));

    buttons.add(new button(scl * 6, 0, scl * 2, scl, BLACK, "Load Map", WHITE, 12, true, "load map"));
    buttons.add(new button(scl * 12, scl, scl * 4, scl, BLACK, "Change Tile Map", WHITE, 12, true, "change map"));
    
    buttons.add(new button(scl * 7, scl, scl, scl, BLACK, "Save", WHITE, 12, false, "save"));
    buttons.add(new button(scl * 8, scl, scl, scl, BLACK, "Load", WHITE, 12, false, "load"));
    buttons.add(new button(scl * 9, scl, scl * 2, scl, BLACK, "Image", WHITE, 12, false, "image"));
    
    buttons.add(new button(0, 0, scl * 1.5, scl, BLACK, "Prev", WHITE, 12, true, "prev"));
    buttons.add(new button(scl * 2, 0, scl * 1.5, scl, BLACK, "Next", WHITE, 12, true, "next"));
    buttons.add(new button(scl * 4, 0, scl * 1.5, scl, BLACK, "Load", WHITE, 12, true, "load tile"));
    
    for(button b : buttons){
      b.setup();
    }
    
    changeVisibility(true);//go to tile map selection display
    
    //UISetup = true;//ui is setup
  }//void setup() END
}//class tileUI END

//---------------------------------------------------------------------------------------------------------------------------------------

void changeVisibility(boolean visibility){//change screen
  if(visibility){//are we going to the tile map loading screen
    setButtonVis("hue", false);
    setButtonVis("rgb", false);
    setButtonVis("clear", false);
    
    setButtonVis("prev", true);
    setButtonVis("next", true);
    setButtonVis("load tile", true);
    setButtonVis("save", false);
    setButtonVis("load", false);
    setButtonVis("image", false);
    
    setButtonVis("load map", true);
    setButtonVis("change map", false);
    
    scrollSlider.setVisible(false);//scrollSlider is not visible
    RSlider.setVisible(false);//RSlider is not visible
    GSlider.setVisible(false);//GSlider is not visible
    BSlider.setVisible(false);//BSlider is not visible
  }else{
    setButtonVis("hue", true);
    setButtonVis("rgb", true);
    setButtonVis("clear", true);
    
    setButtonVis("prev", false);
    setButtonVis("next", false);
    setButtonVis("load tile", false);
    setButtonVis("save", true);
    setButtonVis("load", true);
    setButtonVis("image", true);
    
    setButtonVis("load map", false);
    setButtonVis("change map", true);
    
    scrollSlider.setVisible(true);//scrollSlider is visible
    RSlider.setVisible(true);//RSlider is visible
    GSlider.setVisible(true);//GSlider is visible
    BSlider.setVisible(true);//BSlider is visible
  }
}//void changeVisibility(boolean visibility) END

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
  loadingTileMap = false;//no longer loading map
  preloading = false;//no longer preloading
  changeVisibility(false);//go to normal display
  SX = tmpSX;//reload our position
  SY = tmpSY;//reload our position
}

//---------------------------------------------------------------------------------------------------------------------------------------

void clearToggle(){//called when clearToggle is clicked
  if(CClear){//is variable set
    CClear = false;//don't place clear tiles
    setButtonColorText("clear", WHITE);
    setButtonColorBack("clear", BLACK);
  }else{
    CClear = true;//place clear tiles
    setButtonColorText("clear", BLACK);
    setButtonColorBack("clear", WHITE);
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
    if(!tmp.clear){//----------------------------------------------------------------------------do we want to check this?
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
    if(tileRow > fullTotalImages/rowLength){//Is the tile row greater than our total number of rows?
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