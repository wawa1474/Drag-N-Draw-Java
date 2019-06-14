boolean noKeyboard = false;//Are We Blocking keyTyped() and keyPressed()?
int scrollAmount = 5;//How many squares to scroll when pressing WASD
boolean ctrlHeld = false;
boolean altHeld = false;
boolean shiftHeld = false;
//boolean deleteHeld = false;
int lastKey = -1;

String[] keyBinds = new String[19];

//boolean[] pressedKeys = new boolean[65536];

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
    case SHIFT://shift(16)
      shiftHeld = true;
      break;

    case CONTROL://ctrl(17)
      ctrlHeld = true;
      break;

    case ALT://alt(18)
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
    
    //case DELETE:
    //  deleteHeld = true;
    //  break;
  }
  lastKey = keyCode;
}//void keyPressed() END

//---------------------------------------------------------------------------------------------------------------------------------------

void keyReleased(){
  switch(keyCode){
    case SHIFT://shift(16)
      shiftHeld = false;
      break;

    case CONTROL://ctrl(17)
      ctrlHeld = false;
      break;

    case ALT://alt(18)
      altHeld = false;
      if(lastKey == ALT){//alt
        changeDisplayedMenuBar(button_menuBar_NONE);
        lastKey = -1;
      }
      break;

    //case DELETE:
    //  deleteHeld = false;
    //  break;
  }
}


/*
how do we support special keys all by themselves
  i.e. DELETE

what format do we save the keybinds in
  for "config" files

*/
boolean keyHandler(int key_, String keybind_){
  String[] list = split(keybind_, " ");
  
  if(list.length == 0){
    return false;
  }
  
  if(list.length == 1){
    if(list[0].length() > 1){
      switch(list[0]){
        case "DELETE":
          if(key_ == DELETE){
            return true;
          }
          break;
      }
      return false;
    }
  }
  
  if(str(list[list.length - 1].charAt(0)).toLowerCase().equals(str(char(key_)).toLowerCase())){
    for(int i = 0; i < list.length - 1; i++){
      boolean skip = false;
      String tmp = list[i].toLowerCase();
      if(tmp.equals("ctrl")){
        if(ctrlHeld == false){
          return false;
        }
        skip = true;
      }
      if(tmp.equals("alt") && skip == false){
        if(altHeld == false){
          return false;
        }
        skip = true;
      }
      if(tmp.equals("shift") && skip == false){
        if(shiftHeld == false){
          return false;
        }
      }
    }
  }else{
    return false;
  }
  
  return true;
}

//---------------------------------------------------------------------------------------------------------------------------------------

void keyTyped(){//We typed a key
  //println(hex(key));
  if(currentUI == _OPENING_){
    changeUI(_MAINMENU_);
  }

  switch(key){
    case 'g':
      //zoom += 0.1;
      break;
    
    case 'b':
      //zoom -= 0.1;
      break;
  }
  
  if(currentUI == _EDITORUI_){
    switch(displayedMenuBar){
      case button_menuBar_file:
        if(keyHandler(lastKey, "ALT + E")){
          selectOutput("Select a PNG to write to:", "FileSaveCanvasSelect");//canvas save dialog
          return;
        }
        
        if(keyHandler(lastKey, "ALT + N")){
          clearMapTilesArray();//clear the map
          clearClickableTilesArray();//clear the map
          return;
        }
        
        if(keyHandler(lastKey, "ALT + O")){
          selectInput("Select a file to load:", "FileLoadMapSelect");//map load dialog
          return;
        }
        
        if(keyHandler(lastKey, "ALT + O")){
          selectOutput("Select a file to write to:", "fileSaveMapSelect");//map save dialog
          return;
        }
        
        if(keyHandler(lastKey, "ALT + X")){
          _EXIT_ = true;
          exit();
          return;
        }

      case button_menuBar_edit:
        if(keyHandler(lastKey, "ALT + T")){
          if(tileGroupStep == 2){//we're on step two of group selection
            tileGroupCutCopy('x');//cut group selection
          }
          return;
        }
        
        if(keyHandler(lastKey, "ALT + C")){
          if(tileGroupStep == 2){//we're on step two of group selection
            tileGroupCutCopy('c');//copy group selection
          }
          return;
        }
        
        if(keyHandler(lastKey, "ALT + P")){
          if(tileGroupStep != 3){//set it up for pasting
            tileGroupStep = 3;//paste step is 3
          }else if(tileGroupStep == 3){//cancel pasting
            tileGroupStep = 0;//paste step is 0
          }
          return;
        }

      case button_menuBar_view:
        break;
    }
    
    if(keyHandler(lastKey, keyBinds[keyBind_exportCanvas])){//"CTRL + SHIFT + E"
      selectOutput("Select a PNG to write to:", "FileSaveCanvasSelect");//canvas save dialog
      shiftHeld = false;
      return;
    }
    
    if(keyHandler(lastKey, keyBinds[keyBind_saveMapAs])){//"CTRL + SHIFT + S"
      selectOutput("Select a file to write to:", "fileSaveMapSelect");//map save dialog
      shiftHeld = false;
      return;
    }
    
    if(keyHandler(lastKey, keyBinds[keyBind_newMap])){//"CTRL + N"
      clearMapTilesArray();//clear the map
      clearClickableTilesArray();//clear the map
      return;
    }
    
    if(keyHandler(lastKey, keyBinds[keyBind_openMap])){//"CTRL + O"
      selectInput("Select a file to load:", "FileLoadMapSelect");//map load dialog
      return;
    }
    
    if(keyHandler(lastKey, keyBinds[keyBind_saveMap])){//"CTRL + S"
      //selectOutput("Select a file to write to:", "fileSaveMapSelect");//map save dialog
      if(fileName.equals("Error")){//if no file was selected
        selectOutput("Select a file to write to:", "fileSaveMapSelect");//map save dialog
      }else{
        fileSaveMap();
      }
      return;
    }
    
    if(keyHandler(lastKey, "ALT + F")){
      changeDisplayedMenuBar(button_menuBar_file);
      return;
    }
    
    if(keyHandler(lastKey, "ALT + E")){
      changeDisplayedMenuBar(button_menuBar_edit);
      return;
    }
    
    if(keyHandler(lastKey, "ALT + V")){
      changeDisplayedMenuBar(button_menuBar_view);
      return;
    }
  }
  //displayedMenuBar = -1;
  changeDisplayedMenuBar(button_menuBar_NONE);
  
  if(noKeyboard == false){//are we blocking keyboard functions?
    if(keyHandler(lastKey, keyBinds[keyBind_colorTiles])){//"F"
      colorTiles = !colorTiles;
      return;
    }
    
    if(keyHandler(lastKey, keyBinds[keyBind_tileGroup])){//"Q"
      if(tileGroupStep == 0){//set XY1
        tileGroupStep = 1;//ready for next step
        sx1 = mouseX - screenX;//set x1 to mouse x position
        sy1 = mouseY - screenY - (UIBottom);//set y1 to mouse y position
      }else if (tileGroupStep == 1){//set XY2
        tileGroupStep = 2;//ready to do group tiles stuff
        sx2 = mouseX - screenX;//set x1 to mouse x position
        sy2 = mouseY - screenY - (UIBottom);//set y2 to mouse y position
      }else if (tileGroupStep == 2){//set XY2
        tileGroupStep = 0;//ready to do group tiles stuff
      }
      return;
    }
    
    if(keyHandler(lastKey, keyBinds[keyBind_cut])){//"X"
      if(tileGroupStep == 2){//we're on step two of group selection
        tileGroupCutCopy('x');//cut group selection
      }
      return;
    }
    
    if(keyHandler(lastKey, keyBinds[keyBind_copy])){//"C"
      if(tileGroupStep == 2){//we're on step two of group selection
        tileGroupCutCopy('c');//copy group selection
      }
      return;
    }
    
    if(keyHandler(lastKey, keyBinds[keyBind_paste])){//"V"
      if(tileGroupStep != 3){//set it up for pasting
        tileGroupStep = 3;//paste step is 3
      }else if(tileGroupStep == 3){//cancel pasting
        tileGroupStep = 0;//paste step is 0
      }
      return;
    }
    
    if(keyHandler(lastKey, keyBinds[keyBind_tileDebug])){//"R"
      for(int x = screenX1; x < screenX2 + 1; x++){//loop through all columns
        for(int y = screenY1; y < screenY2 + 1; y++){//loop through rows
          if(x == mouseTileX && y == mouseTileY && mapTiles.get(x).get(y).size() != 0){//Are we clicking on the tile
            mTile tmp = mapTiles.get(x).get(y).get(mapTiles.get(x).get(y).size() - 1);//grab the tile
            println("Tile X Position: " + x + ", Y Position: " + y + ", Red Amount: " + tmp.getRed() + ", Green Amount: " + tmp.getGreen() + ", Blue Amount: " + tmp.getBlue() + ", Tile Image #: " + tmp.image + ", Is Tile Colored: " + tmp.colored);// + ", Tile Lore: " + mapTiles[i].lore);
          }
        }
      }
      return;
    }
    
    if(keyHandler(lastKey, keyBinds[keyBind_copyColor])){//"E"
      for(int x = screenX1; x < screenX2 + 1; x++){//loop through all columns
        for(int y = screenY1; y < screenY2 + 1; y++){//loop through rows
          if(x == mouseTileX && y == mouseTileY && mapTiles.get(x).get(y).size() != 0){//Are we clicking on the tile
            mTile tmp = mapTiles.get(x).get(y).get(mapTiles.get(x).get(y).size() - 1);//copy the tile
            loadColors(tmp);
          }
        }
      }
      return;
    }
    
    if(keyHandler(lastKey, keyBinds[keyBind_setBackground])){//"P"
      backgroundRed = red(currentTileColor);//set red
      backgroundGreen = green(currentTileColor);//set green
      backgroundBlue = blue(currentTileColor);//set blue
      return;
    }
    
    if(keyHandler(lastKey, keyBinds[keyBind_lines])){//"O"
      drawLines = !drawLines;//do we draw the background lines?
      return;
    }
    
    if(keyHandler(lastKey, keyBinds[keyBind_moveUp])){//"W"
      screenY += (scl * scrollAmount);//go up
        
      if(screenY > 0){//if we're to far up
        screenY = 0;//make it not so
      }
      return;
    }
    
    if(keyHandler(lastKey, keyBinds[keyBind_moveLeft])){//"A"
      screenX += (scl * scrollAmount);//go left
        
      if(screenX > 0){//if we're to far left
        screenX = 0;//make it not so
      }
      return;
    }
    
    if(keyHandler(lastKey, keyBinds[keyBind_moveDown])){//"S"
      if(rows > height / scl || currentUI == _TILEMAPUI_){
        screenY -= (scl * scrollAmount);//go down
      
        if(screenY < -((scl * (rows + 2)) - height) && currentUI != _TILEMAPUI_){//if we're to far down
          screenY = -((scl * (rows + 2)) - height) + 1;//make it not so
        }
      }
      return;
    }
    
    if(keyHandler(lastKey, keyBinds[keyBind_moveRight])){//"D"
      if(cols > width / scl || currentUI == _TILEMAPUI_){
        screenX -= (scl * scrollAmount);//go right
      
        if(screenX < -((scl * cols) - width) && currentUI != _TILEMAPUI_){//if we're to far right
          screenX = -((scl * cols) - width) + 1;//make it not so
        }
      }
      return;
    }
    
    if(keyHandler(lastKey, keyBinds[keyBind_delete])){//"DELETE"
      if(tileGroupStep == 2){//we're on step two of group selection
        tileGroupCutCopy('d');//cut group selection
      }
      return;
    }
  }
}//void keyTyped() END