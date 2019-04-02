//button button = new button(32,32,32,32,color(0,127,127),"LOAD",color(255), 8);
ArrayList<button> buttons_editorUI = new ArrayList<button>(0);
ArrayList<button> buttons_tilemapUI = new ArrayList<button>(0);
PImage[] gui;

final int button_editorUI_hueWheelVis = 0;
final int button_editorUI_rgbInputVis = 1;
final int button_editorUI_colorToggle = 2;
final int button_editorUI_newMap = 3;
final int button_editorUI_saveMap = 4;
final int button_editorUI_loadMap = 5;
final int button_editorUI_saveImage = 6;
final int button_editorUI_changeTileMap = 7;

final int button_tilemapUI_prevTileMap = 0;
final int button_tilemapUI_nextTileMap = 1;
final int button_tilemapUI_loadTileMap = 2;
final int button_tilemapUI_loadMapAndTileMap = 3;

void loadButtonImages(){
  PImage ui = loadImage("/assets/UI/Icons_byVellidragon.png");
  gui = new PImage[30];
  int pos = 0;
  for(int y = 0; y < 6; y++){
    for(int x = 0; x < 5; x++){
      PImage tmp = createImage(32, 32, ARGB);//create a temporary image
      tmp.copy(ui, x * 16, y * 16, 16, 16, 0, 0, 32, 32);
      gui[pos] = tmp;
      pos++;
    }
  }
}

class button{
  float x;//button x position
  float y;//button y position
  float h;//button height
  float w;//button width
  String t;//button text
  float tSize = 0;//button text size
  float tX;//button text x position
  float tY;//button text y position
  color bColor;//button background color
  color tColor;//button text color
  int identifier;//button identifier
  int image;//button image
  
  public button(float x_, float y_, float w_, float h_, color bC_, String t_, color tC_, float tS_, int identifier_, int image_){
    this.x = x_;
    this.y = y_;
    this.h = h_;
    this.w = w_;
    this.bColor = bC_;
    
    this.t = t_;
    this.tColor = tC_;
    this.tSize = tS_;
    
    this.identifier = identifier_;
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
  
  boolean wasClicked(){//are we clicking on a visible button
    return(mouseX > this.x + fudgeValue && mouseX < this.x + this.w - fudgeValue && mouseY > this.y + fudgeValue && mouseY < this.y + this.h - fudgeValue);//Are we clicking on the button
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

void setButtonColorBack(int button, color c){//set a buttons background color
  for(button b : buttons_editorUI){//go through all the buttons
    if(b.identifier == button){//if we've found our button
      b.bColor = c;//update its background color
    }
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------

void setButtonColorText(int button, color c){//set a buttons text color
  for(button b : buttons_editorUI){//go through all the buttons
    if(b.identifier == button){//if we've found our button
      b.tColor = c;//update its text color
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
  if(currentUI == _TILEMAPUI_){
    for(button b : buttons_tilemapUI){
      if(b.wasClicked()){
        switch(b.identifier){
          case button_tilemapUI_prevTileMap:
            tileMapShow--;//go to previous tile map
            if(tileMapShow < 0){//make sure we don't go below zero
              tileMapShow = tileMaps.size() - 1;//set to maxixmum tile map
            }
            return true;
        
          case button_tilemapUI_nextTileMap:
            tileMapShow++;//go to next tile map
            if(tileMapShow >= tileMaps.size()){//make sure we dont go above maximum tile map
              tileMapShow = 0;//set to 0
            }
            return true;
        
          case button_tilemapUI_loadTileMap:
            loadTileMap();//load selected tile map
            updateTileRow();//make sure we're on the correct row
            noTile = false;//allowed to place tiles
            changeUI(_EDITORUI_);//go to normal display
            screenX = tmpScreenX;//reload our position
            screenY = tmpScreenY;//reload our position
            return true;
        
          case button_tilemapUI_loadMapAndTileMap:
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
            return true;
        }
      }
    }
  }
  
  if(currentUI == _EDITORUI_){
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
            screenY = (scl * 2);//go back to the top left for looking at tile maps
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
  }
  return false;
}