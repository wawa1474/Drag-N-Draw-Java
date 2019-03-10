boolean dragging = false;// Is a tile being dragged?
boolean deleting = false;//Are we deleting tiles?
boolean noTile = false;//Are we blocking placement of tiles?

//int offsetX = 0, offsetY = 0;//Mouseclick offset

int screenX = 0, screenY = 0;//Screen XY
int mouseTileX = 0, mouseTileY = 0;//Mouse XY
int fV = 1;//Fudge Value to make sure we're really clicking inside something



void mousePressed(){//We pressed a mouse button
  if(preloading == true || UISetup == false){}else{//if preloading or UI not setup do nothing
  
  checkMouseOverIcon(true);

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
      for(int x = 0; x < mapTiles.size(); x++){
        for(int y = 0; y < mapTiles.get(x).size(); y++){
          if(isCursorOnTile(x, y, mouseTileX, mouseTileY)){//Are we clicking on the tile
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
      for(int x = 0; x < mapTiles.size(); x++){//go through all columns
        for(int y = 0; y < mapTiles.get(x).size(); y++){//go through all rows
          if(isCursorOnTile(x, y, mouseTileX, mouseTileY)){//Are we clicking on the tile
            //mTile tmp = mapTiles.get(x).get(y).get(mapTiles.get(x).get(y).size() - 1);
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
    if(mouseTileX > i + screenX && mouseTileX < (i+1) + screenX && mouseTileY > 0 + screenY && mouseTileY < 1 + screenX){//Are we clicking on the tile UI
      noTile = true;//Dont allow tile placement
      if(img[rowLength*tileRow+i] == null){return;}//if image doesn't exist return
      tileN = rowLength*tileRow+i;//Set the tile cursor to the tile we clicked on
    }
  }//Went through all the tiles in the row

  if(mouseTileX > 0 + screenX && mouseTileX < UIRight + screenX && mouseTileY > 0 + screenY && mouseTileY < UIBottom + screenY){//Did we click on the UI
    noTile = true;//Dont allow tile placement
    return;//Don't do anything else
  }

  // Did I click on the rectangle?
  for(int x = 0; x < mapTiles.size(); x++){//go through all columns
    for(int y = 0; y < mapTiles.get(x).size(); y++){//go through all rows
      if(isCursorOnTile(x, y, mouseTileX, mouseTileY)){//Are we clicking on the tile
        if(mouseButton == CENTER){//We clicked with the middle button
          deleteTile(x, y);//Delete a tile and update the array
          deleting = true;//We're deleting
          resetLHXY();//reset the lower/higher xy for background drawing
          return;//Block normal action
        }else if(mouseButton == LEFT && !CClear){//We clicked with the left button
          tmpTile = mapTiles.get(x).get(y).get(mapTiles.get(x).get(y).size() - 1);//copy the tile
          mapTiles.get(x).get(y).remove(mapTiles.get(x).get(y).size() - 1);//delete the tile
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
  if(preloading == true || UISetup == false){}else{//if preloading or UI not setup do nothing
  
  clickdrag = true;//we're dragging the mouse
  
  checkMouseOverIcon(false);
  
  if(mouseButton == RIGHT){//We clicked with the right button
    for(int x = 0; x < mapTiles.size(); x++){//go through all columns
      for(int y = 0; y < mapTiles.get(x).size(); y++){//go through all rows
        if(isCursorOnTile(x, y, mouseTileX, mouseTileY)){//Are we clicking on the tile
          mTile tmp = mapTiles.get(x).get(y).get(0);//get the tile
          tmp.r = (int)RSlider.getValue();//set tile red value
          tmp.g = (int)GSlider.getValue();//set tile green value
          tmp.b = (int)BSlider.getValue();//set tile blue value
        }
      }
    }//Went through all the tiles
  }
  
  if(mouseButton == CENTER && deleting){//We dragging and deleting with the middle button
    for(int x = 0; x < mapTiles.size(); x++){//go through all columns
      for(int y = 0; y < mapTiles.get(x).size(); y++){//go through all rows
        if(isCursorOnTile(x, y, mouseTileX, mouseTileY)){//Are we clicking on the tile
          mapTiles.get(x).get(y).clear();//delete all tiles in this space
        }
      }
    }//Went through all the tiles
    resetLHXY();//reset the lower/higher xy for background drawing
  }

  if(noTile){//We're not allowed to place tiles
    return;//Don't do anything else
  }

  if(dragging){//We're dragging
    return;//Block normal action
  }
  
  for(int x = 0; x < mapTiles.size(); x++){//go through all columns
    for(int y = 0; y < mapTiles.get(x).size(); y++){//go through all rows
      /*Pad*/if(isCursorOnTile(x, y, mouseTileX, mouseTileY) && !checkImage(tileN)){//Are we clicking on the tile
        return;//Block normal action
      }else if(isCursorOnTile(x, y, mouseTileX, mouseTileY) && mouseButton == CENTER){//Are we clicking on the tile with the middle button
        return;//Block normal action
      }else if(isCursorOnTile(x, y, mouseTileX, mouseTileY) && !CClear){//Are we clicking on a clear tile
        return;//Block normal action
      }
    }
  }

  placeTile();//Place a tile at current mouse position
  }
}//void mouseDragged() END

//---------------------------------------------------------------------------------------------------------------------------------------

void mouseReleased(){//We released the mouse button
  if(preloading == true || UISetup == false){}else{//if preloading or UI not setup do nothing
  
  clickdrag = false;//we're no longer dragging the mouse
  //for(int i = 0; i < icons.length; i++){
  //  if(icons[i].wasClicked()){
  //    return;
  //  }
  //}
  
  if(dragging){//Are we dragging a tile
    if(tmpTile != null){//If tile exists
      if(mouseTileY < 0 + 2 + screenY){//Did we just drop a tile on the ui
        resetLHXY();//reset the lower/higher xy for background drawing
        tmpTile = null;//we are no longer dragging a tile
      }else{
        mapTiles.get(mouseTileX).get(mouseTileY).add(tmpTile);//place the dragged tile
        resetLHXY();//reset the lower/higher xy for background drawing
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
    if(keyCode == /*CTRL*/17){//holding Control
      nextRowC();//Move To Next Row
      keyCode = 0;
    }else{
      nextTileC();//Move To Next Tile
    }
  }else{
    if(keyCode == /*CTRL*/17){//holding Control
      prevRowC();//Move To Previous Row
      keyCode = 0;
    }else{
      prevTileC();//Move To Previous Tile
    }
  }
}//void mouseWheel(event) END