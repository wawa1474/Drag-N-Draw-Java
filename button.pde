//button button = new button(32,32,32,32,color(0,127,127),"LOAD",color(255), 8);
ArrayList<button> buttons = new ArrayList<button>(0);

class button{
  int x;
  int y;
  int h;
  int w;
  String t;
  int tSize = 0;
  int tX;
  int tY;
  color bColor;
  color tColor;
  boolean visible;
  String name;
  
  public button(int x, int y, int w, int h, color bC, String t, color tC, int tS, boolean vis, String name){
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

void checkButtons(){
  for(button b : buttons){
    if(b.wasClicked()){
      switch(b.name){
        case "hue":
          colorSelect();
          break;
        
        case "rgb":
          colorInput();
          break;
        
        case "clear":
          clearToggle();
          break;
        
        case "load map":
          loadMap();
          break;
        
        case "save":
          selectOutput("Select a file to write to:", "fileSaveMapSelect");//map save dialog
          break;
        
        case "load":
          selectInput("Select a file to load:", "FileLoadMapSelect");//map load dialog
          break;
        
        case "image":
          selectOutput("Select a PNG to write to:", "FileSaveCanvasSelect");//canvas save dialog
          break;
        
        case "prev":
          buttonPrevTileMap();
          break;
        
        case "next":
          buttonNextTileMap();
          break;
        
        case "load tile":
          buttonLoadTileMap();
          break;
      }
    }
  }
}