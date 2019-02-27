int[][][] spots;// = new int[256][256];//y, x

void setSpots(){
  resetSpots();
  //for(int i = 0; i < mapTiles.size(); i++){//Go through all the tiles
  for(int i = mapTiles.size() - 1; i >= 0; i--){//Go through all the tiles
    mTile tmp = mapTiles.get(i);//
    boolean skip = false;
    for(int z = 0; z < 16 && skip != true; z++){
      if(spots[tmp.y / scl][tmp.x / scl][z] == -1){
        spots[tmp.y / scl][tmp.x / scl][z] = i;
        skip = true;
      }
    }
  }
}

void resetSpots(){
  spots = new int[256][256][16];//y, x
  for(int y = 0; y < 256; y++){
    for(int x = 0; x < 256; x++){
      for(int z = 0; z < 16; z++){
        spots[y][x][z] = -1;
      }
    }
  }
}