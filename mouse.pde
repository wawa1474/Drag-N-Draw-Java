boolean dragging = false;// Is a tile being dragged?
boolean deleting = false;//Are we deleting tiles?
boolean noTile = false;//Are we blocking placement of tiles?

boolean scrollRows = false;//do we scroll a full row

int screenX = 0, screenY = 0;//Screen XY
int tmpScreenX = 0, tmpScreenY = 0;//saved Screen XY
int mouseTileX = 0, mouseTileY = 0;//what tile is the mouse on
final int fudgeValue = 1;//Fudge Value to make sure we're really clicking inside something


void updateMouseXY(){//Update the XY position of the mouse
  mouseTileX = floor((mouseX - screenX) / scl);
  mouseTileY = floor(((mouseY - screenY) - (scl * 2)) / scl);
}//void updateXY() END

//---------------------------------------------------------------------------------------------------------------------------------------

void mousePressed(){//We pressed a mouse button
  if(currentUI == _MAINMENU_){
    switch(menuButton){
      case button_mainMenuUI_dragNDraw:
        changeUI(_TILEMAPUI_);
        return;

      case button_mainMenuUI_options:
        changeUI(_OPTIONSMENU_);
        return;

      case button_mainMenuUI_exit:
        exit();
        return;
    }
  }

  if(checkButtons()){
    return;
  }

  if(currentUI == _TILEMAPUI_){
    //if selecting a Tile Map do nothing
  }else{
  
  if(checkMouseOverIcon(true)){//is the mouse over an icon? if so load the file
    return;//and make sure to not place a tile
  }

  if(noTile){//if we're not allowed to place tiles
    return;//do nothing
  }

  if(tileGroupStep == 3){//pasteing group of tiles
    if(mouseButton == LEFT){//We clicked with the left button
      tileGroupPaste();//paste group selection
      tileGroupStep = 0;//reset group selection step
      return;//Block normal action
    }
  }

  if(tileGroupStep == 2){//placing group of tiles
    if(mouseButton == LEFT){//We clicked with the left button
      tileGroup("left");//placing image tiles
      return;//Block normal action
    }else if(mouseButton == CENTER){//We clicked with the middle button
      for(int x = screenX1; x < screenX2 + 1; x++){//loop through all columns
        for(int y = screenY1; y < screenY2 + 1; y++){//loop through rows
          if(x == mouseTileX && y == mouseTileY && mapTiles.get(x).get(y).size() != 0){//Are we clicking on the tile
            tileGroupDeleting = true;//deleting group of tiles
          }
        }
      }//Went through all the tiles
      tileGroup("center");//placing colored tile
      return;//Block normal action
    }
  }

  if(mouseButton == RIGHT){//We clicked with the right button
    if(tileGroupStep == 2){//placing group of tiles
      tileGroup("right");//coloring group of tiles
    }else{//otherwise
      for(int x = screenX1; x < screenX2 + 1; x++){//loop through all columns
        for(int y = screenY1; y < screenY2 + 1; y++){//loop through rows
          if(x == mouseTileX && y == mouseTileY){//Are we clicking on the tile
            mTile tmp = mapTiles.get(x).get(y).get(0);//grab the bottom tile
            tmp.r = (int)RSlider.getValue();//set tile red value
            tmp.g = (int)GSlider.getValue();//set tile green value
            tmp.b = (int)BSlider.getValue();//set tile blue value
          }
        }
      }//Went through all the tiles
    }
    return;//Block normal action
  }

  for(int i = 0; i < rowLength; i++){//Go through all the tiles in the row
    if(mouseX > (scl * i) + fudgeValue && mouseX < (scl * (i + 1)) - fudgeValue && mouseY > 0 + fudgeValue && mouseY < scl - fudgeValue){//Are we clicking on the tile UI
      noTile = true;//Dont allow tile placement
      if(tileImages[rowLength*tileRow+i] == null){return;}//if image doesn't exist return
      tileN = rowLength*tileRow+i;//Set the tile cursor to the tile we clicked on
    }
  }//Went through all the tiles in the row

  if(mouseY < UIBottom * scl){//Did we click on the UI
    noTile = true;//Dont allow tile placement
    return;//Don't do anything else
  }

  // Did I click on the rectangle?
  for(int x = screenX1; x < screenX2 + 1; x++){//loop through all columns
    for(int y = screenY1; y < screenY2 + 1; y++){//loop through rows
      if(x == mouseTileX && y == mouseTileY && mapTiles.get(x).get(y).size() != 0){//Are we clicking on the tile
        if(mouseButton == CENTER){//We clicked with the middle button
          deleteTile(x, y, mapTiles.get(x).get(y).size() - 1);//Delete a tile
          deleting = true;//We're deleting
          return;//Block normal action
        }else if(mouseButton == LEFT && colorTiles){//We clicked with the left button
          tmpTile = mapTiles.get(x).get(y).get(mapTiles.get(x).get(y).size() - 1);//copy the tile
          deleteTile(x, y, mapTiles.get(x).get(y).size() - 1);//Delete a tile
          dragging = true;//We dragging
          loadColors(tmpTile);//Load the color inputs and sliders with the color from the tile
          loadTile(tmpTile);//load tile image
          return;//Block normal action
        }/*else if(mouseButton == RIGHT){//We clicked with the right button
        }*/
      }
    }
  }//Went through all the tiles
  placeTile();//Place a tile at current mouse position
  }
}//void mousePressed() END

//---------------------------------------------------------------------------------------------------------------------------------------

void mouseDragged(){//We dragged the mouse while holding a button
  if(currentUI == _TILEMAPUI_){
    //if selecting a Tile Map do nothing
  }else{
  
  clickdrag = true;//we're dragging the mouse
  
  if(checkMouseOverIcon(false)){//if the mouse over an icon?
    return;//do nothing
  }
  
  if(mouseButton == RIGHT){//We clicked with the right button
    for(int x = screenX1; x < screenX2 + 1; x++){//loop through all columns
      for(int y = screenY1; y < screenY2 + 1; y++){//loop through rows
        if(x == mouseTileX && y == mouseTileY && mapTiles.get(x).get(y).size() != 0){//Are we clicking on the tile
          mTile tmp = mapTiles.get(x).get(y).get(0);//get the tile
          tmp.r = (int)RSlider.getValue();//set tile red value
          tmp.g = (int)GSlider.getValue();//set tile green value
          tmp.b = (int)BSlider.getValue();//set tile blue value
        }
      }
    }//Went through all the tiles
    return;
  }
  
  if(mouseButton == CENTER && deleting){//We dragging and deleting with the middle button
    for(int x = screenX1; x < screenX2 + 1; x++){//loop through all columns
      for(int y = screenY1; y < screenY2 + 1; y++){//loop through rows
        if(x == mouseTileX && y == mouseTileY){//Are we clicking on the tile
          mapTiles.get(x).get(y).clear();//delete all tiles in this space
        }
      }
    }//Went through all the tiles
    return;
  }

  if(dragging || noTile){//We're dragging or are not allowed to place tiles
    return;//Block normal action
  }
  
  for(int x = screenX1; x < screenX2 + 1; x++){//loop through all columns
    for(int y = screenY1; y < screenY2 + 1; y++){//loop through rows
      if(checkBounds(x, y)){
        if(x == mouseTileX && y == mouseTileY && mapTiles.get(x).get(y).size() != 0){//Are we clicking on the tile
          if(!checkImage(tileN) || mouseButton == CENTER || colorTiles){
            return;//Block normal action
          }
        }
      }
    }
  }

  placeTile();//Place a tile at current mouse position
  }
}//void mouseDragged() END

//---------------------------------------------------------------------------------------------------------------------------------------

void mouseReleased(){//We released the mouse button
  if(currentUI == _TILEMAPUI_){
    //if selecting a Tile Map do nothing
  }else{
  
    clickdrag = false;//we're no longer dragging the mouse
  
    if(dragging){//Are we dragging a tile
      if(tmpTile != null){//If tile exists
        if(mouseY < UIBottom * scl){//Did we just drop a tile on the ui
          tmpTile = null;//we are no longer dragging a tile
        }else{
          mapTiles.get(mouseTileX).get(mouseTileY).add(tmpTile);//place the dragged tile
          tmpTile = null;//we are no longer dragging a tile
        }
      }
    }
  
    deleting = false;//Quit deleting
    dragging = false;//Quit dragging
    if(!colorWheel.isVisible() && !colorInputR.isVisible()){//if not using color wheel or color inputs
      noTile = false;//Allow tile placement
    }
  }
}//void mouseReleased() END

//---------------------------------------------------------------------------------------------------------------------------------------

void mouseWheel(MouseEvent event){//We Scrolled The Mouse Wheel
  if(event.getCount() < 0){//If Scrolling Up
    if(scrollRows){//holding Control
      nextRowC();//Move To Next Row
    }else{
      nextTileC();//Move To Next Tile
    }
  }else{
    if(scrollRows){//holding Control
      prevRowC();//Move To Previous Row
    }else{
      prevTileC();//Move To Previous Tile
    }
  }
}//void mouseWheel(event) END