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

int scl = 32;

int cols = 100;
int rows = 100;

int borderThickness = 4;
PImage BACKGROUND;

tileUI UI = new tileUI();
canvasBG BG = new canvasBG();

void setup(){
  BACKGROUND = loadImage("assets/background.png");
  size(960,540);//X, Y
  //fullScreen();
  surface.setResizable(true);
}

void draw(){
  pushMatrix();
  translate(-30, -20);
  BG.draw();
  UI.draw();
  popMatrix();
  line(100,0,0,100);
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
    strokeWeight(borderThickness); // Thicker
    stroke(255,0,0);//RED
    line(1, 0, 1, rows*scl);//Draw Verticle lines
    line((scl * cols) - 1, 0, (scl * cols) - 1, rows*scl);//Draw Verticle lines
    line(0, 1, cols*scl, 1);//Draw Horizontal Lines
    line(0, (scl * rows) - 1, cols*scl, (scl * rows) - 1);//Draw Horizontal Lines
    strokeWeight(1); // Default
    stroke(0);//BLACK
  }
}