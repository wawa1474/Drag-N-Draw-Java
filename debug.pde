final int _DEBUG_ = -1;//what are we debugging
final int _DEBUGAMOUNT_ = 5000000;//5000000;//how many are we debugging

void debug(){
  if(_DEBUG_ == 0){
    for(int i = 0; i < _DEBUGAMOUNT_; i++){
      //mapTiles.get((int)random(256)).get((int)random(256)).add(new mTile((int)random(tileMaps.get(tileMapShow).numImages),(int)random(256),(int)random(256),(int)random(256), (int)random(2)==1));//(int)random(256)
      mapTiles.get((int)random(cols)).get((int)random(rows)).add(new mTile((int)random(tileMaps.get(tileMapShow).numImages),(int)random(256),(int)random(256),(int)random(256), (int)random(2)==1));//(int)random(256)
    }
  }
  
  if(_DEBUG_ == 1){
    icons.add(new clickableIcon(scl * 13, scl * 13, "maps/map10.ddj", "TEST"));
    icons.add(new clickableIcon(scl * 15, scl * 13, "maps/map10-1.ddj", "TEST2"));
    icons.add(new clickableIcon(scl * 17, scl * 13, "maps/map10-2.ddj", "TEST3"));
    icons.add(new clickableIcon(scl * 19, scl * 13, "maps/map10-3.ddj", "TEST4"));
  }
}