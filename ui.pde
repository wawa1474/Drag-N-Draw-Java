int totalImages = 32 * 4 - 1;//Total Images
int rowLength = 16;//How many tiles per row?
int tileRow = 0;//Which row of tiles are we looking at?
int tileN = 1;//Which tile is the cursor over?
boolean CClear = false;//Are we placing clear tiles

int fullTotalImages = ceil((float)totalImages / rowLength) * rowLength - 1;//make sure all tile rows are full

int UIRight = 22;//How many tiles long is the UI?
int UIBottom = 2;//How many tiles tall is the UI?

ControlP5 UIControls;//ui controls
Controller RSlider, GSlider, BSlider;//sliders
Controller scrollSlider;//slider
ButtonBar fileSaveLoad;//button bar
Controller colorSelect, colorInput;//buttons
Controller colorInputR, colorInputG, colorInputB;//number input
Controller colorWheel;//color whee;
Controller clearToggle;//button
Controller loadMap;//button

tileUI UI = new tileUI();//Create a UI
boolean UISetup = false;//Are we setting up the ui?
canvasBG BG = new canvasBG();//Create a background
int borderThickness = 4;//how thick is the canvas border




class canvasBG{//The background
  void draw(){//Draw the background
    background(255);//Draw the white background
    image(BACKGROUND, 0, 0);//Draw background
  }//void draw() END
  
  void border(){//draw the red border
    strokeWeight(borderThickness); // Thicker
    stroke(255,0,0);//RED
    line(1, 0, 1, rows*scl);//Draw Verticle lines
    line((scl * cols) - 1, 0, (scl * cols) - 1, rows*scl);//Draw Verticle lines
    line(0, 1, cols*scl, 1);//Draw Horizontal Lines
    line(0, (scl * rows) - 1, cols*scl, (scl * rows) - 1);//Draw Horizontal Lines
    strokeWeight(1); // Default
    stroke(0);//BLACK
  }//void border() END
}//class canvasBG END

//---------------------------------------------------------------------------------------------------------------------------------------

class tileUI{
  void draw(){
    //fill(RSlider.getValue(),GSlider.getValue(),BSlider.getValue());//Set background color to the RGB value set by user
    //rect(0, scl, scl, scl);//Display color behind RGB Sliders
    
    fill(255);//Set background color to white
    rect(0, 0, scl*rowLength, scl);//Create rectangle behind tiles UI
    for(int i = 0; i < rowLength; i++){//Go through all the tiles
      if((rowLength*tileRow)+i <= fullTotalImages){//If tile exists
        if((rowLength*tileRow)+i == tileN){//If displaying selected tile
          fill(RSlider.getValue(),GSlider.getValue(),BSlider.getValue());//Set background color to the RGB value set by user
          rect(scl*i, 0, scl, scl);//Display color behind the tile
        }
        image(img[rowLength*tileRow+i], scl*i, 0);//Draw tile
      }
    }//Went through all the tiles
    
    /*if(colorInputR.isVisible()){
      fill(128);
      rect(scl / 2, scl * 2, scl * 4, scl);
    }*/
    
    fill(255,0,0);//red text
    stroke(0);//no outline
    textSize(24);//larger text size
    //String FPS = String.valueOf(frameRate);
    //text("FPS: " + FPS.substring(0, 4), ((scl * 12) + scl / 8), (scl * 1.75));//FPS: (fps.fp)
    
    text("Tiles: " + mapTiles.length, ((scl * 16) + scl / 8), (scl / 1.25));//Tiles: (tiles)
  
    text("Drawn: " + drawnTiles, ((scl * 16) + scl / 8), (scl * 1.75));//Drawn: (drawn)
    textSize(12);//Default text size
  }//void draw() END
  
  void update(){
    scrollAmount = (int)scrollSlider.getValue();//update scroll amount
    
    RSlider.setColorBackground(color(RSlider.getValue(), 0, 0));//update background color (Red)
    GSlider.setColorBackground(color(0, GSlider.getValue(), 0));//update background color (Green)
    BSlider.setColorBackground(color(0, 0, BSlider.getValue()));//update background color (Blue)
    
    colorSelect.setColorBackground(color(RSlider.getValue(), GSlider.getValue(), BSlider.getValue()));//update background color
    colorInput.setColorBackground(color(RSlider.getValue(), GSlider.getValue(), BSlider.getValue()));//update background color
    
    colorSelect.setColorLabel(color(200 - RSlider.getValue(), 200 - GSlider.getValue(), 200 - BSlider.getValue()));//update inverted label color
    colorInput.setColorLabel(color(200 - RSlider.getValue(), 200 - GSlider.getValue(), 200 - BSlider.getValue()));//update inverted label color
  }//void update() END
  
  void setup(){
    UIControls.addSlider("RSlider").setDecimalPrecision(0).setPosition(scl, scl + 1.3).setSliderMode(Slider.FLEXIBLE).setSize(scl * 3,10).setRange(0,255).setValue(127).setCaptionLabel("");//create Slider
    UIControls.addSlider("GSlider").setDecimalPrecision(0).setPosition(scl, scl + 12.3).setSliderMode(Slider.FLEXIBLE).setSize(scl * 3,10).setRange(0,255).setValue(127).setCaptionLabel("");//create Slider
    UIControls.addSlider("BSlider").setDecimalPrecision(0).setPosition(scl, scl + 23.3).setSliderMode(Slider.FLEXIBLE).setSize(scl * 3,10).setRange(0,255).setValue(127).setCaptionLabel("");//create Slider
    RSlider = UIControls.getController("RSlider");//make it easier to use Slider
    GSlider = UIControls.getController("GSlider");//make it easier to use Slider
    BSlider = UIControls.getController("BSlider");//make it easier to use Slider
    
    UIControls.addSlider("scrollSlider").setDecimalPrecision(0).setPosition(scl * 5,scl).setSliderMode(Slider.FLEXIBLE).setSize(scl * 2,scl).setRange(1,10).setValue(5).setColorBackground(color(50)).setCaptionLabel("");//create Slider
    scrollSlider = UIControls.getController("scrollSlider");//make it easier to use Slider
    
    fileSaveLoad = UIControls.addButtonBar("fileSaveLoad").addItems(split("Save Load Image", " ")).setSize(scl * 4, scl).setPosition(scl * 7,scl).setColorBackground(color(0, 127, 127));//create ButtonBar
    //fileSaveLoad = UIControls.getController("fileSaveLoad");
    
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
    
    
    UIControls.addButton("colorSelect").setSize(scl, scl).setPosition(0, scl).setCaptionLabel("Wheel");//create button
    colorSelect = UIControls.getController("colorSelect");//make it easier to use button
    
    UIControls.addTextfield("colorInputR").setPosition(scl * 4, scl * 2).setSize(scl, scl / 2).setVisible(false).setCaptionLabel("");//.setColorLabel(color(255, 0, 0));
    UIControls.addTextfield("colorInputG").setPosition(scl * 4, scl * 2.5).setSize(scl, scl / 2).setVisible(false).setCaptionLabel("");//.setColorLabel(color(0, 255, 0));
    UIControls.addTextfield("colorInputB").setPosition(scl * 4, scl * 3).setSize(scl, scl / 2).setVisible(false).setCaptionLabel("");//.setColorLabel(color(0, 0, 255));
    colorInputR = UIControls.getController("colorInputR");//make it easier to use Textfield
    colorInputG = UIControls.getController("colorInputG");//make it easier to use Textfield
    colorInputB = UIControls.getController("colorInputB");//make it easier to use Textfield
    
    UIControls.addButton("colorInput").setSize(scl, scl).setPosition(scl * 4, scl).setCaptionLabel("RGB");//create button
    colorInput = UIControls.getController("colorInput");//make it easier to use button
    
    UIControls.addButton("clearToggle").setSize(scl, scl).setPosition(scl * 11, scl).setCaptionLabel("Clear").setColorLabel(color(0, 0, 0)).setColorBackground(color(127, 127, 127));//create button
    clearToggle = UIControls.getController("clearToggle");//make it easier to use button
    
    UIControls.addButton("loadMap").setSize(scl * 2, scl).setPosition(scl * 6, 0).setCaptionLabel("Load Map");//create button
    loadMap = UIControls.getController("loadMap");//make it easier to use button
    
    changeVisibility(true);//go to tile map selection display
  }//void setup() END
}//class tileUI END

//---------------------------------------------------------------------------------------------------------------------------------------

void changeVisibility(boolean visibility){//change screen
  if(visibility){//are we going to the tile map loading screen
    loadMap.setPosition(scl * 5, 0);//change position
    loadMap.setLabel("Load Map");//change label
    
    fileSaveLoad.setPosition(0,0);//change position
    fileSaveLoad.changeItem("Save","text","Prev");//"Prev Next Load"
    fileSaveLoad.changeItem("Load","text","Next");//"Prev Next Load"
    fileSaveLoad.changeItem("Image","text","Load");//"Prev Next Load"
    
    clearToggle.setVisible(false);//clearToggle is not visible
    colorInput.setVisible(false);//colorInput is not visible
    colorSelect.setVisible(false);//colorSelect is not visible
    scrollSlider.setVisible(false);//scrollSlider is not visible
    RSlider.setVisible(false);//RSlider is not visible
    GSlider.setVisible(false);//GSlider is not visible
    BSlider.setVisible(false);//BSlider is not visible
  }else{
    loadMap.setPosition(scl * 14, scl);//change position
    loadMap.setLabel("Change Tileset");//change label
    
    fileSaveLoad.setPosition(scl * 7,scl);//change position
    fileSaveLoad.changeItem("Save","text","Save");//"Save Load Image"
    fileSaveLoad.changeItem("Load","text","Load");//"Save Load Image"
    fileSaveLoad.changeItem("Image","text","Image");//"Save Load Image"
    
    clearToggle.setVisible(true);//clearToggle is visible
    colorInput.setVisible(true);//colorInput is visible
    colorSelect.setVisible(true);//colorSelect is visible
    scrollSlider.setVisible(true);//scrollSlider is visible
    RSlider.setVisible(true);//RSlider is visible
    GSlider.setVisible(true);//GSlider is visible
    BSlider.setVisible(true);//BSlider is visible
  }
}//void changeVisibility(boolean visibility) END

//---------------------------------------------------------------------------------------------------------------------------------------

void clearToggle(){//called when clearToggle is clicked
  if(CClear){//is variable set
    CClear = false;//don't place clear tiles
    clearToggle.setColorLabel(color(0, 0, 0));//make text black
  }else{
    CClear = true;//place clear tiles
    clearToggle.setColorLabel(color(255, 255, 255));//make text white
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

void loadColors(int tile){//Load RGB Sliders and RGB Inputs with value from tile
  RSlider.setValue(mapTiles[tile].r);//Set Red Slider value to Red value of the tile
  GSlider.setValue(mapTiles[tile].g);//Set Green Slider value to Green value of the tile
  BSlider.setValue(mapTiles[tile].b);//Set Blue Slider value to Blue value of the tile
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