import java.util.Date;

ArrayList<tileMap> tileMaps = new ArrayList<tileMap>(0);//arraylist of tile maps
//ArrayList<PImage> tiles = new ArrayList<PImage>(0);//arraylist of tile images
PImage[] tileImages = new PImage[0];//Tile Images Array
int loadedTileMap = -1;

void loadTileMap(){
  //i only exist so they know where the new code needs to be placed
  tileImages = tileMaps.get(tileMapShow).splitTiles();
}

void loadTileMapInfo(){
  //i only exist so they know where the new code needs to be placed
  String path = sketchPath() + "/assets/";
  ArrayList<File> allFiles = listFilesRecursive(path);
  String directory = "";

  for(File f : allFiles) {
    if(f.isDirectory()){
      directory = f.getAbsolutePath();
    }
    
    if(f.getName().endsWith(".csv")){
      loadTileMapInfo(directory, f.getAbsolutePath());
    }
  }
}

class tileMap{
  PImage tileMapImage;//tile map image
  String tileMapLocation;//location
  int tileMapcols;//tileMapWidth
  int tileMaprows;//tileMapHeight
  int tileWidth;//tileMapTileX
  int tileHeight;//tileMapTileY
  int numImages;//images
  int colorTile;//colortile
  String tileMapName;//name
  
  public tileMap(String loc, int rows, int cols, int tileWidth, int tileHeight, int num, int colorTile, String name){
    this.tileMapLocation = loc;
    this.tileMapcols = cols;
    this.tileMaprows = rows;
    this.tileWidth = tileWidth;
    this.tileHeight = tileHeight;
    this.numImages = num;
    this.colorTile = colorTile;
    this.tileMapName = name;
    
    this.tileMapImage = loadImage(this.tileMapLocation);
  }
  
  //ArrayList<PImage> splitTiles(){
  PImage[] splitTiles(){
    //ArrayList<PImage> tmpTiles = new ArrayList<PImage>();
    PImage[] tmpTiles = new PImage[this.numImages];
    int total = 0;
    for(int y = 0; y < this.tileMaprows; y++){
      for(int x = 0; x < this.tileMapcols; x++){
        PImage tmp = createImage(this.tileWidth, this.tileHeight, ARGB);
        tmp.copy(this.tileMapImage, x * scl, y * scl, this.tileWidth, this.tileHeight, 0, 0, this.tileWidth, this.tileHeight);
        //tmpTiles.add(tmp);
        tmpTiles[total] = tmp;
        total++;
        if(total == this.numImages){
          //println(((x + 1) * (y + 1)) - 1);
          fullTotalImages = (ceil((float)(numImages) / rowLength) * rowLength) - 1;//make sure all tile rows are full
          loadedTileMapName = this.tileMapName;
          return tmpTiles;
        }
      }
    }
    return tmpTiles;
  }
}

void loadTileMapInfo(String directory, String fileLocation){
  Table tileInfoTable = new Table();//tile map info table
  tileInfoTable = loadTable(fileLocation, "header, csv");// + ".csv", "header");//Load the csv
  
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////FILE METADATA
  int fileVersion = int(tileInfoTable.getInt(0,"location"));//File Version
  //int(mapTable.get(0,"tileMapColumns"));//blank
  //int(mapTable.get(0,"tileMapRows"));//blank
  //int(mapTable.get(0,"tileWidth"));//blank
  //int(mapTable.get(0,"tileHeight"));//blank
  //int(mapTable.get(0,"images"));//blank
  //int(mapTable.get(0,"colortile"));//blank
  //mapTable.get(0,"name");//should be "Info"
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////FILE METADATA
  
  if(fileVersion == 0){//whats the file version
    for(int i = 1; i < tileInfoTable.getRowCount(); i++){//Loop through all the tile maps
      println(tileInfoTable.getString(i,"location") + ", " +//tile map image location
              tileInfoTable.getInt(i,"tileMapColumns") + ", " +//tile map columns
              tileInfoTable.getInt(i,"tileMapRows") + ", " +//tile map rows
              tileInfoTable.getInt(i,"tileWidth") + ", " +//tile width
              tileInfoTable.getInt(i,"tileHeight") + ", " +//tile height
              tileInfoTable.getInt(i,"images") + ", " +//number of images
              tileInfoTable.getInt(i,"colortile") + ", " +//clear color tile number
              tileInfoTable.getString(i,"name"));//tile map name

      //String loc, int rows, int cols, int tileWidth, int tileHeight, int num, int colorTile, String name
      tileMaps.add(new tileMap(directory + "\\" + tileInfoTable.getString(i,"location"),
                               tileInfoTable.getInt(i,"tileMapColumns"), tileInfoTable.getInt(i,"tileMapRows"),
                               tileInfoTable.getInt(i,"tileWidth"), tileInfoTable.getInt(i,"tileHeight"),
                               tileInfoTable.getInt(i,"images"), tileInfoTable.getInt(i,"colortile"),
                               tileInfoTable.getString(i,"name")));
    }
  }else{//we don't know that file version
    println("File Version Error (Loading).");//throw error
  }
}

//void fileHandlingTest(){
//  // Using just the path of this sketch to demonstrate,
//  // but you can list any directory you like.
//  String path = sketchPath() + "/assets/";
//  println(path);

//  println("Listing all filenames in a directory: ");
//  String[] filenames = listFileNames(path);
//  printArray(filenames);
//  println(filenames[0]);

//  println("\nListing info about all files in a directory: ");
//  File[] files = listFiles(path);
//  for (int i = 0; i < files.length; i++) {
//    File f = files[i];    
//    println("Name: " + f.getName());
//    println("Is directory: " + f.isDirectory());
//    println("Size: " + f.length());
//    String lastModified = new Date(f.lastModified()).toString();
//    println("Last Modified: " + lastModified);
//    println("-----------------------");
//  }

//  println("\nListing info about all files in a directory and all subdirectories: ");
//  ArrayList<File> allFiles = listFilesRecursive(path);

//  for (File f : allFiles) {
//    println("Name: " + f.getName());
//    println("Full path: " + f.getAbsolutePath());
//    println("Is directory: " + f.isDirectory());
//    println("Size: " + f.length());
//    String lastModified = new Date(f.lastModified()).toString();
//    println("Last Modified: " + lastModified);
//    println("-----------------------");
//  }
//}

//// This function returns all the files in a directory as an array of Strings  
//String[] listFileNames(String dir) {
//  File file = new File(dir);
//  if (file.isDirectory()) {
//    String names[] = file.list();
//    return names;
//  } else {
//    // If it's not a directory
//    return null;
//  }
//}

//// This function returns all the files in a directory as an array of File objects
//// This is useful if you want more info about the file
//File[] listFiles(String dir) {
//  File file = new File(dir);
//  if (file.isDirectory()) {
//    File[] files = file.listFiles();
//    return files;
//  } else {
//    // If it's not a directory
//    return null;
//  }
//}

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