import java.util.Date;

ArrayList<tileMap> tileMaps = new ArrayList<tileMap>(0);//arraylist of tile maps
ArrayList<PImage> tiles = new ArrayList<PImage>(0);//arraylist of tile images

void dummyPreload(){
  //i only exist so they know where the new code needs to be placed
}

void dummyFileLoadTileMapInfo(){
  //i only exist so they know where the new code needs to be placed
}

class tileMap{
  PImage tileMapImage;//tile map image
  String location;//location
  int rows;//tileMapHeight
  int cols;//tileMapWidth
  int tileWidth;//tileMapTileX
  int tileHeight;//tileMapTileY
  int numImages;//images
  int colorTile;//colortile
  String name;//name
  
  public tileMap(String loc, int rows, int cols, int tileWidth, int tileHeight, int num, int colorTile, String name){
    this.location = loc;
    this.rows = rows;
    this.cols = cols;
    this.tileWidth = tileWidth;
    this.tileHeight = tileHeight;
    this.numImages = num;
    this.colorTile = colorTile;
    this.name = name;
    
    this.tileMapImage = loadImage(this.location);
  }
  
  ArrayList<PImage> splitTiles(){
    ArrayList<PImage> tiles = new ArrayList<PImage>();
    int total = 0;
    for(int x = 0; x < this.cols; x++){
      for(int y = 0; y < this.rows; y++){
        PImage tmp = createImage(this.tileWidth, this.tileHeight, ARGB);
        tmp.copy(this.tileMapImage, x * scl, y * scl, this.tileWidth, this.tileHeight, 0, 0, this.tileWidth, this.tileHeight);
        tiles.add(tmp);
        if(total == this.numImages - 1){
          return tiles;
        }
      }
    }
    return tiles;
  }
}

void fileHandlingTest(){
  // Using just the path of this sketch to demonstrate,
  // but you can list any directory you like.
  String path = sketchPath() + "/assets/";
  println(path);

  println("Listing all filenames in a directory: ");
  String[] filenames = listFileNames(path);
  printArray(filenames);
  println(filenames[0]);

  println("\nListing info about all files in a directory: ");
  File[] files = listFiles(path);
  for (int i = 0; i < files.length; i++) {
    File f = files[i];    
    println("Name: " + f.getName());
    println("Is directory: " + f.isDirectory());
    println("Size: " + f.length());
    String lastModified = new Date(f.lastModified()).toString();
    println("Last Modified: " + lastModified);
    println("-----------------------");
  }

  println("\nListing info about all files in a directory and all subdirectories: ");
  ArrayList<File> allFiles = listFilesRecursive(path);

  for (File f : allFiles) {
    println("Name: " + f.getName());
    println("Full path: " + f.getAbsolutePath());
    println("Is directory: " + f.isDirectory());
    println("Size: " + f.length());
    String lastModified = new Date(f.lastModified()).toString();
    println("Last Modified: " + lastModified);
    println("-----------------------");
  }
}

// This function returns all the files in a directory as an array of Strings  
String[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } else {
    // If it's not a directory
    return null;
  }
}

// This function returns all the files in a directory as an array of File objects
// This is useful if you want more info about the file
File[] listFiles(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    File[] files = file.listFiles();
    return files;
  } else {
    // If it's not a directory
    return null;
  }
}

// Function to get a list of all files in a directory and all subdirectories
ArrayList<File> listFilesRecursive(String dir) {
  ArrayList<File> fileList = new ArrayList<File>(); 
  recurseDir(fileList, dir);
  return fileList;
}

// Recursive function to traverse subdirectories
void recurseDir(ArrayList<File> a, String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    // If you want to include directories in the list
    a.add(file);  
    File[] subfiles = file.listFiles();
    for (int i = 0; i < subfiles.length; i++) {
      // Call this function on all files in this directory
      recurseDir(a, subfiles[i].getAbsolutePath());
    }
  } else {
    a.add(file);
  }
}

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
      tileMapImages = (PImage[]) expand(tileMapImages, tileMapImages.length + 1);//make sure we have room
      tileMapImages[tileMapImages.length - 1] = loadImage(tileInfoTable.getString(i,"location"));//load tile map image
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
}//FileLoadTileInfo() END