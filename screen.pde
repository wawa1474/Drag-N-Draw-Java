int[][][] spots;// = new int[256][256];//y, x

//ArrayList<ArrayList<ArrayList<mTile>>> test = new ArrayList<ArrayList<ArrayList<mTile>>>(0);
//ArrayList<ArrayList<mTile>> test = new ArrayList<ArrayList<mTile>>(256);

void drawSpots(){
  //Display Map Tiles
  //for(int i = 0; i < mapTiles.size(); i++){//Go through all the tiles
  //  if(mapTiles.get(i).tileOnScreen() || drawAll == true){//if tile is within screen bounds or drawAll is set
  //    mapTiles.get(i).draw();//Draw the tile
  //    drawnTiles++;//how many tiles are being drawn?
  //  }
  //}
  for(int y = 0; y < 256; y++){//loop through all y positions
    for(int x = 0; x < 256; x++){//loop through all x positions
      //boolean skip = false;
      //mapTiles.get(x).get(y).size() - 1
      for(int z = 15; z >= 0; z--){//loop through all drawn tiles in this xy position
        if(mapTiles.get(x).get(y).size() != 0){//if there's a tile to be drawn
          if(mapTiles.get(x).get(y).get(z).tileOnScreen(x * scl, y * scl) || drawAll == true){//if tile is within screen bounds or drawAll is set
            mapTiles.get(x).get(y).get(z).draw(x * scl, y * scl);//draw it
            drawnTiles++;//how many tiles are being drawn?
          }
        }
      }
    }
  }
}

//void setSpots(){
//  //for(int i = 0; i < mapTiles.size(); i++){//Go through all the tiles
//  for(int i = mapTiles.size() - 1; i >= 0; i--){//Go through all the tiles
//    mTile tmp = mapTiles.get(i);//
//    boolean skip = false;
//    for(int z = 0; z < 16 && skip != true; z++){
//      if(spots[tmp.y / scl][tmp.x / scl][z] == -1){
//        spots[tmp.y / scl][tmp.x / scl][z] = i;
//        skip = true;
//      }
//    }
//  }
//}

//void resetSpots(){
//  spots = new int[256][256][16];//y, x
//  for(int y = 0; y < 256; y++){
//    for(int x = 0; x < 256; x++){
//      for(int z = 0; z < 16; z++){
//        spots[y][x][z] = -1;
//      }
//    }
//  }
//}