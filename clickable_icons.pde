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
      //rect(scl * 5, scl * 5, scl, scl);
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
    text(this.hoverText, mouseX - SX, mouseY - SY);//tie the text to the mouse
  }
  
  boolean wasClicked(){//did we click this icon?
    if(dragging || deleting || clickdrag){//were we dragging or deleting a tile or were we dragging the mouse
      return false;//then no we weren't clicking this icon
    }
    if(mouseX - SX > this.x - 5 && mouseY - SY > this.y - 5 && mouseX - SX < this.x + scl + 5 && mouseY - SY < this.y + scl + 5){//are we within the bounds of this icon?
      fileName = file;//setup the file we want to load
      FileLoadMap();//and load it
      return true;//we did click the icon
    }
    return false;//no we weren't clicking this icon
  }
  
  boolean hoveringOver(){//are we hovering over the icon
    if(mouseX - SX > this.x - 5 && mouseY - SY > this.y - 5 && mouseX - SX < this.x + scl + 5 && mouseY - SY < this.y + scl + 5){//are we within the bounds of this icon?
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

void drawIcons(){//draw all icons
  for(int i = 0; i < icons.size(); i++){//Go through all the clickable icons
    icons.get(i).draw();//draw the icon
    if(icons.get(i).hoveringOver()){//if mouse hovering over icon
      icons.get(i).drawText();//draw the icons text
    }
  }
}