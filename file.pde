final int keyBind_exportCanvas = 0;
final int keyBind_saveMapAs = 1;
final int keyBind_newMap = 2;
final int keyBind_openMap = 3;
final int keyBind_saveMap = 4;
final int keyBind_colorTiles = 5;
final int keyBind_tileGroup = 6;
final int keyBind_cut = 7;
final int keyBind_copy = 8;
final int keyBind_paste = 9;
final int keyBind_tileDebug = 10;
final int keyBind_copyColor = 11;
final int keyBind_setBackground = 12;
final int keyBind_lines = 13;
final int keyBind_moveUp = 14;
final int keyBind_moveLeft = 15;
final int keyBind_moveDown = 16;
final int keyBind_moveRight = 17;
final int keyBind_delete = 18;

//default keybinds
final String[] defaultKeyBinds = {
  "CTRL + SHIFT + E",//export canvas
  "CTRL + SHIFT + S",//save map as
  "CTRL + N",//new map
  "CTRL + O",//open map
  "CTRL + S",//save map
  "F",//color tiles
  "Q",//tile group
  "X",//cut
  "C",//copy
  "V",//paste
  "R",//tile debug
  "E",//copy color
  "P",//set background color
  "O",//toggle background lines
  "W",//up
  "A",//left
  "S",//down
  "D",//right
  "DELETE"//delete tiles
};

void FileCreateSettings(File settingsFile){  
  byte[] tmpFile = new byte[0];
  
  //file version
  tmpFile = concat(tmpFile, versionToBytes(_FILEVERSION_SETTINGS_));
  
  //all strings are null (0) terminated
  for(int i = 0; i < defaultKeyBinds.length; i++){
    tmpFile = concat(tmpFile, stringToBytesNull(defaultKeyBinds[i]));
  }
  
  //program version and magic text
  tmpFile = concat(tmpFile, _PROGRAMVERSION_FILE_);
  tmpFile = concat(tmpFile, stringToBytes(_magicText));

  saveBytes(settingsFile, tmpFile);//save the file
  logPrintln("Settings File Created", true);
}

void FileLoadSettings(File settingsFile){//load map from file
  logPrintln("Loading Settings", true);
  noLoop();//dont allow drawing
  byte[] settingsArray = loadBytes(settingsFile);//temporary array
  
  if(!checkMagic(subset(settingsArray, settingsArray.length - _magicText.length()))){
    loop();
    return;//file was not one of ours
  }
  
  int fileVersion;//what file version is the file
  
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////FILE METADATA
  //File Version
  fileVersion = int(settingsArray[0] << 8);//upper byte
  fileVersion |= int(settingsArray[1]);//lower byte
  //println("Settings Version - " + fileVersion);
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////FILE METADATA
  
  if(fileVersion == 0){//whats the file version
    int position = 2;
    
    //Load Map Tiles
    for(int i = 0; i < keyBinds.length; i++){//Loop through all the rows
      keyBinds[i] = new String();
      keyBinds[i] = "";
      while(position < settingsArray.length && settingsArray[position] != 0x00){
        //print(char(settingsFile[position]));
        keyBinds[i] += char(settingsArray[position]);
        position++;
      }
      position++;
      //println();
    }
  }else{//we don't know that file version
    println("Settings Version Error (Loading).");//throw error
    logPrintln("Settings File is Unknown Version: " + fileVersion, true);
  }
  //printArray(keyBinds);
  loop();//allow drawing
  logPrintln("Settings Loaded", true);
}//void FileLoadMap() END

void loadAssets(){
  File assetsFolder = new File(programDirectory + "/assets/");
  logPrintln("Assets Directory is: " + assetsFolder, true);
  if (!assetsFolder.exists()){
    try {
      //assetsFolder.mkdir();
      println("resources not extracted, extracting");
      logPrintln("Resources Not Extracted, Extracting", true);
      //copyResources(programDir);
      File resourcesZip = new File(programDirectory + "/res.zip");
      copyResources(programDirectory, resourcesZip);
      println("resources extracted");
      logPrintln("Resources Extracted", true);
    } catch (Exception e) {
      println("Exception caught in Setup");
      println(e);
      logPrintln("Failed To Extract Resources: " + e, true);
      closeLog();
      _EXIT_ = true;
      exit();
    }
  }
  
  missingTexture = loadImage(assetsFolder + "/missingTexture.png");//load the missing texture file
  alphaBack = loadImage(assetsFolder + "/alphaBack.png");
  hueBack = loadImage(assetsFolder + "/hueBack.png");
  
  options_menu_mockup = loadImage(assetsFolder + "/options_menu_mockup_v2.png");//main_menu_button_selected
  opening_mockup = loadImage(assetsFolder + "/opening_mockup.png");//main_menu_button_selected
}

void loadSettings(){
  File settingsFile = new File(programDirectory + "/settings.set");
  if(!settingsFile.exists()){
    println("Settings File does not exist, creating it...");
    logPrintln("Settings File Does Not Exist, Creating It...", true);
    FileCreateSettings(settingsFile);
    keyBinds = defaultKeyBinds;
  }else{
    FileLoadSettings(settingsFile);
  }
}

byte[] stringToBytes(String input){
  byte[] tmpArray = new byte[input.length()];
  for(int i = 0; i < input.length(); i++){
    tmpArray[i] = byte(input.charAt(i));
  }
  return tmpArray;
}

byte[] stringToBytesNull(String input){
  byte[] tmpArray = new byte[input.length() + 1];
  for(int i = 0; i < input.length(); i++){
    tmpArray[i] = byte(input.charAt(i));
  }
  tmpArray[tmpArray.length - 1] = 0x00;
  return tmpArray;
}

boolean checkMagic(byte[] test){
  String magic = "";
  //println(mapFile.length);
  for(int l = 0; l < _magicText.length(); l++){
    magic += (char)test[l];
  }
  
  if(!magic.equals(_magicText)){//is the file ours
    return false;//file was not one of ours
  }
  return true;
}

byte[] versionToBytes(int v){
  byte[] tmpArray = new byte[2];
  tmpArray[0] = (byte)(v >> 8);//upper byte
  tmpArray[1] = (byte)v;//lower byte
  return tmpArray;
}

void copyResources(File outputDirectory, File inputFile) throws IOException {
  // Unzip inputFile into outputDirectory
  FileInputStream fis = new FileInputStream(inputFile);
  ZipInputStream zipInputStream = new ZipInputStream(fis);

  try {
    ZipEntry zipEntry = zipInputStream.getNextEntry();
    while (zipEntry != null) {
      File file = new File(outputDirectory, zipEntry.getName());
      println(zipEntry.getName());//we can get the file name and location

      if (zipEntry.isDirectory()) {
        file.mkdir();
      } else {
        OutputStream outputStream =
          new BufferedOutputStream(new FileOutputStream(file), BUFFER_SIZE);
        try {
          int b = zipInputStream.read();
          while (b != -1) {
            outputStream.write(b);
            b = zipInputStream.read();
          }
          outputStream.flush();
        } finally {
          outputStream.close();
        }
        file.setLastModified(zipEntry.getTime());
      }
      zipEntry = zipInputStream.getNextEntry();
    }
  } finally {
    zipInputStream.close();
  }
}