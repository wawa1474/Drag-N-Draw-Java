import controlP5.*;

//Started August 16, 2018 at ~4:30 PM

int _DEBUG_ = 0;
int _DEBUGAMOUNT_ = 50000;

int _FILEVERSION_ = 0;

boolean dragging = false;
boolean deleting = false;
boolean noTile = false;

boolean noKeyboard = false;

int mapN = 0;
int totalImages = 39;

PImage BACKGROUND;

tileUI UI = new tileUI();
canvasBG BG = new canvasBG();

void setup(){
  BACKGROUND = loadImage("assets/background.png");
  size(100,100);
}

void draw(){
  BG.draw();
  UI.draw();
  
}

class tileUI{
  void draw(){
    line(0,0,100,100);
    text(str(_FILEVERSION_), 10,10);
  }
  
  void update(){
    
  }
  
  void setup(){
    
  }
}

class canvasBG{
  void draw(){
    background(255);
    image(BACKGROUND, 0, 0);
  }
  
  void border(){
    
  }
}