boolean dragging = false;// Is a tile being dragged?
boolean deleting = false;//Are we deleting tiles?
boolean noTile = false;//Are we blocking placement of tiles?

//int offsetX = 0, offsetY = 0;//Mouseclick offset

int SX = 0, SY = 64;//Screen XY
int mX = 0, mY = 0;//Mouse XY
int fV = 1;//Fudge Value



void mousePressed(){//We pressed a mouse button
  if(preloading == true || UISetup == false){}else{//if preloading or UI not setup do nothing
  //updateXY();
  
  for(int i = 0; i < icons.size(); i++){//go through all icons
    if(icons.get(i).wasClicked()){//if we clicked on one
      return;//do nothing
    }
  }
  
  /*if(checkOffset()){
    return;
  }*/
  //println("test12");
  if(noTile){//if we're not allowed to place tiles
    return;//do nothing
  }
  //println("test11");
  if(tileGroupStep == 3){//pasteing group of tiles
    if(mouseButton == LEFT){//We clicked with the left button
      tileGroupPaste();//paste group selection
      tileGroupStep = 0;//reset group selection step
      return;//Block normal action
    }
  }
  //println("test10");
  if(tileGroupStep == 2){//placing group of tiles
    if(mouseButton == LEFT){//We clicked with the left button
      tileGroup("left");//placing image tiles
      return;//Block normal action
    }else if(mouseButton == CENTER){//We clicked with the middle button
      for(int x = 0; x < mapTiles.size(); x++){
        for(int y = 0; y < mapTiles.get(x).size(); y++){
          if(isCursorOnTile(x, y)){//Are we clicking on the tile
            tileGroupDeleting = true;//deleting group of tiles
            //break;
          }
        }
      }//Went through all the tiles
      tileGroup("center");//placing colored tile
      return;//Block normal action
    }
  }
  //println("test9");
  if(mouseButton == RIGHT){//We clicked with the right button
    if(tileGroupStep == 2){//placing group of tiles
      tileGroup("right");//coloring group of tiles
    }else{//otherwise
      for(int x = 0; x < mapTiles.size(); x++){//go through all columns
        for(int y = 0; y < mapTiles.get(x).size(); y++){//go through all rows
          if(isCursorOnTile(x, y) && mapTiles.get(x).get(y).size() != 0){//Are we clicking on the tile
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
  //println("test8");
  for(int i = 0; i < rowLength; i++){//Go through all the tiles in the row
    if(mX > scl*i - SX + fV && mX < scl*(i+1) - SX - fV && mY > 0 - SY + fV && mY < scl - SY - fV){//Are we clicking on the tile UI
      noTile = true;//Dont allow tile placement
      if(img[rowLength*tileRow+i] == null){return;}//if image doesn't exist return
      tileN = rowLength*tileRow+i;//Set the tile cursor to the tile we clicked on
      //dmapTiles.get(i + SX - SX).get(0 + SY - SY).add(new mTile(tileN,(int)RSlider.getValue(),(int)GSlider.getValue(),(int)BSlider.getValue(), CClear));//Create a tile
    }
  }//Went through all the tiles in the row
  //println("test7");
  if(mX > 0 - SX && mX < scl*UIRight - SX && mY > 0 /* scl */ - SY && mY < scl*UIBottom - SY){//Did we click on the UI
    noTile = true;//Dont allow tile placement
    return;//Don't do anything else
  }
  //println("test6");
  // Did I click on the rectangle?
  //for(int i = mapTiles.length-1; i >= 0; i--){//Go through all the tiles
  for(int x = 0; x < mapTiles.size(); x++){//go through all columns
    for(int y = 0; y < mapTiles.get(x).size(); y++){//go through all rows
      if(isCursorOnTile(x, y)){//Are we clicking on the tile
        //println("test13 - " + x + ": " + y);
        if(mouseButton == CENTER){//We clicked with the middle button
          deleteTile(x, y);//Delete a tile and update the array
          mapN = -1;//We're not holding a tile
          deleting = true;//We're deleting
          resetLHXY();//reset the lower/higher xy for background drawing
          return;//Block normal action
        }else if(mouseButton == LEFT && !CClear){//We clicked with the left button
          //mapN = x;//Keep track of what tile we clicked on
          tmpTile = mapTiles.get(x).get(y).get(mapTiles.get(x).get(y).size() - 1);//copy the tile
          mapTiles.get(x).get(y).remove(mapTiles.get(x).get(y).size() - 1);//delete the tile
          dragging = true;//We dragging
          //updateOffset();//Update the mouse offset of the tile
          loadColors(tmpTile);//Load the color inputs and sliders with the color from the tile
          loadTile(tmpTile);//load tile image
          return;//Block normal action
        }/*else if(mouseButton == RIGHT){//We clicked with the right button
          mylog.log("Right");
          //loadTile(i);
          //updateTileRow();//Get the row to whatever tile were on
          //return false;
        }*/
      }
    }
  }//Went through all the tiles
  //resetLHXY();//reset the lower/higher xy for background drawing
  //println("test5");
  placeTile();//Place a tile at current mouse position
  }
}//void mousePressed() END

//---------------------------------------------------------------------------------------------------------------------------------------

void mouseDragged(){//We dragged the mouse while holding a button
  if(preloading == true || UISetup == false){}else{//if preloading or UI not setup do nothing
  //updateXY();
  
  clickdrag = true;//we're dragging the mouse
  
  for(int i = 0; i < icons.size(); i++){//go through all icons
    if(icons.get(i).wasClicked()){//if we clicked on one
      return;//return and do nothing
    }
  }
  
  /*if(checkOffset()){
    return;
  }*/
  
  if(mouseButton == RIGHT){//We clicked with the right button
    for(int x = 0; x < mapTiles.size(); x++){//go through all columns
      for(int y = 0; y < mapTiles.get(x).size(); y++){//go through all rows
        if(isCursorOnTile(x, y) && mapTiles.get(x).get(y).size() != 0){//Are we clicking on the tile
          //mTile tmp = mapTiles.get(x).get(y).get(mapTiles.get(x).get(y).size() - 1);
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
        if(isCursorOnTile(x, y)){//Are we clicking on the tile
          mapTiles.get(x).get(y).clear();//delete all tiles in this space
          mapN = -1;//We're not holding a tile
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
      /*Pad*/if(isCursorOnTile(x, y) && !checkImage(tileN)){//Are we clicking on the tile
        return;//Block normal action
      }else if(isCursorOnTile(x, y) && mouseButton == CENTER){//Are we clicking on the tile with the middle button
        return;//Block normal action
      }else if(isCursorOnTile(x, y) && !CClear){//Are we clicking on a clear tile
        return;//Block normal action
      }
    }
  }

  placeTile();//Place a tile at current mouse position
  
  //return false;
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
      if(mX >= 0 - SX && mX < width - SX && mY < (0 + (scl*2)) - SY){//Did we just drop a tile on the ui
        resetLHXY();//reset the lower/higher xy for background drawing
        tmpTile = null;//we are no longer dragging a tile
      }else{
        mapTiles.get(floor(mX/scl)).get(floor(mY/scl)).add(tmpTile);//place the dragged tile
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