int _FILEVERSION_ = 4;//what version of file saving and loading

//File Version Map
  //Version 0:
    //0 = File MetaData
    //Compressed Color/Position Tile Data
  
  //Version 1:
    //0 = File MetaData
    //No Compression
  
  //Version 2:
    //0 = File MetaData
    //Compressed Position
  
  //Version 4:
    //0 = File MetaData
    //Compressed Everything

PImage[] img = new PImage[0];//Tile Images Array
PImage BACKGROUND;//background image
PImage missingTexture;//missingTexture Image

//Table mapTable;//Map Table
String fileName = "Error";//File Name

Table tileInfoTable;//tile map info table
PImage[] tileMaps = new PImage[0];//tile maps images
boolean preloading = true;//are we preloading
boolean prepreloading = true;//are we prepreloading
int tileMapShow = 0;//display which tile map
String tileMapLocation = "assets/tileMap.png";//wheres the tilemap located
boolean loadMapLocaion = false;//load tile map location
int tileMapHeight = 32;//how tiles high
int tileMapWidth = 32;//how many tile wide
int tileMapTileX = 32;//tile width
int tileMapTileY = 32;//tile height
int colorTile = 0;//Which tile is the clear colored tile
String tileMapName = "Classic";//tile map name
boolean loadingTileMap = true;//are we loading the tile map



void preload(){//Preload all of the images
  //FileLoadTileInfo();
  PImage tileMap = loadImage(tileMapLocation);//load the tile map image
  tileMap.loadPixels();//load the images pixels
  
  for(int i = 0; i < img.length; i++){//delete all the images
    img = (PImage[]) shorten(img);//Shorten the Tile Images Array by 1
  }
  
  for(int i = 0; i <= totalImages; i++){//Go through all the images
    img = (PImage[]) expand(img, img.length + 1);//make sure we have room
    img[i] = createImage(32, 32, ARGB);//create a new image
    img[i].loadPixels();//load the images pixels
    for(int y = 0; y < 32; y++){//for tile height
      for(int x = 0; x < 32; x++){//for tile width
        img[i].set(x, y, tileMap.get(x + (scl * floor(i % tileMapWidth)), y + (scl * floor(i / tileMapHeight))));//set pixel
      }
    }
    img[i].updatePixels();//update the image pixels
  }
  
  missingTexture = loadImage("assets/missingTexture.png");//load missing texture image
  
  println(totalImages + ": " + fullTotalImages);
  if(totalImages != fullTotalImages){//is there empty sapce
    for(int i = totalImages + 1; i <= fullTotalImages; i++){//fill the empty space
      img = (PImage[]) expand(img, img.length + 1);//make sure we have room
      img[i] = missingTexture;//make the empty spaces be missing textures
    }
  }
  
  BACKGROUND = loadImage("assets/background.png");//load background image
}//void preload() END

//---------------------------------------------------------------------------------------------------------------------------------------

void FileLoadTileMapInfo(){//load map from file
  tileInfoTable = loadTable("assets/tileMapInfo.csv", "header, csv");// + ".csv", "header");//Load the csv
  
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////FILE METADATA
  int fileVersion = int(tileInfoTable.getInt(0,"location"));//File Version
  //int(mapTable.get(0,'y'));//blank
  //int(mapTable.get(0,'image'));//blank
  //int(mapTable.get(0,'r'));//blank
  //int(mapTable.get(0,'g'));//blank
  //int(mapTable.get(0,'b'));//blank
  //int(mapTable.get(0,'clear'));//blank
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////FILE METADATA
  
  if(fileVersion == 0){//whats the file version
    for(int i = 1; i < tileInfoTable.getRowCount(); i++){//Loop through all the rows
      tileMaps = (PImage[]) expand(tileMaps, tileMaps.length + 1);//make sure we have room
      tileMaps[tileMaps.length - 1] = loadImage(tileInfoTable.getString(i,"location"));//load tile map image
      println(tileInfoTable.getString(i,"location") + ", " +//Tile X position
                              tileInfoTable.getInt(i,"tileMapHeight") + ", " +//Tile Y position
                              tileInfoTable.getInt(i,"tileMapWidth") + ", " +//Tile Image
                              tileInfoTable.getInt(i,"tileMapTileX") + ", " +//Tile Red amount
                              tileInfoTable.getInt(i,"tileMapTileY") + ", " +//Tile Red amount
                              tileInfoTable.getInt(i,"images") + ", " +//Tile Red amount
                              tileInfoTable.getInt(i,"colortile"),//Is Tile Clear
                              tileInfoTable.getString(i,"name"));//,//Is Tile Clear
      if(tileMapName.equals(tileInfoTable.getString(i,"name"))){//does the map name and tile map name match
        tileMapLocation = tileInfoTable.getString(i,"location");//update tile map location
        tileMapHeight = tileInfoTable.getInt(i,"tileMapHeight");//how tiles high
        tileMapWidth = tileInfoTable.getInt(i,"tileMapWidth");//how many tile wide
        //tileMapTileX = 32;//tile width
        //tileMapTileY = 32;//tile height
        colorTile = tileInfoTable.getInt(i,"colortile");//Is Tile Clear
        totalImages = tileInfoTable.getInt(i,"images") - 1;//Total Images
        fullTotalImages = ceil((float)(totalImages + 1) / rowLength) * rowLength - 1;//make sure all tile rows are full
        tileN = 1;//make sure were on tile 1
        updateTileRow();//make sure we're on the correct row
      }
    }
  }else{//we don't know that file version
    println("File Version Error (Loading).");//throw error
  }
  //image(tileMaps[1],0,0);
}//FileLoadTileInfo() END

//---------------------------------------------------------------------------------------------------------------------------------------

void loadMap(){//called when loadMap is pressed
  if(loadingTileMap == true){//if loading tile map
    noLoop();//don't allow drawing
    loadMapLocaion = true;//make sure to update the map location
    selectInput("Select a CSV to read from:", "FileLoadMapSelect");//load a map
    println("File Selected!");
    while(prepreloading == true){delay(500);}//small delay
    println("File Loaded");
    FileLoadTileMapInfo();//load tile map info file
    preload();//preload stuff
    tileN = 1;//make sure we're on the first tile
    updateTileRow();//make sure we're on the correct row
    noTile = false;//allowed to place tiles
    changeVisibility(false);//normal screen
    loadingTileMap = false;//not loading tile map
    preloading = false;//no longer preloading
    loop();//allow drawing
  }else{
    preloading = true;//now preloading
    prepreloading = true;//now prepreloading
    UISetup = false;//ui is setup
    loadingTileMap = true;//loading tile map
    changeVisibility(true);//tile map loading screen
  }
}//void loadMap() END

//---------------------------------------------------------------------------------------------------------------------------------------

void FileSaveCanvasSelect(File selection){//map canvas save select callback
  if (selection == null) {//we didn't select a file
    println("Window was closed or the user hit cancel.");
  } else {//we selected a file
    println("User selected " + selection.getAbsolutePath() + " for saving");
    fileName = selection.getAbsolutePath();//get the path to the file
    //String[] fileNameSplit = split(fileName, '.');//split the filename into parts
    //String[] fileNamePNG = {fileNameSplit[0], "png"};//array of filename and png
    //if(fileNameSplit.length > 1){//does the file have an extension
    if(split(fileName, '.').length > 1){//does the file have an extension
      //Already has file type
    }else{
      //fileName = join(fileNamePNG, '.');//make sure the filename ends with .png
      fileName = join(new String[] {fileName, "png"}, '.');//make sure the filename ends with .png
    }
    FileSaveCanvas();//save the canvas
  }
}//void FileSaveCanvasSelect(File selection) END

//---------------------------------------------------------------------------------------------------------------------------------------

void fileSaveMapSelect(File selection){//map file save select callback
  if (selection == null) {//we didn't select a file
    println("Window was closed or the user hit cancel.");
  } else {//we selected a file
    println("User selected " + selection.getAbsolutePath() + " for saving");
    fileName = selection.getAbsolutePath();//get the path to the file
    //String[] fileNameSplit = split(fileName, '.');//split the filename into parts
    //String[] fileNameCSV = {fileNameSplit[0], "csv"};//array of filename and csv
    //if(fileNameSplit.length > 1){//does the file have an extension
    if(split(fileName, '.').length > 1){//does the file have an extension
      //Already has file type
    }else{
      //fileName = join(fileNamePNG, '.');//make sure the filename ends with .png
      fileName = join(new String[] {fileName, "ddj"}, '.');//make sure the filename ends with .png
    }
    fileSaveMap();//save the map
  }
}//void fileSaveLoadSelect(File selection) END

//---------------------------------------------------------------------------------------------------------------------------------------

void FileLoadMapSelect(File selection){//map file load select callback
  if (selection == null) {//we didn't select a file
    println("Window was closed or the user hit cancel.");
  } else {//we selected a file
    println("User selected " + selection.getAbsolutePath() + " for loading");
    fileName = selection.getAbsolutePath();//get the path to the file
    FileLoadMap();//load the map
  }
}//void FileLoadMapSelect(File selection) END

//---------------------------------------------------------------------------------------------------------------------------------------

void FileSaveCanvas(){//Save the Canvas to a file
  int lowX = scl * cols;//make it all the way to the right
  int highX = 0;//make it all the way to the left
  int lowY = scl * rows;//make it all the way down
  int highY = 0;//make it all the way up
  
  for(int i = 0; i < mapTiles.length; i++){//Go through all the tiles
    if(mapTiles[i].x < lowX){//if theres a tile further left
      lowX = mapTiles[i].x;//set that as the left
    }
    if(mapTiles[i].x > highX){//if theres a tile further right
      highX = mapTiles[i].x;//set that as the right
    }
    if(mapTiles[i].y < lowY){//if theres a tile further up
      lowY = mapTiles[i].y;//set that as the up
    }
    if(mapTiles[i].y > highY){//if theres a tile further down
      highY = mapTiles[i].y;//set that as the down
    }
  }//Went through all the tiles

  PGraphics fullCanvas = createGraphics(highX - lowX + scl + 1, highY - lowY + scl + 1);//make the canvas slightly larger than needed
  fullCanvas.beginDraw();//start drawing the canvas
  fullCanvas.background(255);//make the background white
  fullCanvas.image(BACKGROUND, 0, 0);//Draw the background
  //Display Map Tiles
  for(int i = 0; i < mapTiles.length; i++){//Go through all the tiles
    if(!mapTiles[i].clear){//Is the tile colored
      fullCanvas.fill(mapTiles[i].r,mapTiles[i].g,mapTiles[i].b);//Set Tile background color
      fullCanvas.rect(mapTiles[i].x - lowX,mapTiles[i].y - lowY,scl,scl);//Draw colored square behind tile
    }
    fullCanvas.image(img[mapTiles[i].image], mapTiles[i].x - lowX, mapTiles[i].y - lowY);//Draw tile
  }//Went through all the tiles
  fullCanvas.endDraw();//stop drawing the canvas
  fullCanvas.save(fileName);// + ".png");//Save the map to a PNG file
}//void FileSaveCanvas() END

//---------------------------------------------------------------------------------------------------------------------------------------

void fileSaveMap(){//Save the Map to file
  if(loadingTileMap == true){
    tileMapLocation = tileInfoTable.getString(tileMapShow + 1,"location");//load location
    totalImages = tileInfoTable.getInt(tileMapShow + 1,"images") - 1;//load number of images
    tileMapWidth = tileInfoTable.getInt(tileMapShow + 1,"tileMapWidth");//load number of tiles wide
    tileMapHeight = tileInfoTable.getInt(tileMapShow + 1,"tileMapHeight");//load number of tiles tall
    colorTile = tileInfoTable.getInt(tileMapShow + 1,"colortile");//load number of tiles tall
    tileMapName = tileInfoTable.getString(tileMapShow + 1,"name");//load name
    fullTotalImages = ceil((float)totalImages / rowLength) * rowLength - 1;//adjust total images
    preload();//preload stuff
    tileN = 1;//make sure were on tile 1
    updateTileRow();//make sure we're on the correct row
    noTile = false;//allowed to place tiles
    loadingTileMap = false;//no longer loading map
    preloading = false;//no longer preloading
    changeVisibility(false);//go to normal display
    return;
  }
  
  if(fileName.equals("Error")){
    return;
  }
  
  byte[] mapFile = new byte[14];//Save Meta Data
  int mapFlags = 0;
  
  //mTile[] clickTiles = new mTile[0];
  
  //Do we compress clickable icon text?
  String[] clickLoc = new String[0];//Array of clickable icon file locations
  String[] hoveText = new String[0];//Array of clickable icon hover texts
  
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////FILE METADATA
  //File Version
  mapFile[0] = (byte)(_FILEVERSION_ >> 8);
  mapFile[1] = (byte)_FILEVERSION_;
  
  //mapFile[2] = 0;//Header Length
  //mapFile[3] = 0;//Header Length
  
  mapFile[4] = (byte)tileMapName.length();
  mapFile[5] = (byte)tileMapLocation.length();
  
  //Map Tiles Amount
  mapFile[6] = (byte)(mapTiles.length >> 24);
  mapFile[7] = (byte)(mapTiles.length >> 16);
  mapFile[8] = (byte)(mapTiles.length >> 8);
  mapFile[9] = (byte)mapTiles.length;
  
  //Clickable Icons Amount
  mapFile[10] = (byte)(icons.length >> 24);
  mapFile[11] = (byte)(icons.length >> 16);
  mapFile[12] = (byte)(icons.length >> 8);
  mapFile[13] = (byte)icons.length;
  
  //Tile Map Name
  for(int i = 0; i < tileMapName.length(); i++){
    mapFile = (byte[]) expand(mapFile, mapFile.length + 1);//make sure we have room
    mapFile[mapFile.length - 1] = (byte)tileMapName.charAt(i);
  }
  
  //Tile Map Location
  for(int i = 0; i < tileMapLocation.length(); i++){
    mapFile = (byte[]) expand(mapFile, mapFile.length + 1);//make sure we have room
    mapFile[mapFile.length - 1] = (byte)tileMapLocation.charAt(i);
  }
  
  //int padding = floor(mapFile.length / 16) * 16;
  int padding = 16 - floor(mapFile.length % 16);
  if(padding < 16){
    for(int l = 0; l < padding; l++){
      mapFile = (byte[]) expand(mapFile, mapFile.length + 1);//make sure we have room
      mapFile[mapFile.length - 1] = (byte)0xA5;
    }
  }
  
  mapFile[2] = (byte)(mapFile.length >> 8);//Header Length
  mapFile[3] = (byte)mapFile.length;//Header Length
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////FILE METADATA
  
  if(_FILEVERSION_ == 4){// || _FILEVERSION_ == 3){//whats the file version
    //Map Tiles
    for(int i = 0; i <= mapTiles.length - 1; i++){//loop through all tiles
      mapFile = (byte[]) expand(mapFile, mapFile.length + 8);//make sure we have room
      //XY
      mapFile[mapFile.length - 8] = (byte)(mapTiles[i].x / scl);
      mapFile[mapFile.length - 7] = (byte)(mapTiles[i].y / scl);
      
      //Image Number
      mapFile[mapFile.length - 6] = (byte)(mapTiles[i].image >> 8);
      mapFile[mapFile.length - 5] = (byte)mapTiles[i].image;
      
      //Red/Green
      mapFile[mapFile.length - 4] = (byte)mapTiles[i].r;
      mapFile[mapFile.length - 3] = (byte)mapTiles[i].g;
      
      //Blue/Flags
      mapFile[mapFile.length - 2] = (byte)mapTiles[i].b;
      if(mapTiles[i].clear){
        mapFlags |= 1;
      }
      mapFile[mapFile.length - 1] = (byte)mapFlags;
    }
    
    //int padding = floor(mapFile.length / 16) * 16;
    padding = 16 - floor(mapFile.length % 16);
    if(padding < 16){
      for(int l = 0; l < padding; l++){
        mapFile = (byte[]) expand(mapFile, mapFile.length + 1);//make sure we have room
        mapFile[mapFile.length - 1] = (byte)0xA5;
      }
    }
    
    //Clickable Icons
    for(int i = 0; i <= icons.length - 1; i++){//loop through all tiles
      mapFile = (byte[]) expand(mapFile, mapFile.length + 4);//make sure we have room
      //XY
      mapFile[mapFile.length - 4] = (byte)(icons[i].x / scl);
      mapFile[mapFile.length - 3] = (byte)(icons[i].y / scl);
      
      //Image Number
      mapFile[mapFile.length - 2] = (byte)icons[i].file.length();
      mapFile[mapFile.length - 1] = (byte)icons[i].hoverText.length();
      
      //Tile Map Name
      for(int j = 0; j < icons[i].file.length(); j++){
        mapFile = (byte[]) expand(mapFile, mapFile.length + 1);//make sure we have room
        mapFile[mapFile.length - 1] = (byte)icons[i].file.charAt(j);
      }
  
      //Tile Map Location
      for(int k = 0; k < icons[i].hoverText.length(); k++){
        mapFile = (byte[]) expand(mapFile, mapFile.length + 1);//make sure we have room
        mapFile[mapFile.length - 1] = (byte)icons[i].hoverText.charAt(k);
      }
      
      //int padding = floor(mapFile.length / 16) * 16;
      padding = 16 - floor(mapFile.length % 16);
      if(padding < 16){
        for(int l = 0; l < padding; l++){
          mapFile = (byte[]) expand(mapFile, mapFile.length + 1);//make sure we have room
          mapFile[mapFile.length - 1] = (byte)0xA5;
        }
      }
    }
  }else{
    println("File Version Error (Saving).");//throw error
  }
  
  saveBytes(fileName, mapFile);
  
  fileName = "Error";
}//void fileSaveLoad() END

//---------------------------------------------------------------------------------------------------------------------------------------

int convertFourBytesToInt(byte a, byte b, byte c, byte d){
  int returnValue = 0;
  
  returnValue = a & 0xFF;
  returnValue = returnValue << 8;
  returnValue |= b & 0xFF;
  returnValue = returnValue << 8;
  returnValue |= c & 0xFF;
  returnValue = returnValue << 8;
  returnValue |= d & 0xFF;
  
  return returnValue;
}

//---------------------------------------------------------------------------------------------------------------------------------------

void FileLoadMap(){//load map from file
  if(fileName.equals("Error")){
    return;
  }

  noLoop();//dont allow drawing
  byte[] mapFile = loadBytes(fileName);
  int fileVersion;
  int headerLength;
  String headerTileName;
  int nameLength;
  String headerTileLocation;
  int locationLength;
  int mapTilesAmount;
  int iconsAmount;
  
  clearMapTilesArray();
  clearClickableTilesArray();
  
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////FILE METADATA
  //File Version
  fileVersion = (int)(mapFile[0] << 8);
  fileVersion |= (int)mapFile[1];
  
  headerLength = (int)(mapFile[2] << 8);//Header Length
  headerLength |= (int)mapFile[3];//Header Length
  
  nameLength = (int)mapFile[4];
  locationLength = (int)mapFile[5];
  
  //Map Tiles Amount
  mapTilesAmount = convertFourBytesToInt(mapFile[6], mapFile[7], mapFile[8], mapFile[9]);
  println(mapTilesAmount + " Tiles Loaded");
  
  //Clickable Icons Amount
  iconsAmount = convertFourBytesToInt(mapFile[10], mapFile[11], mapFile[12], mapFile[13]);
  
  //Tile Map Name
  headerTileName = "";
  for(int i = 0; i < nameLength; i++){
    headerTileName += str((char)mapFile[14 + i]);
  }
  println("Tile Map Name: " + headerTileName);
  
  headerTileLocation = "";
  for(int i = 0; i < locationLength; i++){
    headerTileLocation += str((char)mapFile[14 + nameLength + i]);
  }
  println("Tile Map Location: " + headerTileLocation);
  
  if(!tileMapName.equals(headerTileName)){//if map names aren't equal
    println("Changing Tile Map");
    tileMapName = headerTileName;//Tile Map Name
    FileLoadTileMapInfo();
    preload();
  }else{
    
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////FILE METADATA
  
  if(fileVersion == 4){//whats the file version
    //println(mapTilesAmount);
    
    //Load Map Tiles
    for(int i = 0; i < mapTilesAmount; i++){//Loop through all the rows
      //println(i - 32);
      boolean CLEAR = false;//tile is not clear
      if((mapFile[(i * 8) + headerLength + 7] & 0x01) == 1){//Is Tile Clear
        CLEAR = true;//tile is clear
      }
      
      int imageNumber = (mapFile[(i * 8) + headerLength + 2] << 8) & 0xFF;
      imageNumber |= (mapFile[(i * 8) + headerLength + 3]) & 0xFF;
      //println(imageNumber);
      
      mapTiles = (mTile[]) expand(mapTiles, mapTiles.length + 1);//Make sure we have room
      mapTiles[mapTiles.length - 1] = new mTile((mapFile[(i * 8) + headerLength] & 0xFF) * scl,//Tile X position
                                                (mapFile[(i * 8) + headerLength + 1] & 0xFF) * scl,//Tile Y position
                                                imageNumber,//Tile Image
                                                mapFile[(i * 8) + headerLength + 4],//Tile Red amount
                                                mapFile[(i * 8) + headerLength + 5],//Tile Green amount
                                                mapFile[(i * 8) + headerLength + 6],//Tile Blue amount
                                                CLEAR);//Is Tile Clear
      //println(mapTiles[mapTiles.length - 1].x + ", " + mapTiles[mapTiles.length - 1].y);
    }
    
    int mapTilesLength = (mapTilesAmount * 8) + (16 - floor(mapTilesAmount * 8) % 16) + headerLength;
    
    //Load Clickable Tiles
    
    int iconsAddress = mapTilesLength;
    println("Starting Icons Address: " + iconsAddress);
    
    for(int i = 0; i < iconsAmount; i++){//Loop through all the rows
    
      int clickFileAddress = iconsAddress + 4;
      int clickTextAddress = clickFileAddress + (int)mapFile[iconsAddress + 2];
      
      String clickableFile = "";
      for(int j = 0; j < mapFile[iconsAddress + 2]; j++){
        clickableFile += str((char)mapFile[clickFileAddress + j]);
      }
      println("Clickable Tile File: " + clickableFile);
      
      String clickableHover = "";
      for(int j = 0; j < mapFile[iconsAddress + 3]; j++){
        clickableHover += str((char)mapFile[clickTextAddress + j]);
      }
      println("Clickable Tile Text: " + clickableHover);
    
      icons = (clickableIcon[]) expand(icons, icons.length + 1);//Make sure we have room
      icons[icons.length - 1] = new clickableIcon((mapFile[iconsAddress] & 0xFF) * scl,//Tile X position
                                                (mapFile[iconsAddress + 1] & 0xFF) * scl,//Tile Y position
                                                clickableFile,//Tile Image
                                                clickableHover);//Is Tile Clear
      //println(mapTiles[mapTiles.length - 1].x + ", " + mapTiles[mapTiles.length - 1].y);
      
      iconsAddress = clickTextAddress + (16 - (clickTextAddress % 16));
      println("Sequential Icons Address: " + iconsAddress);
    }
  }else{//we don't know that file version
    println("File Version Error (Loading).");//throw error
  }
  
  if(mapTiles == null){//Is the array null
    clearMapTilesArray();
  }
  
  if(icons == null){//Is the array null
    clearClickableTilesArray();
  }
  
  loop();//allow drawing
  prepreloading = false;//no longer prepreloading
  resetLHXY();
  
  fileName = "Error";
}//void FileLoadMap() END