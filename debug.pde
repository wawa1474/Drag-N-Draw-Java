final int _DEBUG_ = -1;//what are we debugging
final int _DEBUGAMOUNT_ = 5000000;//5000000;//how many are we debugging

void debug(){
  if(_DEBUG_ == 0){
    for(int i = 0; i < _DEBUGAMOUNT_; i++){
      //mapTiles.get((int)random(256)).get((int)random(256)).add(new mTile((int)random(tileMaps.get(tileMapShow).numImages),(int)random(256),(int)random(256),(int)random(256), (int)random(2)==1));//(int)random(256)
      //mapTiles.get((int)random(cols)).get((int)random(rows)).add(new mTile((int)random(tileMaps.get(tileMapShow).numImages),(int)random(256),(int)random(256),(int)random(256), (int)random(2)==1));//(int)random(256)
    }
  }
  
  if(_DEBUG_ == 1){
    icons.add(new clickableIcon(scl * 13, scl * 13, "maps/map10.ddj", "TEST"));
    icons.add(new clickableIcon(scl * 15, scl * 13, "maps/map10-1.ddj", "TEST2"));
    icons.add(new clickableIcon(scl * 17, scl * 13, "maps/map10-2.ddj", "TEST3"));
    icons.add(new clickableIcon(scl * 19, scl * 13, "maps/map10-3.ddj", "TEST4"));
    icons.add(new clickableIcon(scl * 13, scl * 15, scl * 7, scl, "maps/map10-3.ddj", "TEST4"));
  }
}

//color RED = new color(255,0,0);

void drawColorGradient(){
  for(float i = 0; i <= 1; i+=0.01){
    if(i < 0.16){
      fill(lerpColor(RED, YELLOW, map(i, 0.0, 0.16, 0.0, 1.0)));
    }else if(i >= 0.16 && i < 0.32){
      fill(lerpColor(YELLOW, GREEN, map(i, 0.16, 0.32, 0.0, 1.0)));
    }else if(i >= 0.32 && i < 0.48){
      fill(lerpColor(GREEN, CYAN, map(i, 0.32, 0.48, 0.0, 1.0)));
    }else if(i >= 0.48 && i < 0.64){
      fill(lerpColor(CYAN, BLUE, map(i, 0.48, 0.64, 0.0, 1.0)));
    }else if(i >= 0.64 && i < 0.8){
      fill(lerpColor(BLUE, MAGENTA, map(i, 0.64, 0.8, 0.0, 1.0)));
    }else{
      fill(lerpColor(MAGENTA, RED, map(i, 0.8, 1.0, 0.0, 1.0)));
    }
    noStroke();
    rect(200 + (i*100), 200, 1, 20);
  }
}