boolean clickdrag = false;
clickableIcon[] icons = new clickableIcon[0];//clickable icons Array

class clickableIcon{//clickableIcon Object
  int x, y;//Store XY Position
  String file;//store what file to load
  String hoverText;//text to show when mouse is hovering over

  public clickableIcon(int x, int y, String file, String hoverText){//clickableIcon Object
    this.x = x;//Store X Position
    this.y = y;//Store Y Position
    this.file = file;//store what file to load
    this.hoverText = hoverText;//text to show when mouse is hovering over
  }//public clickableIcon(int x, int y, String file) END
  
  void draw(){
    stroke(255,0,0);
    //rect(scl * 5, scl * 5, scl, scl);
    strokeWeight(borderThickness); // Thicker
    line(x, y, x + scl, y);
    line(x, y, x, y + scl);
    line(x, y + scl, x + scl, y + scl);
    line(x + scl, y + scl, x + scl, y);
    strokeWeight(1); // Thicker
    stroke(0);
  }
  
  boolean wasClicked(){
    if(dragging || deleting || clickdrag){
      return false;
    }
    if(mouseX > this.x - 5 && mouseY > this.y - 5 && mouseX < this.x + scl + 5 && mouseY < this.y + scl + 5){
      fileName = file;
      FileLoadMap();
      return true;
    }
    return false;
  }
  
  boolean hoveringOver(){
    if(mouseX > this.x - 5 && mouseY > this.y - 5 && mouseX < this.x + scl + 5 && mouseY < this.y + scl + 5){
      return true;
    }
    return false;
  }
}//class mTile() END