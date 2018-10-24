boolean dragging = false;// Is a tile being dragged?
boolean deleting = false;//Are we deleting tiles?
boolean noTile = false;//Are we blocking placement of tiles?

int offsetX = 0, offsetY = 0;//Mouseclick offset

int SX = 0, SY = 0;//Screen XY
int mX = 0, mY = 0;//Mouse XY
int fV = 1;//Fudge Value



void mousePressed(){//We pressed a mouse button
  if(preloading == true || UISetup == false){}else{//if preloading or UI not setup do nothing
  //updateXY();
  
  if(mouseX > scl * 5 && mouseY > scl * 5 && mouseX < scl * 5 + scl && mouseY < scl * 5 + scl){
    fileName = "maps/map3.csv";
    FileLoadMap();
    return;
  }
  
  /*if(checkOffset()){
    return;
  }*/
  
  if(noTile){
    return;
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
      for(int i = mapTiles.length-1; i >= 0; i--){//Loop through all tiles
        if(isCursorOnTile(i)){//Are we clicking on the tile
          tileGroupDeleting = true;//deleting group of tiles
          //break;
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
      for(int i = 0; i <= mapTiles.length-1; i++){//Loop through all tiles
        if(isCursorOnTile(i)){//Are we clicking on the tile
          mapTiles[i].r = (int)RSlider.getValue();//set tile red value
          mapTiles[i].g = (int)GSlider.getValue();//set tile green value
          mapTiles[i].b = (int)BSlider.getValue();//set tile blue value
        }
      }//Went through all the tiles
    }
    return;//Block normal action
  }

  for(int i = 0; i < rowLength; i++){//Go through all the tiles in the row
    if(mX > scl*i - SX + fV && mX < scl*(i+1) - SX - fV && mY > 0 - SY + fV && mY < scl - SY - fV){//Are we clicking on the tile UI
      noTile = true;//Dont allow tile placement
      if(img[rowLength*tileRow+i] == null){return;}//if image doesn't exist return
      tileN = rowLength*tileRow+i;//Set the tile cursor to the tile we clicked on
      mapTiles = (mTile[]) expand(mapTiles, mapTiles.length + 1);
      mapTiles[mapTiles.length - 1] = new mTile(scl*i + SX - SX,0 + SY - SY,tileN,(int)RSlider.getValue(),(int)GSlider.getValue(),(int)BSlider.getValue(), CClear);//Create a tile
    }
  }//Went through all the tiles in the row
  
  if(mX > 0 - SX && mX < scl*UIRight - SX && mY > 0 /* scl */ - SY && mY < scl*UIBottom - SY){//Did we click on the UI
    noTile = true;//Dont allow tile placement
    //return;//Don't do anything else
  }

  // Did I click on the rectangle?
  for(int i = mapTiles.length-1; i >= 0; i--){//Go through all the tiles
    if(isCursorOnTile(i)){//Are we clicking on the tile
      if(mouseButton == CENTER){//We clicked with the middle button
        deleteTile(i);//Delete a tile and update the array
        mapN = -1;//We're not holding a tile
        deleting = true;//We're deleting
        return;//Block normal action
      }else if(mouseButton == LEFT && !CClear){//We clicked with the left button
        mapN = i;//Keep track of what tile we clicked on
        dragging = true;//We dragging
        updateOffset(i);//Update the mouse offset of the tile
        loadColors(i);//Load the color inputs and sliders with the color from the tile
        return;//Block normal action
      }/*else if(mouseButton == RIGHT){//We clicked with the right button
        mylog.log("Right");
        //loadTile(i);
        //updateTileRow();//Get the row to whatever tile were on
        //return false;
      }*/
    }
  }//Went through all the tiles
  
  placeTile();//Place a tile at current mouse position
  }
}//void mousePressed() END

//---------------------------------------------------------------------------------------------------------------------------------------

void mouseDragged(){//We dragged the mouse while holding a button
  if(preloading == true || UISetup == false){}else{//if preloading or UI not setup do nothing
  //updateXY();
  
  if(mouseX > scl * 5 - 5 && mouseY > scl * 5 - 5 && mouseX < scl * 5 + scl + 5 && mouseY < scl * 5 + scl + 5){
    //fileName = "E:/Programming/DragNDraw_Java/map3.csv";
    //FileLoadMap();
    return;
  }
  
  /*if(checkOffset()){
    return;
  }*/
  
  if(mouseButton == RIGHT){//We clicked with the right button
    for(int i = 0; i <= mapTiles.length-1; i++){//loop through all the tiles
      if(isCursorOnTile(i)){//Are we clicking on the tile
        mapTiles[i].r = (int)RSlider.getValue();//set tile red value
        mapTiles[i].g = (int)GSlider.getValue();//set tile green value
        mapTiles[i].b = (int)BSlider.getValue();//set tile blue value
      }
    }//Went through all the tiles
  }
  
  if(mouseButton == CENTER && deleting){//We dragging and deleting with the middle button
    for(int i = mapTiles.length-1; i >= 0; i--){//Go through all the tiles
      if(isCursorOnTile(i)){//Are we clicking on the tile
        deleteTile(i);//Delete a tile and update the array
        mapN = -1;//We're not holding a tile
      }
    }//Went through all the tiles
  }

  if(noTile){//We're not allowed to place tiles
    return;//Don't do anything else
  }

  if(dragging){//We're dragging
    return;//Block normal action
  }
  
  for(int i = mapTiles.length-1; i >= 0; i--){//Go through all the tiles
    /*Pad*/if(isCursorOnTile(i) && !checkImage(tileN)){//Are we clicking on the tile
      return;//Block normal action
    }else if(isCursorOnTile(i) && mouseButton == CENTER){//Are we clicking on the tile with the middle button
      return;//Block normal action
    }else if(isCursorOnTile(i) && !CClear){//Are we clicking on a clear tile
      return;//Block normal action
    }
  }//Went through all the tiles

  placeTile();//Place a tile at current mouse position
  
  //return false;
  }
}//void mouseDragged() END

//---------------------------------------------------------------------------------------------------------------------------------------

void mouseReleased(){//We released the mouse button
  if(preloading == true || UISetup == false){}else{//if preloading or UI not setup do nothing
  if(dragging){//Are we dragging a tile
    if(mapTiles[mapN] != null){//If tile exists
      snapTileLocation(mapN);//Snap XY location of tile to grid
    }
  }
  
  deleting = false;//Quit deleting
  dragging = false;//Quit dragging
  if(!colorWheel.isVisible() && !colorInputR.isVisible()){//if not using color wheel or color inputs
    noTile = false;//Allow tile placement
  }

  if(mapN != -1 && mapTiles.length > mapN){//If tile exists
    if(mapTiles[mapN].x >= SX && mapTiles[mapN].x < scl*rowLength + SX && mapTiles[mapN].y == SY){//Is the tile we just dropped on the UI
      deleteTile(mapN);//Delete a tile and update the array
      //return false;
    }
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