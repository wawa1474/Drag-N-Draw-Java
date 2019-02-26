button button = new button(32,32,32,32,color(0,127,127),"LOAD",color(255), 8);

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
  
  public button(int x, int y, int w, int h, color bC, String t, color tC, int tS){
    this.x = x;
    this.y = y;
    this.h = h;
    this.w = w;
    this.bColor = bC;
    
    this.t = t;
    this.tColor = tC;
    this.tSize = tS;
    
    //this.tSize = (h - 4) / 2;
    //textSize((h - 4) / 2);
    //this.tY = 4;
    //println(textWidth(t));
    //this.tX = floor(this.w - textWidth(t)) / 2;
  }
  
  void setup(){
    if(this.tSize == 0){
      this.tSize = (this.h - 4) / 2;
    }
    this.tY = this.y + (this.h / 2) + 4;
    println(textWidth(this.t));
    int tmp = floor((this.w - textWidth(this.t)) / 2);
    if(tmp < 0){
      this.tX = this.x - tmp;
    }else{
      this.tX = this.x + tmp;
    }
    println(this.tX);
  }
  
  boolean wasClicked(){
    return(mX > this.x - fV && mX < this.x + scl + fV && mY > this.y - fV && mY < this.y + scl + fV);//Are we clicking on the button
  }
  
  void draw(){
    stroke(color(255 - red(bColor), 255 - green(bColor), 255 - blue(bColor)));//set the outline to red
    strokeWeight(1);//this outline
    fill(bColor);//Set button background color
    rect(this.x, this.y, this.w, this.h);
    
    textSize(this.tSize);
    fill(tColor);//Set button text color
    text(this.t, this.tX, this.tY);
  }
}