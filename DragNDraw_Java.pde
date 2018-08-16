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
int rowLength = 16;
int tileRow = 0;
int tileN = 1;

int fullTotalImages = (int)(Math.ceil((double)(totalImages / rowLength)) * rowLength) - 1;

int drawnTiles = 0;
boolean drawAll = false;
int FPSCutOff = 2;

int tileGroupStep = 0;
boolean tileGroupDeleting = false;
int sx1, sy1, sx2, sy2;
int tileGroupXLines = 0;
int tileGroupYLines = 0;

int tileBorderNumber = 0;

int offsetX = 0, offsetY = 0;

int scl = 32;

int cols = 100;
int rows = 100;

int SX = 0, SY = 0;
int mX, mY, pX, Py;
int fV = 1;
int UIRight = 22;
int UIBottom = 2;

int scrollAmount = 5;

PImage[] img = new PImage[totalImages];
mTile mapTiles[];
mTile mapTilesCopy[];
PImage BACKGROUND;
PImage missingTexture;

tileUI UI = new tileUI();
canvasBG BG = new canvasBG();
int borderThickness = 4;

void setup(){
  BACKGROUND = loadImage("assets/background.png");
  for(int i = 0; i <= totalImages; i++){
    img[i] = loadImage("assets/" + i + ".png");
  }
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

class mTile{//Tile Object
  int x, y;
  int image;
  int r, g, b;
  boolean clear;

  public mTile(int x, int y, int image, int r, int g, int b, boolean clear){//Tile Object
    this.x = x;//Store X Position
    this.y = y;//Store Y Position
    this.image = image;//Store Image Number
    this.r = r;//Store Red Value
    this.g = g;//Store Green Value
    this.b = b;//Store Blue Value
    this.clear = clear;//Is the tile clear
    //this.lore = lore || 0;//The LORE? of the tile
  }//mTile() END
}//mTile() END