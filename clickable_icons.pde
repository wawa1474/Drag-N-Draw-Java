boolean clickdrag = false;//are we dragging the mouse?

//ArrayList<clickableIcon> icons = new ArrayList<clickableIcon>(0);//make the array

//make clickableIcon extend mTile?
class clickableIcon extends mTile{//clickableIcon Object
  int x, y;//Store XY Position
  int w, h;//store width and height
  String file;//store what file to load
  String hoverText = null;//text to show when mouse is hovering over
  color borderColor = color(255,0,0);//what color is the border? (red)
  boolean showBorder = true;//do we show the border
  PImage hoverImage = null;
  
  clickableIcon(int w_, int h_, String file_, String hoverText_){
    super();
    w = w_;
    h = h_;
    file = file_;
    hoverText = hoverText_;
  }

  //clickableIcon(int x_, int y_, String file_, String hoverText_){//clickableIcon Object
  //  x = x_;//Store X Position
  //  y = y_;//Store Y Position
  //  w = scl;
  //  h = scl;
  //  file = file_;//store what file to load
  //  hoverText = hoverText_;//text to show when mouse is hovering over
  //}//public clickableIcon(int x, int y, String file) END
  
  //clickableIcon(int x_, int y_, String file_, PImage hoverImage_){//clickableIcon Object
  //  x = x_;//Store X Position
  //  y = y_;//Store Y Position
  //  w = scl;
  //  h = scl;
  //  file = file_;//store what file to load
  //  hoverImage = hoverImage_;//text to show when mouse is hovering over
  //}//public clickableIcon(int x, int y, String file) END
  
  //clickableIcon(int x_, int y_, int width_, int height_, String file_, String hoverText_){//clickableIcon Object
  //  x = x_;//Store X Position
  //  y = y_;//Store Y Position
  //  w = width_;
  //  h = height_;
  //  file = file_;//store what file to load
  //  hoverText = hoverText_;//text to show when mouse is hovering over
  //}//public clickableIcon(int x, int y, String file) END
  
  //clickableIcon(int x_, int y_, int width_, int height_, String file_, PImage hoverImage_){//clickableIcon Object
  //  x = x_;//Store X Position
  //  y = y_;//Store Y Position
  //  w = width_;
  //  h = height_;
  //  file = file_;//store what file to load
  //  hoverImage = hoverImage_;//text to show when mouse is hovering over
  //}//public clickableIcon(int x, int y, String file) END
  
  void draw(){//draw the icon
    if(showBorder){
      stroke(borderColor);//set the outline to red
      strokeWeight(borderThickness); //Make the outline Thicker
      line(x, y, x + w, y);//draw the top line
      line(x, y, x, y + h);//draw the left line
      line(x, y + h, x + w, y + h);//draw the bottom line
      line(x + w, y + h, x + w, y);//draw the right line
      strokeWeight(1); //Set the outline back to normal
      stroke(0);//make the outline to black
    }
  }
  
  void drawText(){//draw the hovering text
    if(hoverText != null){
      fill(BLACK);//black
      textSize(24);//larger
      text(hoverText, mouseX - screenX, mouseY - screenY - (UIBottom));//tie the text to the mouse
    } else {
      image(hoverImage, x, y - hoverImage.height);
    }
  }
  
  void loadMap(){
    fileName = file;//setup the file we want to load
    FileLoadMap();//and load it
  }
  
  boolean mouseOver(){//are we hovering over the icon
    int tmpX = mouseX - screenX;
    int tmpY = mouseY - screenY - UIBottom;
    if(tmpX > x - borderThickness && tmpY > y - borderThickness && tmpX < x + w + borderThickness && tmpY < y + h + borderThickness){//are we within the bounds of this icon?
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