boolean clickdrag = false;//are we dragging the mouse?

ArrayList<clickableIcon> icons = new ArrayList<clickableIcon>(0);//make the array

class clickableIcon{//clickableIcon Object
  int x, y;//Store XY Position
  String file;//store what file to load
  String hoverText;//text to show when mouse is hovering over
  color borderColor = color(255,0,0);//what color is the border? (red)
  boolean showBorder = true;//do we show the border

  public clickableIcon(int x, int y, String file, String hoverText){//clickableIcon Object
    this.x = x;//Store X Position
    this.y = y;//Store Y Position
    this.file = file;//store what file to load
    this.hoverText = hoverText;//text to show when mouse is hovering over
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
    fill(0);//black
    textSize(24);//larger
    text(this.hoverText, (mouseX - SX) / globalScale, (mouseY - SY) / globalScale);//tie the text to the mouse
  }
  
  void loadMap(){
    fileName = this.file;//setup the file we want to load
    FileLoadMap();//and load it
  }
  
  boolean mouseOver(){//are we hovering over the icon
    if(mouseX - SX > (this.x - 5) * globalScale && mouseY - SY > (this.y - 5) * globalScale && mouseX - SX < (this.x + scl + 5) * globalScale && mouseY - SY < (this.y + scl + 5) * globalScale){//are we within the bounds of this icon?
      return true;//we did click the icon
    }
    return false;//no we aren't hovering over the icon
  }
}//class mTile() END

//---------------------------------------------------------------------------------------------------------------------------------------

void clearClickableTilesArray(){//delete all the icons
  icons.clear();//delete all icons
}

//---------------------------------------------------------------------------------------------------------------------------------------

void drawIcons(){//draw all icons
  for(int i = 0; i < icons.size(); i++){//Go through all the clickable icons
    icons.get(i).draw();//draw the icon
    if(icons.get(i).mouseOver()){//if mouse hovering over icon
      icons.get(i).drawText();//draw the icons text
    }
  }
}

boolean checkMouseOverIcon(boolean loadMap){
  if(dragging || deleting || clickdrag){//were we dragging or deleting a tile or were we dragging the mouse
    //do nothing
  }else{
    for(int i = 0; i < icons.size(); i++){//go through all icons
      if(icons.get(i).mouseOver()){//if we clicked on one
        if(loadMap == true){ icons.get(i).loadMap(); }
        return true;//do nothing
      }
    }
  }
  return false;
}