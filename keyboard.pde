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
        //CCheckBox.checked(false);//Uncheck the checkbox
        clearToggle.setColorLabel(color(0, 0, 0));//make text black
      }else{//Its not clear
        CClear = true;//Set it clear
        //CCheckBox.checked(true);//Check the checkbox
        clearToggle.setColorLabel(color(255, 255, 255));//make text white
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
      if(tileGroupStep != 3){
        tileGroupStep = 3;//paste step is 3
      }else if(tileGroupStep == 3){
        tileGroupStep = 0;//paste step is 3
      }
    //}else if(key == 'i'){//We pressed 'I'
    //  for(int i = mapTiles.length-1; i >= 0; i--){//Go through all the tiles
    //    mapTiles[i].y -= scl * scrollAmount;//Move tile up 1 space
    //  }
    //}else if(key == 'j'){//We pressed 'J'
    //  for(int i = mapTiles.length-1; i >= 0; i--){//Go through all the tiles
    //    mapTiles[i].x -= scl * scrollAmount;//Move tile left 1 space
    //  }
    //}else if(key == 'k'){//We pressed 'K'
    //  for(int i = mapTiles.length-1; i >= 0; i--){//Go through all the tiles
    //    mapTiles[i].y += scl * scrollAmount;//Move tile down 1 space
    //  }
    //}else if(key == 'l'){//We pressed 'L'
    //  for(int i = mapTiles.length-1; i >= 0; i--){//Go through all the tiles
    //    mapTiles[i].x += scl * scrollAmount;//Move tile right 1 space
    //  }
    }else if(key == 'r'){//We pressed 'R'
      //for(int i = mapTiles.length-1; i >= 0; i--){//Go through all the tiles
      for(int i = mapTiles.size() - 1; i >= 0; i--){//Go through all the tiles
        if(isCursorOnTile(i)){//Are we clicking on the tile
          mTile tmp = mapTiles.get(i);
          println("Tile #: " + i + ", X Position: " + tmp.x + ", Y Position: " + tmp.y + ", Red Amount: " + tmp.r + ", Green Amount: " + tmp.g + ", Blue Amount: " + tmp.b + ", Tile Image #: " + tmp.image + ", Is Tile Clear: " + tmp.clear);// + ", Tile Lore: " + mapTiles[i].lore);
        }
      }
    }else if(key == 'q'){//We pressed 'Q'
      //tileGroup(scl * 10, scl * 3, scl * 5, scl * 10)
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
      BG.r = (int)RSlider.getValue();
      BG.g = (int)GSlider.getValue();
      BG.b = (int)BSlider.getValue();
    }else if(key == 'o'){//We pressed 'O'
      drawLines = !drawLines;
    }
    
    if(key == 'w'){//We pressed 'W'
      //if(SY < scl * 5){//if we're not outside of the boundaries
      //  SY += (scl * scrollAmount);//Scroll Screen UP
      //}
      //if(SY > scl * 5){//we're outside of the boundaries
      //  SY = scl * 5;//get back inside of the boundaries
      //}
      SY += (scl * scrollAmount);
      
      if(SY > 64){
        SY = 64;
      }
    }
    if(key == 'a'){//We pressed 'A'
      //if(SX < scl * 5){//if we're not outside of the boundaries
      //  SX += (scl * scrollAmount);//Scroll Screen LEFT
      //}
      //if(SX > scl * 5){//we're outside of the boundaries
      //  SX = scl * 5;//get back inside of the boundaries
      //}
      SX += (scl * scrollAmount);
      
      if(SX > 0){
        SX = 0;
      }
    }
    if(key == 's'){//We pressed 'S'
      //if(SY > -((scl * 105) - height)){//if we're not outside of the boundaries
      //  SY -= (scl * scrollAmount);//Scroll Screen RIGHT
      //}
      //if(SY < -((scl * 105) - height)){//we're outside of the boundaries
      //  SY = -((scl * 105) - (floor(height / scl) * scl));//get back inside of the boundaries
      //}
      SY -= (scl * scrollAmount);
      
      if(SY < -((scl * 256) - height)){
        SY = -((scl * 256) - height);
      }
      //println(SY);
    }
    if(key == 'd'){//We pressed 'D'
      //if(SX > -((scl * 105) - width)){//if we're not outside of the boundaries
      //  SX -= (scl * scrollAmount);//Scroll Screen DOWN
      //}
      //if(SX < -((scl * 105) - width)){//we're outside of the boundaries
      //  SX = -((scl * 105) - (floor(width / scl) * scl));//get back inside of the boundaries
      //}
      SX -= (scl * scrollAmount);
      
      if(SX < -((scl * 256) - width)){
        SX = -((scl * 256) - width);
      }
    }
  }
}//void keyTyped() END