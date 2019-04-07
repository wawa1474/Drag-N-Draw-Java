boolean noKeyboard = false;//Are We Blocking keyTyped() and keyPressed()?
int scrollAmount = 1;//How many squares to scroll when pressing WASD

void keyPressed(){//We pressed a key
  //maybe have a menu system tied to the escape key
  if(key == ESC){
    changeUI(_MAINMENU_);
    key = 0;  // Fools! don't let them escape!
  }
  //println(keyCode);//What key did we press?
  //if(noKeyboard == false){//are we blocking keyboard functions?
  //  if (keyCode == /*SHIFT*/16){//We pressed shift
  //    prevRowC();//Previous Tile row
  //  }else if (keyCode == /*SPACE*/32){//We pressed space
  //    nextRowC();//Next Tile Row
  //  }
  //}
  
  if(keyCode == /*SHIFT*/16){//holding Control
    scrollRows = true;
  }
}//void keyPressed() END

//---------------------------------------------------------------------------------------------------------------------------------------

void keyReleased(){
  if(keyCode == /*SHIFT*/16){//released Control
    scrollRows = false;
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------

void keyTyped(){//We typed a key
  //println(hex(key));
  if(currentUI == _EDITORUI_){
    switch(key){
      case 0x0005://ctrl + shift + e
        selectOutput("Select a PNG to write to:", "FileSaveCanvasSelect");//canvas save dialog
        scrollRows = false;//fixes a bug
        break;
        
      case 0x000E://ctrl + n
        clearMapTilesArray();//clear the map
        break;
        
      case 0x000F://ctrl + o
        selectInput("Select a file to load:", "FileLoadMapSelect");//map load dialog
        break;
        
      case 0x0013://ctrl + s
        selectOutput("Select a file to write to:", "fileSaveMapSelect");//map save dialog
        break;
    }
  }
  if(noKeyboard == false){//are we blocking keyboard functions?
    if(key == 'f'){//We pressed 'F'
      colorTiles = !colorTiles;
    }else if(key == 'q' && noTile == false){//We pressed 'Q'
      if(tileGroupStep == 0){//set XY1
        tileGroupStep = 1;//ready for next step
        sx1 = mouseX - screenX;//set x1 to mouse x position
        sy1 = mouseY - screenY - (scl * 2);//set y1 to mouse y position
      }else if (tileGroupStep == 1){//set XY2
        tileGroupStep = 2;//ready to do group tiles stuff
        sx2 = mouseX - screenX;//set x1 to mouse x position
        sy2 = mouseY - screenY - (scl * 2);//set y2 to mouse y position
      }else if (tileGroupStep == 2){//set XY2
        tileGroupStep = 0;//ready to do group tiles stuff
      }
    }else if(key == 'x'){//We pressed 'X'
      if(tileGroupStep == 2){//we're on step two of group selection
        tileGroupCutCopy('x');//cut group selection
      }
    }else if(key == 'c'){//We pressed 'C'
      if(tileGroupStep == 2){//we're on step two of group selection
        tileGroupCutCopy('c');//copy group selection
      }
    }else if(key == 'v' && noTile == false){//We pressed 'V'
      if(tileGroupStep != 3){//set it up for pasting
        tileGroupStep = 3;//paste step is 3
      }else if(tileGroupStep == 3){//cancel pasting
        tileGroupStep = 0;//paste step is 0
      }
    }else if(key == 'r'){//We pressed 'R'
      //for(int x = 0; x < mapTiles.size(); x++){//loop through all columns
      //  for(int y = 0; y < mapTiles.get(x).size(); y++){//loop through rows
      for(int x = screenX1; x < screenX2 + 1; x++){//loop through all columns
        for(int y = screenY1; y < screenY2 + 1; y++){//loop through rows
          if(x == mouseTileX && y == mouseTileY){//Are we clicking on the tile
            mTile tmp = mapTiles.get(x).get(y).get(mapTiles.get(x).get(y).size() - 1);//grab the tile
            println("Tile X Position: " + x + ", Y Position: " + y + ", Red Amount: " + tmp.r + ", Green Amount: " + tmp.g + ", Blue Amount: " + tmp.b + ", Tile Image #: " + tmp.image + ", Is Tile Colored: " + tmp.colored);// + ", Tile Lore: " + mapTiles[i].lore);
          }
        }
      }
    }else if(key == 'e'){//We pressed 'E'
      //for(int x = 0; x < mapTiles.size(); x++){//loop through all columns
      //  for(int y = 0; y < mapTiles.get(x).size(); y++){//loop through rows
      for(int x = screenX1; x < screenX2 + 1; x++){//loop through all columns
        for(int y = screenY1; y < screenY2 + 1; y++){//loop through rows
          if(x == mouseTileX && y == mouseTileY){//Are we clicking on the tile
            mTile tmp = mapTiles.get(x).get(y).get(mapTiles.get(x).get(y).size() - 1);//copy the tile
            loadColors(tmp);
          }
        }
      }
    }else if(key == 'p'){//We pressed 'P'
      backgroundRed = (int)RSlider.getValue();//set red
      backgroundGreen = (int)GSlider.getValue();//set green
      backgroundBlue = (int)BSlider.getValue();//set blue
    }else if(key == 'o'){//We pressed 'O'
      drawLines = !drawLines;//do we draw the background lines?
    }
    
    if(key == 'w'){//We pressed 'W'
      screenY += (scl * scrollAmount);//go up
      
      if(screenY > 0){//if we're to far up
        screenY = 0;//make it not so
      }
    }
    if(key == 'a'){//We pressed 'A'
      screenX += (scl * scrollAmount);//go left
      
      if(screenX > 0){//if we're to far left
        screenX = 0;//make it not so
      }
    }
    if(key == 's'){//We pressed 'S'
      if(rows > height / scl || currentUI == _TILEMAPUI_){
        screenY -= (scl * scrollAmount);//go down
        
        if(screenY < -((scl * (rows + 2)) - height) && currentUI != _TILEMAPUI_){//if we're to far down
          screenY = -((scl * (rows + 2)) - height) + 1;//make it not so
        }
      }
    }
    if(key == 'd'){//We pressed 'D'
      if(cols > width / scl || currentUI == _TILEMAPUI_){
        screenX -= (scl * scrollAmount);//go right
        
        if(screenX < -((scl * cols) - width) && currentUI != _TILEMAPUI_){//if we're to far right
          screenX = -((scl * cols) - width) + 1;//make it not so
        }
      }
    }
  }
}//void keyTyped() END