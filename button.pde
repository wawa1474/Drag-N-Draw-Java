//button button = new button(32,32,32,32,color(0,127,127),"LOAD",color(255), 8);
ArrayList<button> buttons = new ArrayList<button>(0);
PImage[] gui;

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
  float x;
  float y;
  float h;
  float w;
  String t;
  float tSize = 0;
  float tX;
  float tY;
  color bColor;
  color tColor;
  boolean visible;
  String name;
  int image;
  
  public button(float x, float y, float w, float h, color bC, String t, color tC, float tS, boolean vis, String name, int image){
    this.x = x;
    this.y = y;
    this.h = h;
    this.w = w;
    this.bColor = bC;
    
    this.t = t;
    this.tColor = tC;
    this.tSize = tS;
    
    this.visible = vis;
    
    //this.tSize = (h - 4) / 2;
    //textSize((h - 4) / 2);
    //this.tY = 4;
    //println(textWidth(t));
    //this.tX = floor(this.w - textWidth(t)) / 2;
    this.name = name;
    this.image = image;
  }
  
  void setup(){
    if(this.tSize == 0){
      this.tSize = (this.h - 4) / 2;
    }
    this.tY = this.y + (this.h / 2) + 4;
    //println(textWidth(this.t));
    int tmp = floor((this.w - textWidth(this.t)) / 2);
    if(tmp < 0){
      this.tX = this.x - tmp;
    }else{
      this.tX = this.x + tmp;
    }
    //println(this.tX);
  }
  
  boolean wasClicked(){
    int tmpX = mX + SX;
    int tmpY = mY + SY;
    //print(this.name + ": ");
    //println(tmpX > this.x + fV && tmpX < this.x + this.w - fV && tmpY > this.y + fV && tmpY < this.y + this.h - fV && this.visible);// && mX < this.x + this.w - fV && mY > this.y + fV && mY < this.y + this.h - fV);
    return(tmpX > this.x + fV && tmpX < this.x + this.w - fV && tmpY > this.y + fV && tmpY < this.y + this.h - fV && this.visible);//Are we clicking on the button
  }
  
  void draw(){
    if(this.visible){
      stroke(color(255 - red(this.bColor), 255 - green(this.bColor), 255 - blue(this.bColor)));//set the outline to red
      strokeWeight(1);//this outline
      fill(this.bColor);//Set button background color
      rect(this.x, this.y, this.w, this.h);
    
      textSize(this.tSize);
      fill(this.tColor);//Set button text color
      text(this.t, this.tX, this.tY);
      
      //if(this.image != -1){
      //  image(gui[this.image], this.x, this.y);
      //}
    }
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------

void setButtonColorBack(String button, color c){
  for(button b : buttons){
    if(b.name.equals(button)){
      b.bColor = c;
    }
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------

void setButtonColorText(String button, color c){
  for(button b : buttons){
    if(b.name.equals(button)){
      b.tColor = c;
    }
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------

void setButtonVis(String button, boolean vis){
  for(button b : buttons){
    if(b.name.equals(button)){
      b.visible = vis;
    }
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------

void setButtonPos(String button, int x, int y){
  for(button b : buttons){
    if(b.name.equals(button)){
      b.x = x;
      b.y = y;
      b.setup();
    }
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------

boolean checkButtons(){
  for(button b : buttons){
    if(b.wasClicked()){
      switch(b.name){
        case "hue":
          colorSelect();
          return true;
        
        case "rgb":
          colorInput();
          return true;
        
        case "clear":
          clearToggle();
          return true;
        
        case "load map":
          buttonLoadMap();
          return true;
        
        case "change map":
          buttonChangeTileMap();
          return true;
        
        case "save":
          selectOutput("Select a file to write to:", "fileSaveMapSelect");//map save dialog
          return true;
        
        case "load":
          selectInput("Select a file to load:", "FileLoadMapSelect");//map load dialog
          return true;
        
        case "image":
          selectOutput("Select a PNG to write to:", "FileSaveCanvasSelect");//canvas save dialog
          return true;
        
        case "prev":
          buttonPrevTileMap();
          return true;
        
        case "next":
          buttonNextTileMap();
          return true;
        
        case "load tile":
          buttonLoadTileMap();
          return true;
      }
    }
  }
  return false;
}