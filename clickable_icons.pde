boolean clickdrag = false;//are we dragging the mouse?

ArrayList<clickableIcon> icons = new ArrayList<clickableIcon>(0);//make the array

class clickableIcon{//clickableIcon Object
  int x, y;//Store XY Position
  String file;//store what file to load
  String hoverText;//text to show when mouse is hovering over
  color borderColor = color(255,0,0);//what color is the border? (red)
  boolean showBorder = true;//do we show the border

  public clickableIcon(int x_, int y_, String file_, String hoverText_){//clickableIcon Object
    this.x = x_;//Store X Position
    this.y = y_;//Store Y Position
    this.file = file_;//store what file to load
    this.hoverText = hoverText_;//text to show when mouse is hovering over
  }//public clickableIcon(int x, int y, String file) END
  
  void draw(){//draw the icon
    if(showBorder){
      stroke(borderColor);//set the outline to red
      strokeWeight(borderThickness); //Make the outline Thicker
      line(x, y, x + scl, y);//draw the top line
      line(x, y, x, y + scl);//draw the left line
      line(x, y + scl, x + scl, y + scl);//draw the bottom line
      line(x + scl, y + scl, x + scl, y);//draw the right line
      strokeWeight(1); //Set the outline back to normal
      stroke(0);//make the outline to black
    }
  }
  
  void drawText(){//draw the hovering text
    fill(BLACK);//black
    textSize(24);//larger
    text(this.hoverText, mouseX - screenX, mouseY - screenY - (UIBottom));//tie the text to the mouse
  }
  
  void loadMap(){
    fileName = this.file;//setup the file we want to load
    FileLoadMap();//and load it
  }
  
  boolean mouseOver(){//are we hovering over the icon
    if(mouseX - screenX > this.x - 5 && mouseY - screenY - (UIBottom) > this.y - 5 && mouseX - screenX < this.x + scl + 5 && mouseY - screenY - (UIBottom) < this.y + scl + 5){//are we within the bounds of this icon?
      return true;//yes we're hovering over the icon
    }
    return false;//no we aren't hovering over the icon
  }
}//class mTile() END

//---------------------------------------------------------------------------------------------------------------------------------------

void clearClickableTilesArray(){//delete all the icons
  icons.clear();//delete all icons
}

//---------------------------------------------------------------------------------------------------------------------------------------

boolean checkMouseOverIcon(boolean loadMap_){
  if(dragging || deleting){//were we dragging or deleting a tile or were we dragging the mouse
    //do nothing
  }else{
    for(int i = 0; i < icons.size(); i++){//go through all icons
      if(icons.get(i).mouseOver()){//if we clicked on one
        if(loadMap_ == true){ icons.get(i).loadMap(); }
        return true;//do nothing
      }
    }
  }
  return false;
}