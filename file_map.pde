ArrayList<Byte> mapFile = new ArrayList<Byte>(0);//temporary byte array

PImage missingTexture;//missingTexture Image

String fileName = "Error";//File Name
int tileMapShow = 0;//display which tile map
String loadedTileMapName = "Classic";//tile map name

boolean loadingMap = true;//are we loading a map

//class palette{
//  color colors[];
//  byte rgb[];
  
//  public palette(int amount){
//    this.colors = new color[amount];
//  }
  
//  void savePalette(){
//    this.rgb = new byte[this.colors.length * 3];
    
//    for(int i = 0; i < this.rgb.length; i += 3){
//      rgb[i] = (byte)red(colors[i / 3]);
//      rgb[i + 1] = (byte)green(colors[i / 3]);
//      rgb[i + 2] = (byte)blue(colors[i / 3]);
//    }
//  }
  
//  void clearRGB(){
//    this.rgb = new byte[0];
//  }
//}

void FileSaveCanvasSelect(File selection_){//map canvas save select callback
  if (selection_ == null) {//we didn't select a file
    println("Window was closed or the user hit cancel.");
  } else {//we selected a file
    //println("User selected " + selection.getAbsolutePath() + " for saving");
    fileName = selection_.getAbsolutePath();//get the path to the file
    if(split(fileName, '.').length > 1){//does the file have an extension
      //Already has file type
    }else{
      fileName = join(new String[] {fileName, "png"}, '.');//make sure the filename ends with .png
    }
    FileSaveCanvas();//save the canvas
  }
}//void FileSaveCanvasSelect(File selection) END

//---------------------------------------------------------------------------------------------------------------------------------------

void fileSaveMapSelect(File selection_){//map file save select callback
  if (selection_ == null) {//we didn't select a file
    println("Window was closed or the user hit cancel.");
  } else {//we selected a file
    //println("User selected " + selection.getAbsolutePath() + " for saving");
    fileName = selection_.getAbsolutePath();//get the path to the file
    if(split(fileName, '.').length > 1){//does the file have an extension
      //Already has file type
    }else{
      fileName = join(new String[] {fileName, "ddj"}, '.');//make sure the filename ends with .ddj
    }
    fileSaveMap();//save the map
  }
}//void fileSaveLoadSelect(File selection) END

//---------------------------------------------------------------------------------------------------------------------------------------

void FileLoadMapSelect(File selection_){//map file load select callback
  if (selection_ == null) {//we didn't select a file
    println("Window was closed or the user hit cancel.");
    loadingMap = false;//since user canceled loading a map we're no longer loading a map
  } else {//we selected a file
    //println("User selected " + selection.getAbsolutePath() + " for loading");
    fileName = selection_.getAbsolutePath();//get the path to the file
    FileLoadMap();//load the map
  }
}//void FileLoadMapSelect(File selection) END

//---------------------------------------------------------------------------------------------------------------------------------------

void FileSaveCanvas(){//Save the Canvas to a file
  resetLHXY();//reset the lower/higher xy for background drawing
  
  PGraphics fullCanvas = createGraphics(upperx - lowerx + scl + 1, uppery - lowery + scl + 1);//make the canvas slightly larger than needed
  fullCanvas.beginDraw();//start drawing the canvas
  fullCanvas.background(255);//make the background white
  
  if(drawLines){//if the tile xy is not reset and we're should draw lines
    for(int x = 0; x < cols; x++){//for however many horizontal squares there are
      fullCanvas.line(x * scl,0, x * scl, (rows + 1) * scl);//draw lines
    }
    for(int y = 0; y < rows; y++){//for however many vertical squares there are
      fullCanvas.line(0, y * scl, (cols + 1) * scl, y * scl);//draw lines
    }
  }
  
  //Display Map Tiles
  for(int x = 0; x < cols; x++){//for all the columns
    for(int y = 0; y < rows; y++){//for all the rows
      for(int z = 0; z < mapTiles.get(x).get(y).size(); z++){//for all the tiles in that space
        if(mapTiles.get(x).get(y).get(z).colored){//Is the tile colored
          fullCanvas.fill(mapTiles.get(x).get(y).get(z).tileColor);//Set Tile background color
          fullCanvas.rect((x * scl) - lowerx,(y * scl) - lowery,scl,scl);//Draw colored square behind tile
        }
        fullCanvas.image(tileImages[mapTiles.get(x).get(y).get(z).image], (x * scl) - lowerx, (y * scl) - lowery);//Draw tile
      }
    }
  }//Went through all the tiles
  fullCanvas.endDraw();//stop drawing the canvas
  fullCanvas.save(fileName);// + ".png");//Save the map to a PNG file
}//void FileSaveCanvas() END

//---------------------------------------------------------------------------------------------------------------------------------------

void padMapFileArray(){//pad the array to a 16 byte boundary
  int padding = (16 - floor(mapFile.size() % 16)) % 16;//is the size not on a boundary?
  for(int l = 0; l < padding; l++){//add the neccessary number of bytes
    mapFile.add((byte)0xA5);//add a byte
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------

void fileSaveMap(){//Save the Map to file
  //if(loadingTileMap == true){
  //  loadTileMap();//load selected tile map
  //  tileN = 1;//make sure were on tile 1
  //  updateTileRow();//make sure we're on the correct row
  //  noTile = false;//allowed to place tiles
  //  loadingTileMap = false;//no longer loading map
  //  preloading = false;//no longer preloading
  //  changeVisibility(false);//go to normal display
  //  return;
  //}
  
  if(fileName.equals("Error")){//if no file was selected
    return;//don't do anything
  }
  
  mapFile.clear();//clear the temporary array
  
  int mapFlags = 0;//temporary variable
  
  //Do we compress clickable icon text?
  String[] clickLoc = new String[0];//Array of clickable icon file locations
  String[] hoveText = new String[0];//Array of clickable icon hover texts
  
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////FILE METADATA
  //File Version
  mapFile.add((byte)(_FILEVERSION_MAP_ >> 8));//upper byte
  mapFile.add((byte)_FILEVERSION_MAP_);//lower byte
  
  //dummy header length bytes
  mapFile.add((byte)0x00);//02
  mapFile.add((byte)0x00);//03
  
  //map file width and height
  mapFile.add((byte)(cols >> 8));
  mapFile.add((byte)(cols));
  mapFile.add((byte)(rows >> 8));
  mapFile.add((byte)(rows));
  
  //background color
  mapFile.add((byte)backgroundRed);//14
  mapFile.add((byte)backgroundGreen);//15
  mapFile.add((byte)backgroundBlue);//16
  
  //Map Tiles Amount
  int tmp = 0;//temporary variable
  for(int x = 0; x < mapTiles.size(); x++){//go through all columns
    for(int y = 0; y < mapTiles.get(x).size(); y++){//go through all rows
      tmp += mapTiles.get(x).get(y).size();//count the number of tiles
    }
  }
  mapFile.add((byte)(tmp >> 24));//06
  mapFile.add((byte)(tmp >> 16));//07
  mapFile.add((byte)(tmp >> 8));//08
  mapFile.add((byte)tmp);//09
  
  //Clickable Icons Amount
  mapFile.add((byte)(icons.size() >> 24));//10
  mapFile.add((byte)(icons.size() >> 16));//11
  mapFile.add((byte)(icons.size() >> 8));//12
  mapFile.add((byte)icons.size());//13
  
  //Tile Map Name
  for(int i = 0; i < loadedTileMapName.length(); i++){
    mapFile.add((byte)loadedTileMapName.charAt(i));//??
  }
  mapFile.add((byte)0);//null terminated
  
  //Tile Map Location
  for(int i = 0; i < tileMaps.get(tileMapShow).tileMapLocation.length(); i++){
    mapFile.add((byte)tileMaps.get(tileMapShow).tileMapLocation.charAt(i));//??
  }
  mapFile.add((byte)0);//null terminated
  
  padMapFileArray();//pad to a 16 byte boundary
  
  mapFile.set(2, (byte)(mapFile.size() >> 8));//Header Length
  mapFile.set(3, (byte)mapFile.size());//Header Length
  
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////FILE METADATA
  
  if(_FILEVERSION_MAP_ == 5){//whats the file version
    //Map Tiles
    for(int x = 0; x < mapTiles.size(); x++){//loop through all columns
      for(int y = 0; y < mapTiles.get(x).size(); y++){//loop through all rows
        for(int z = 0; z < mapTiles.get(x).get(y).size(); z++){//loop through all tiles in that space
          //XY
          mapFile.add((byte)(x));
          mapFile.add((byte)(y));
      
          //Image Number
          mapFile.add((byte)(mapTiles.get(x).get(y).get(z).image >> 8));//upper byte
          mapFile.add((byte)mapTiles.get(x).get(y).get(z).image);//lower byte
      
          //Red/Green
          mapFile.add((byte)mapTiles.get(x).get(y).get(z).getRed());//red
          mapFile.add((byte)mapTiles.get(x).get(y).get(z).getGreen());//green
      
          //Blue/Flags
          mapFile.add((byte)mapTiles.get(x).get(y).get(z).getBlue());//blue
          if(mapTiles.get(x).get(y).get(z).colored){//is the tile colored
            mapFlags |= 1;//yes
          }
          mapFile.add((byte)mapFlags);//flags
        }
      }
    }
    
    padMapFileArray();//pad to a 16 byte boundary
    
    //Clickable Icons
    for(int i = 0; i < icons.size(); i++){//loop through all icons
    
      //XY
      mapFile.add((byte)(icons.get(i).x / scl));
      mapFile.add((byte)(icons.get(i).y / scl));
      
      //clickable tile file name
      for(int j = 0; j < icons.get(i).file.length(); j++){
        mapFile.add((byte)icons.get(i).file.charAt(j));//Add the file name
      }
      mapFile.add((byte)0);//null terminated
      
      //clickable tile hover text
      for(int k = 0; k < icons.get(i).hoverText.length(); k++){
        mapFile.add((byte)icons.get(i).hoverText.charAt(k));//Add the hover text
      }
      mapFile.add((byte)0);//null terminated
      
      padMapFileArray();//pad to a 16 byte boundary
      
    }
  }else{
    println("File Version Error (Saving).");//throw error
  }
  
  for(int l = 0; l < _PROGRAMVERSION_FILE_.length; l++){
    mapFile.add(_PROGRAMVERSION_FILE_[l]);//add the program version
  }
  
  for(int l = 0; l < _magicText.length(); l++){
    mapFile.add((byte)_magicText.charAt(l));//add the 'Magic Text'
  }
  
  byte[] tmpFile = new byte[mapFile.size()];//temporary variable
  for(int i = 0; i < mapFile.size(); i++){
    tmpFile[i] = mapFile.get(i);//convert from ArrayList to normal Array
  }
  saveBytes(fileName, tmpFile);//save the file
  
  mapFile.clear();//clear up memory
  
  //fileName = "Error";//reset so we can know if an error occurs
}//void fileSaveLoad() END

//---------------------------------------------------------------------------------------------------------------------------------------

int convertFourBytesToInt(byte a_, byte b_, byte c_, byte d_){//convert from four bytes to an integer
  int returnValue = 0;//start with zero
  
  returnValue = a_ & 0xFF;//set it to the most significant byte
  returnValue = returnValue << 8;//shift it 8 bits to the left
  returnValue |= b_ & 0xFF;//add the upper middle byte
  returnValue = returnValue << 8;//shift it 8 bits to the left
  returnValue |= c_ & 0xFF;//add the lower middle byte
  returnValue = returnValue << 8;//shift it 8 bits to the left
  returnValue |= d_ & 0xFF;//add the least significant byte
  
  return returnValue;//return the int
}

//---------------------------------------------------------------------------------------------------------------------------------------

void FileLoadMap(){//load map from file
  if(fileName.equals("Error")){//if there was an error
    return;//do nothing
  }

  noLoop();//dont allow drawing
  byte[] mapFile = loadBytes(fileName);//temporary array
  
  //String magic = "";
  ////println(mapFile.length);
  //for(int l = 0; l < _magicText.length(); l++){
  //  magic += (char)mapFile[(mapFile.length - _magicText.length()) + l];
  //}
  
  //if(!magic.equals(_magicText)){//is the file ours
  //  loadingMap = false;//since this file was not ours we're no longer loading a map
  //  loop();
  //  return;//file was not one of ours
  //}
  
  if(!checkMagic(subset(mapFile, mapFile.length - _magicText.length()))){
    loadingMap = false;//since this file was not ours we're no longer loading a map
    loop();
    return;//file was not one of ours
  }
  
  int fileVersion;//what file version is the file
  int headerLength;//how long is the header
  int mapWidth;//how many tiles wide is the map
  int mapHeight;//how many tiles tall is the map
  int mapTilesAmount;//how many tiles are there
  int iconsAmount;//how many icons are there
  String headerTileName = null;//what is the tile map name
  String headerTileLocation;//where is the tile map
  
  
  clearMapTilesArray();//get ready to load a new map
  clearClickableTilesArray();//get ready to load a new map
  
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////FILE METADATA
  //File Version
  fileVersion = int(mapFile[0] << 8);//upper byte
  fileVersion |= int(mapFile[1]);//lower byte
  
  headerLength = int(mapFile[2] << 8);//Header Length
  headerLength |= int(mapFile[3]);//Header Length
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////FILE METADATA
  
  if(fileVersion == 5){//whats the file version{//we don't know that file version
    //map width and height in tiles
    mapWidth = convertFourBytesToInt((byte)0, (byte)0, mapFile[4], mapFile[5]);
    mapHeight = convertFourBytesToInt((byte)0, (byte)0, mapFile[6], mapFile[7]);
    
    if(cols != mapWidth || rows != mapHeight){//make sure we have room for all the tiles
      cols = mapWidth;//update our width
      rows = mapHeight;//update our height
      clearMapTilesArray();//fix the map tiles array to reflect our new dimensions
    }
    
    //background color
    backgroundRed = int(mapFile[8]);
    backgroundGreen = int(mapFile[9]);
    backgroundBlue = int(mapFile[10]);
    
    //Map Tiles Amount
    mapTilesAmount = convertFourBytesToInt(mapFile[11], mapFile[12], mapFile[13], mapFile[14]);
    //println(mapTilesAmount + " Tiles Loaded");
  
    //Clickable Icons Amount
    iconsAmount = convertFourBytesToInt(mapFile[15], mapFile[16], mapFile[17], mapFile[18]);
  
    //Tile Map Name
    headerTileName = "";
    boolean more = true;
    int current = 0;
    while(more){
      char character = (char)mapFile[17 + current];
      if(character == 0){
        more = false;
      }else{
        headerTileName += str(character);//get the name
      }
      current++;
    }
    
    //tile map location
    headerTileLocation = "";
    int nameLength = current;
    more = true;
    current = 0;
    while(more){
      char character = (char)mapFile[17 + nameLength + current];
      if(character == 0){
        more = false;
      }else{
        headerTileLocation += str(character);//get the name
      }
      current++;
    }

    if(!loadedTileMapName.equals(headerTileName)){//if map names aren't equal
      //println("Changing Tile Map");
      boolean skip = false;
      for(int i = 0; i < tileMaps.size() && !skip; i++){
        if(tileMaps.get(i).tileMapName.equals(headerTileName)){
          tileMapShow = i;
          skip = true;
        }
      }
      loadTileMap();//load selected tile map
    }
    
    //Load Map Tiles
    for(int i = 0; i < mapTilesAmount; i++){//Loop through all the rows
      int tmp = (i * 8) + headerLength;
      
      boolean colored = ((mapFile[tmp + 7] & 0x01) == 1);//is tile colored
      
      int imageNumber = (mapFile[tmp + 2] << 8) & 0xFF;
      imageNumber |= (mapFile[tmp + 3]) & 0xFF;
      //.get(x).get(y).add(new mTile(tile number, red, green, blue, is tile clear?));
      mapTiles.get((mapFile[tmp] & 0xFF)).get((mapFile[tmp + 1] & 0xFF)).add(new mTile(imageNumber, color(int(mapFile[tmp + 4]), int(mapFile[tmp + 5]), int(mapFile[tmp + 6])), colored));
    }
    
    int mapTilesLength = (mapTilesAmount * 8) + ((16 - floor(mapTilesAmount * 8) % 16) % 16) + headerLength;
    
    //Load Clickable Tiles
    
    int iconsAddress = mapTilesLength;
    //println("Starting Icons Address: " + iconsAddress);
    
    for(int i = 0; i < iconsAmount; i++){//Loop through all the rows
    
      int clickFileAddress = iconsAddress + 2;
      
      //clickable tile file name
      String clickableFile = "";
      more = true;
      current = clickFileAddress;
      while(more){
        char character = (char)mapFile[current];
        if(character == 0){
          more = false;
        }else{
          clickableFile += str(character);//get the name
        }
        current++;
      }
    
      //clickable tile hover text
      String clickableHover = "";
      nameLength = current;
      more = true;
      while(more){
        char character = (char)mapFile[current];
        if(character == 0){
          more = false;
        }else{
          clickableHover += str(character);//get the name
        }
        current++;
      }
    
      //.add(new clickableIcon(x, y, tile image number, is tile clear?));
      icons.add(new clickableIcon((mapFile[iconsAddress] & 0xFF) * scl, (mapFile[iconsAddress + 1] & 0xFF) * scl, clickableFile, clickableHover));
      
      iconsAddress = current + (16 - ((current % 16) % 16));
      //println("Sequential Icons Address: " + iconsAddress);
    }
  }else{
    println("File Version Error (Loading).");//throw error
  }
  
  loop();//allow drawing
  loadingMap = false;//no longer loading a map
  
  fileName = "Error";
}//void FileLoadMap() END