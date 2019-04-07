boolean noKeyboard = false;//Are We Blocking keyTyped() and keyPressed()?
int scrollAmount = 1;//How many squares to scroll when pressing WASD
boolean altHeld = false;
boolean ctrlHeld = false;
boolean shiftHeld = false;
int lastKey = -1;

void keyPressed(){//We pressed a key
  //println(keyCode);//What key did we press?
  //if(noKeyboard == false){//are we blocking keyboard functions?
  //  if (keyCode == /*SHIFT*/16){//We pressed shift
  //    prevRowC();//Previous Tile row
  //  }else if (keyCode == /*SPACE*/32){//We pressed space
  //    nextRowC();//Next Tile Row
  //  }
  //}
  
  switch(keyCode){
    case 16://shift
      shiftHeld = true;
      break;

    case 17://ctrl
      ctrlHeld = true;
      break;

    case 18://alt
      altHeld = true;
      break;
    
    case ESC:
      if(currentUI != _MAINMENU_){
        changeUI(_MAINMENU_);
        key = 0;  // Fools! don't let them escape!
      }else{
        //changeUI(previousUI);
        //key = 0;  // Fools! don't let them escape!
      }
      return;
  }
  lastKey = keyCode;
}//void keyPressed() END

//---------------------------------------------------------------------------------------------------------------------------------------

void keyReleased(){
  switch(keyCode){
    case 16://shift
      shiftHeld = false;
      break;

    case 17://ctrl
      ctrlHeld = false;
      break;

    case 18://alt
      altHeld = false;
      if(lastKey == 18){//alt
        displayedMenuBar = -1;
        lastKey = -1;
      }
      break;
  }
}

boolean keyHandler(int k, String keybind){
  String[] list = split(keybind, " ");
  String specialKeys = "";
  
  switch(list.length){
    case 0:
    case 1:
      return false;

    case 4:
      specialKeys = list[0] + " " + list[1] + " " + list[2];
      break;

    case 3:
      specialKeys = list[0] + " " + list[1];
      break;

    case 2:
      specialKeys = list[0];
      break;
  }
  
  if(str(list[list.length - 1].charAt(0)).toLowerCase().equals(str(char(k)).toLowerCase())){
    switch(specialKeys){
      case "ctrl":
        if(ctrlHeld == true && altHeld != true && shiftHeld != true){
          return true;
        }
      case "alt":
        if(ctrlHeld != true && altHeld == true && shiftHeld != true){
          return true;
        }
      case "shift":
        if(ctrlHeld != true && altHeld != true && shiftHeld == true){
          return true;
        }
      case "ctrl alt":
        if(ctrlHeld == true && altHeld == true && shiftHeld != true){
          return true;
        }
      case "ctrl shift":
        if(ctrlHeld == true && altHeld != true && shiftHeld == true){
          return true;
        }
      case "alt shift":
        if(ctrlHeld != true && altHeld == true && shiftHeld == true){
          return true;
        }
      case "ctrl alt shift":
        if(ctrlHeld == true && altHeld == true && shiftHeld == true){
          return true;
        }
      case "":
    }
  }
  
  return false;
}

//---------------------------------------------------------------------------------------------------------------------------------------

void keyTyped(){//We typed a key
  //println(hex(key));
  if(currentUI == _EDITORUI_){
    switch(displayedMenuBar){
      case button_menuBar_file:
        if(altHeld == true){
          switch(key){
            case 0x0065://alt + e
              selectOutput("Select a PNG to write to:", "FileSaveCanvasSelect");//canvas save dialog
              return;

            case 0x006E://alt + n
              clearMapTilesArray();//clear the map
              return;

            case 0x006F://alt + o
              selectInput("Select a file to load:", "FileLoadMapSelect");//map load dialog
              return;

            case 0x0073://alt + s
              selectOutput("Select a file to write to:", "fileSaveMapSelect");//map save dialog
              return;

            case 0x0078://alt + x
              exit();
              return;
          }
        }

      case button_menuBar_edit:
        if(keyHandler(lastKey, "alt t")){
          if(tileGroupStep == 2){//we're on step two of group selection
            tileGroupCutCopy('x');//cut group selection
          }
          return;
        }
        if(altHeld == true){
          switch(key){
            case 0x0074://alt + t
              //if(tileGroupStep == 2){//we're on step two of group selection
              //  tileGroupCutCopy('x');//cut group selection
              //}
              //return;

            case 0x0063://alt + c
              if(tileGroupStep == 2){//we're on step two of group selection
                tileGroupCutCopy('c');//copy group selection
              }
              return;

            case 0x0070://alt + p
              if(tileGroupStep != 3){//set it up for pasting
                tileGroupStep = 3;//paste step is 3
              }else if(tileGroupStep == 3){//cancel pasting
                tileGroupStep = 0;//paste step is 0
              }
              return;
          }
        }

      case button_menuBar_view:
    }
    
    switch(key){
      case 0x0005://ctrl + shift + e
        selectOutput("Select a PNG to write to:", "FileSaveCanvasSelect");//canvas save dialog
        shiftHeld = false;
        return;

      case 0x000E://ctrl + n
        clearMapTilesArray();//clear the map
        return;

      case 0x000F://ctrl + o
        selectInput("Select a file to load:", "FileLoadMapSelect");//map load dialog
        return;

      case 0x0013://ctrl + s
        selectOutput("Select a file to write to:", "fileSaveMapSelect");//map save dialog
        return;
    }
    
    if(altHeld == true){
      switch(key){
        case 0x0066://alt + f
          displayedMenuBar = button_menuBar_file;
          return;

        case 0x0065://alt + e
          displayedMenuBar = button_menuBar_edit;
          return;

        case 0x0076://alt + v
          displayedMenuBar = button_menuBar_view;
          return;
      }
    }
  }
  displayedMenuBar = -1;
  
  if(noKeyboard == false){//are we blocking keyboard functions?
    switch(key){
      case 'f'://We pressed 'F'
        colorTiles = !colorTiles;
        break;

      case 'q'://We pressed 'Q'
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
        break;

      case 'x'://We pressed 'X'
        if(tileGroupStep == 2){//we're on step two of group selection
          tileGroupCutCopy('x');//cut group selection
        }
        break;

      case 'c'://We pressed 'C'
        if(tileGroupStep == 2){//we're on step two of group selection
          tileGroupCutCopy('c');//copy group selection
        }
        break;

      case 'v'://We pressed 'V'
        if(tileGroupStep != 3){//set it up for pasting
          tileGroupStep = 3;//paste step is 3
        }else if(tileGroupStep == 3){//cancel pasting
          tileGroupStep = 0;//paste step is 0
        }
        break;

      case 'r'://We pressed 'R'
        for(int x = screenX1; x < screenX2 + 1; x++){//loop through all columns
          for(int y = screenY1; y < screenY2 + 1; y++){//loop through rows
            if(x == mouseTileX && y == mouseTileY && mapTiles.get(x).get(y).size() != 0){//Are we clicking on the tile
              mTile tmp = mapTiles.get(x).get(y).get(mapTiles.get(x).get(y).size() - 1);//grab the tile
              println("Tile X Position: " + x + ", Y Position: " + y + ", Red Amount: " + tmp.r + ", Green Amount: " + tmp.g + ", Blue Amount: " + tmp.b + ", Tile Image #: " + tmp.image + ", Is Tile Colored: " + tmp.colored);// + ", Tile Lore: " + mapTiles[i].lore);
            }
          }
        }
        break;

      case 'e'://We pressed 'E'
        for(int x = screenX1; x < screenX2 + 1; x++){//loop through all columns
          for(int y = screenY1; y < screenY2 + 1; y++){//loop through rows
            if(x == mouseTileX && y == mouseTileY && mapTiles.get(x).get(y).size() != 0){//Are we clicking on the tile
              mTile tmp = mapTiles.get(x).get(y).get(mapTiles.get(x).get(y).size() - 1);//copy the tile
              loadColors(tmp);
            }
          }
        }
        break;

      case 'p'://We pressed 'P'
        backgroundRed = (int)RSlider.getValue();//set red
        backgroundGreen = (int)GSlider.getValue();//set green
        backgroundBlue = (int)BSlider.getValue();//set blue
        break;

      case 'o'://We pressed 'O'
        drawLines = !drawLines;//do we draw the background lines?
        break;

      case 'w'://We pressed 'W'
        screenY += (scl * scrollAmount);//go up
        
        if(screenY > 0){//if we're to far up
          screenY = 0;//make it not so
        }
        break;

      case 'a'://We pressed 'A'
        screenX += (scl * scrollAmount);//go left
        
        if(screenX > 0){//if we're to far left
          screenX = 0;//make it not so
        }
        break;

      case 's'://We pressed 'S'
        if(rows > height / scl || currentUI == _TILEMAPUI_){
          screenY -= (scl * scrollAmount);//go down
        
          if(screenY < -((scl * (rows + 2)) - height) && currentUI != _TILEMAPUI_){//if we're to far down
            screenY = -((scl * (rows + 2)) - height) + 1;//make it not so
          }
        }
        break;

      case 'd'://We pressed 'D'
        if(cols > width / scl || currentUI == _TILEMAPUI_){
          screenX -= (scl * scrollAmount);//go right
        
          if(screenX < -((scl * cols) - width) && currentUI != _TILEMAPUI_){//if we're to far right
            screenX = -((scl * cols) - width) + 1;//make it not so
          }
        }
        break;
    }
  }
}//void keyTyped() END