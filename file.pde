int _FILEVERSION_ = 4;//what version of file saving and loading
static final String _magicText = "wawa1474DragDraw";

ArrayList<Byte> mapFile = new ArrayList<Byte>(0);

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
    selectInput("Select a File to load:", "FileLoadMapSelect");//load a map
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
    prepreloading = false;///---------------------------------------------------------------do we want this?
  } else {//we selected a file
    println("User selected " + selection.getAbsolutePath() + " for loading");
    fileName = selection.getAbsolutePath();//get the path to the file
    FileLoadMap();//load the map
  }
}//void FileLoadMapSelect(File selection) END

//---------------------------------------------------------------------------------------------------------------------------------------

void FileSaveCanvas(){//Save the Canvas to a file

  PGraphics fullCanvas = createGraphics(upperx - lowerx + scl + 1, uppery - lowery + scl + 1);//make the canvas slightly larger than needed
  fullCanvas.beginDraw();//start drawing the canvas
  fullCanvas.background(255);//make the background white
  fullCanvas.image(BACKGROUND, 0, 0);//Draw the background
  //Display Map Tiles
  for(int x = 0; x < mapTiles.size(); x++){
    for(int y = 0; y < mapTiles.get(x).size(); y++){
      for(int z = 0; z < mapTiles.get(x).get(y).size(); z++){
        if(!mapTiles.get(x).get(y).get(z).clear){//Is the tile colored
          fullCanvas.fill(mapTiles.get(x).get(y).get(z).r,mapTiles.get(x).get(y).get(z).g,mapTiles.get(x).get(y).get(z).b);//Set Tile background color
          fullCanvas.rect(x - lowerx,y - lowery,scl,scl);//Draw colored square behind tile
        }
        fullCanvas.image(img[mapTiles.get(x).get(y).get(z).image], x - lowerx, y - lowery);//Draw tile
      }
    }
  }//Went through all the tiles
  fullCanvas.endDraw();//stop drawing the canvas
  fullCanvas.save(fileName);// + ".png");//Save the map to a PNG file
}//void FileSaveCanvas() END

//---------------------------------------------------------------------------------------------------------------------------------------

void padMapFileArray(){
  int padding = (16 - floor(mapFile.size() % 16)) % 16;
  for(int l = 0; l < padding; l++){
    mapFile.add((byte)0xA5);
  }
}

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
  
  mapFile.clear();
  
  int mapFlags = 0;
  
  //mTile[] clickTiles = new mTile[0];
  
  //Do we compress clickable icon text?
  String[] clickLoc = new String[0];//Array of clickable icon file locations
  String[] hoveText = new String[0];//Array of clickable icon hover texts
  
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////FILE METADATA
  //File Version
  mapFile.add((byte)(_FILEVERSION_ >> 8));
  mapFile.add((byte)_FILEVERSION_);
  
  //dummy header length bytes
  mapFile.add((byte)0x00);
  mapFile.add((byte)0x00);
  
  //Tile map name and location
  mapFile.add((byte)tileMapName.length());
  mapFile.add((byte)tileMapLocation.length());
  
  int tmp = 0;
  
  //Map Tiles Amount
  for(int x = 0; x < mapTiles.size(); x++){
    for(int y = 0; y < mapTiles.get(x).size(); y++){
      tmp += mapTiles.get(x).get(y).size();
    }
  }
  mapFile.add((byte)(tmp >> 24));
  mapFile.add((byte)(tmp >> 16));
  mapFile.add((byte)(tmp >> 8));
  mapFile.add((byte)tmp);
  
  //Clickable Icons Amount
  mapFile.add((byte)(icons.size() >> 24));
  mapFile.add((byte)(icons.size() >> 16));
  mapFile.add((byte)(icons.size() >> 8));
  mapFile.add((byte)icons.size());
  
  //Tile Map Name
  for(int i = 0; i < tileMapName.length(); i++){
    mapFile.add((byte)tileMapName.charAt(i));
  }
  
  //Tile Map Location
  for(int i = 0; i < tileMapLocation.length(); i++){
    mapFile.add((byte)tileMapLocation.charAt(i));
  }
  
  padMapFileArray();
  
  mapFile.set(2, (byte)(mapFile.size() >> 8));//Header Length
  mapFile.set(3, (byte)mapFile.size());//Header Length
  
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////FILE METADATA
  
  if(_FILEVERSION_ == 4){// || _FILEVERSION_ == 3){//whats the file version
    //Map Tiles
    for(int x = 0; x < mapTiles.size(); x++){//loop through all tiles
      for(int y = 0; y < mapTiles.get(x).size(); y++){
        for(int z = 0; z < mapTiles.get(x).get(y).size(); z++){
          //XY
          mapFile.add((byte)(x));
          mapFile.add((byte)(y));
      
          //Image Number
          mapFile.add((byte)(mapTiles.get(x).get(y).get(z).image >> 8));
          mapFile.add((byte)mapTiles.get(x).get(y).get(z).image);
      
          //Red/Green
          mapFile.add((byte)mapTiles.get(x).get(y).get(z).r);
          mapFile.add((byte)mapTiles.get(x).get(y).get(z).g);
      
          //Blue/Flags
          mapFile.add((byte)mapTiles.get(x).get(y).get(z).b);
          if(mapTiles.get(x).get(y).get(z).clear){
            mapFlags |= 1;
          }
          mapFile.add((byte)mapFlags);
        }
      }
    }
    
    padMapFileArray();
    
    //Clickable Icons
    for(int i = 0; i < icons.size(); i++){//loop through all tiles
    
      //XY
      mapFile.add((byte)(icons.get(i).x / scl));
      mapFile.add((byte)(icons.get(i).y / scl));
      
      //Image Number
      mapFile.add((byte)icons.get(i).file.length());
      mapFile.add((byte)icons.get(i).hoverText.length());
      
      //Tile Map Name
      //for(int j = 0; j < icons[i].file.length(); j++){
      for(int j = 0; j < icons.get(i).file.length(); j++){
        mapFile.add((byte)icons.get(i).file.charAt(j));//Add the file name
      }
  
      //Tile Map Location
      for(int k = 0; k < icons.get(i).hoverText.length(); k++){
        mapFile.add((byte)icons.get(i).hoverText.charAt(k));//Add the hover text
      }
      
      padMapFileArray();
      
    }
  }else{
    println("File Version Error (Saving).");//throw error
  }
  
  for(int l = 0; l < _magicText.length(); l++){
    mapFile.add((byte)_magicText.charAt(l));//add the 'Magic Text'
  }
  
  byte[] tmpFile = new byte[mapFile.size()];
  for(int i = 0; i < mapFile.size(); i++){
    tmpFile[i] = mapFile.get(i);
  }
  saveBytes(fileName, tmpFile);
  
  mapFile.clear();
  
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
  
  String magic = "";
  //println(mapFile.length);
  for(int l = 0; l < _magicText.length(); l++){
    magic += (char)mapFile[(mapFile.length - _magicText.length()) + l];
  }
  //println(magic);
  if(!magic.equals(_magicText)){
    prepreloading = false;///---------------------------------------------------------------do we want this?
    loop();
    return;//file was not one of ours
  }
  
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
      int tmp = (i * 8) + headerLength;
      
      //println(i - 32);
      boolean CLEAR = false;//tile is not clear
      if((mapFile[tmp + 7] & 0x01) == 1){//Is Tile Clear
        CLEAR = true;//tile is clear
      }
      
      int imageNumber = (mapFile[tmp + 2] << 8) & 0xFF;
      imageNumber |= (mapFile[tmp + 3]) & 0xFF;
      //println(imageNumber);
      
      //println((mapFile[tmp] & 0xFF) + ": " + (mapFile[tmp + 1] & 0xFF));
      mapTiles.get((mapFile[tmp] & 0xFF)).get((mapFile[tmp + 1] & 0xFF)).add(new mTile(
                                                imageNumber,//Tile Image
                                                mapFile[tmp + 4],//Tile Red amount
                                                mapFile[tmp + 5],//Tile Green amount
                                                mapFile[tmp + 6],//Tile Blue amount
                                                CLEAR));//Is Tile Clear
      //println(mapTiles[mapTiles.length - 1].x + ", " + mapTiles[mapTiles.length - 1].y);
    }
    
    int mapTilesLength = (mapTilesAmount * 8) + ((16 - floor(mapTilesAmount * 8) % 16) % 16) + headerLength;
    
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
    
      //icons = (clickableIcon[]) expand(icons, icons.length + 1);//Make sure we have room
      //icons[icons.length - 1] = new clickableIcon((mapFile[iconsAddress] & 0xFF) * scl,//Tile X position
      icons.add(new clickableIcon((mapFile[iconsAddress] & 0xFF) * scl,//Tile X position
                                                (mapFile[iconsAddress + 1] & 0xFF) * scl,//Tile Y position
                                                clickableFile,//Tile Image
                                                //clickableHover);//Is Tile Clear
                                                clickableHover));//Is Tile Clear
      //println(mapTiles[mapTiles.length - 1].x + ", " + mapTiles[mapTiles.length - 1].y);
      
      iconsAddress = clickTextAddress + (16 - ((clickTextAddress % 16) % 16));
      println("Sequential Icons Address: " + iconsAddress);
    }
  }else{//we don't know that file version
    println("File Version Error (Loading).");//throw error
  }
  
  //if(mapTiles == null){//Is the array null
  //  clearMapTilesArray();
  //}
  
  if(icons == null){//Is the array null
    clearClickableTilesArray();
  }
  
  loop();//allow drawing
  prepreloading = false;//no longer prepreloading
  resetLHXY();
  
  fileName = "Error";
}//void FileLoadMap() END