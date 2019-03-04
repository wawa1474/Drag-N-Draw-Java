boolean noKeyboard = false;//Are We Blocking keyTyped() and keyPressed()?
int scrollAmount = 1;//How many squares to scroll when pressing WASD

void keyPressed(){//We pressed a key
  if(noKeyboard == false){//are we blocking keyboard functions?
    //println(keyCode);//What key did we press?
    if (keyCode == /*SHIFT*/16){//We pressed shift
      prevRowC();//Previous Tile row
    }else if (keyCode == /*SPACE*/32){//We pressed space
      nextRowC();//Next Tile Row
    }
  }
}//void keyPressed() END

//---------------------------------------------------------------------------------------------------------------------------------------

void keyTyped(){//We typed a key
  if(noKeyboard == false){//are we blocking keyboard functions?
    if(key == 'f'){//We pressed 'F'
      if(CClear){//Is it currently clear?
        CClear = false;//Set it not clear
        clearToggle.setColorLabel(color(255));//make text black
      }else{//Its not clear
        CClear = true;//Set it clear
        clearToggle.setColorLabel(color(0));//make text white
      }
    }else if(key == 'x'){//We pressed 'X'
      if(tileGroupStep == 2){//we're on step two of group selection
        tileGroupCutCopy('x');//cut group selection
      }
    }else if(key == 'c'){//We pressed 'C'
      if(tileGroupStep == 2){//we're on step two of group selection
        tileGroupCutCopy('c');//copy group selection
      }
    }else if(key == 'v'){//We pressed 'V'
      if(tileGroupStep != 3){//set it up for pasting
        tileGroupStep = 3;//paste step is 3
      }else if(tileGroupStep == 3){//cancel pasting
        tileGroupStep = 0;//paste step is 0
      }
    }else if(key == 'r'){//We pressed 'R'
      for(int x = 0; x < mapTiles.size(); x++){//go through all columns
        for(int y = 0; y < mapTiles.get(x).size(); y++){//go through all rows
          if(isCursorOnTile(x, y)){//Are we clicking on the tile
            mTile tmp = mapTiles.get(x).get(y).get(mapTiles.get(x).get(y).size() - 1);//grab the tile
            println("Tile X Position: " + x + ", Y Position: " + y + ", Red Amount: " + tmp.r + ", Green Amount: " + tmp.g + ", Blue Amount: " + tmp.b + ", Tile Image #: " + tmp.image + ", Is Tile Clear: " + tmp.clear);// + ", Tile Lore: " + mapTiles[i].lore);
          }
        }
      }
    }else if(key == 'e'){//We pressed 'E'
      for(int x = 0; x < mapTiles.size(); x++){//go through all columns
        for(int y = 0; y < mapTiles.get(x).size(); y++){//go through all rows
          if(isCursorOnTile(x, y)){//Are we clicking on the tile
            mTile tmp = mapTiles.get(x).get(y).get(mapTiles.get(x).get(y).size() - 1);//copy the tile
            loadColors(tmp);
          }
        }
      }
    }else if(key == 'q'){//We pressed 'Q'
      if(tileGroupStep == 0){//set XY1
        tileGroupStep = 1;//ready for next step
        sx1 = mouseX - SX;//set x1 to mouse x position
        sy1 = mouseY - SY;//set y1 to mouse y position
      }else if (tileGroupStep == 1){//set XY2
        tileGroupStep = 2;//ready to do group tiles stuff
        sx2 = mouseX - SX;//set x1 to mouse x position
        sy2 = mouseY - SY;//set y2 to mouse y position
      }else if (tileGroupStep == 2){//set XY2
        tileGroupStep = 0;//ready to do group tiles stuff
      }
    }else if(key == 'p'){//We pressed 'P'
      BG.r = (int)RSlider.getValue();//set red
      BG.g = (int)GSlider.getValue();//set green
      BG.b = (int)BSlider.getValue();//set blue
    }else if(key == 'o'){//We pressed 'O'
      drawLines = !drawLines;//do we draw the background lines?
    }
    
    if(key == 'w'){//We pressed 'W'
      SY += (scl * scrollAmount);//go up
      
      if(SY > 64){//if we're to far up
        SY = 64;//make it not so
      }
    }
    if(key == 'a'){//We pressed 'A'
      SX += (scl * scrollAmount);//go left
      
      if(SX > 0){//if we're to far left
        SX = 0;//make it not so
      }
    }
    if(key == 's'){//We pressed 'S'
      SY -= (scl * scrollAmount);//go down
      
      if(SY < -((scl * rows) - height)){//if we're to far down
        SY = -((scl * rows) - height);//make it not so
      }
      //println(SY);
    }
    if(key == 'd'){//We pressed 'D'
      SX -= (scl * scrollAmount);//go right
      
      if(SX < -((scl * cols) - width)){//if we're to far right
        SX = -((scl * cols) - width);//make it not so
      }
    }
  }
}//void keyTyped() END