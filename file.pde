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
final String keyBind_exportCanvas_String = "CTRL + SHIFT + E";
final String keyBind_saveMapAs_String = "CTRL + SHIFT + S";
final String keyBind_newMap_String = "CTRL + N";
final String keyBind_openMap_String = "CTRL + O";
final String keyBind_saveMap_String = "CTRL + S";
final String keyBind_colorTiles_String = "F";
final String keyBind_tileGroup_String = "Q";
final String keyBind_cut_String = "X";
final String keyBind_copy_String = "C";
final String keyBind_paste_String = "V";
final String keyBind_tileDebug_String = "R";
final String keyBind_copyColor_String = "E";
final String keyBind_setBackground_String = "P";
final String keyBind_lines_String = "O";
final String keyBind_moveUp_String = "W";
final String keyBind_moveLeft_String = "A";
final String keyBind_moveDown_String = "S";
final String keyBind_moveRight_String = "D";
final String keyBind_delete_String = "DELETE";

final byte[] keyBind_null = {0x00};

void FileCreateSettings(File settingsFile){
  //byte[] tmpFile = {
  //  0x00, 0x00,//file version
  //  //all strings are null (0) terminated
  //  0x43, 0x54, 0x52, 0x4C, 0x20, 0x2B, 0x20, 0x53, 0x48, 0x49, 0x46, 0x54, 0x20, 0x2B, 0x20, 0x45, 0x00,//export canvas - CTRL + SHIFT + E
  //  0x43, 0x54, 0x52, 0x4C, 0x20, 0x2B, 0x20, 0x53, 0x48, 0x49, 0x46, 0x54, 0x20, 0x2B, 0x20, 0x53, 0x00,//save map as - CTRL + SHIFT + S
  //  0x43, 0x54, 0x52, 0x4C, 0x20, 0x2B, 0x20, 0x4E, 0x00,//new map - CTRL + N
  //  0x43, 0x54, 0x52, 0x4C, 0x20, 0x2B, 0x20, 0x4F, 0x00,//open map - CTRL + O
  //  0x43, 0x54, 0x52, 0x4C, 0x20, 0x2B, 0x20, 0x53, 0x00,//save map - CTRL + S
  //  0x46, 0x00,//color tiles - F
  //  0x51, 0x00,//tile group - Q
  //  0x58, 0x00,//cut - X
  //  0x43, 0x00,//copy - C
  //  0x56, 0x00,//paste - V
  //  0x52, 0x00,//tile debug - R
  //  0x45, 0x00,//copy color - E
  //  0x50, 0x00,//set background color - P
  //  0x4F, 0x00,//background lines - O
  //  0x57, 0x00,//up - W
  //  0x41, 0x00,//left - A
  //  0x53, 0x00,//down - S
  //  0x44, 0x00,//right - D
  //  0x44, 0x45, 0x4C, 0x45, 0x54, 0x45, 0x00,//delete tiles - DELETE
  //};
  
  //tmpFile[0] = (byte)(_FILEVERSION_SETTINGS_ >> 8);//upper byte
  //tmpFile[1] = (byte)_FILEVERSION_SETTINGS_;//lower byte
  
  byte[] tmpFile = new byte[0];
  
  //file version
  tmpFile = concat(tmpFile, versionToBytes(_FILEVERSION_SETTINGS_));
  
  //all strings are null (0) terminated
  tmpFile = concat(tmpFile, stringToBytesNull(keyBind_exportCanvas_String));
  tmpFile = concat(tmpFile, stringToBytesNull(keyBind_saveMapAs_String));
  tmpFile = concat(tmpFile, stringToBytesNull(keyBind_newMap_String));
  tmpFile = concat(tmpFile, stringToBytesNull(keyBind_openMap_String));
  tmpFile = concat(tmpFile, stringToBytesNull(keyBind_saveMap_String));
  tmpFile = concat(tmpFile, stringToBytesNull(keyBind_colorTiles_String));
  tmpFile = concat(tmpFile, stringToBytesNull(keyBind_tileGroup_String));
  tmpFile = concat(tmpFile, stringToBytesNull(keyBind_cut_String));
  tmpFile = concat(tmpFile, stringToBytesNull(keyBind_copy_String));
  tmpFile = concat(tmpFile, stringToBytesNull(keyBind_paste_String));
  tmpFile = concat(tmpFile, stringToBytesNull(keyBind_tileDebug_String));
  tmpFile = concat(tmpFile, stringToBytesNull(keyBind_copyColor_String));
  tmpFile = concat(tmpFile, stringToBytesNull(keyBind_setBackground_String));
  tmpFile = concat(tmpFile, stringToBytesNull(keyBind_lines_String));
  tmpFile = concat(tmpFile, stringToBytesNull(keyBind_moveUp_String));
  tmpFile = concat(tmpFile, stringToBytesNull(keyBind_moveLeft_String));
  tmpFile = concat(tmpFile, stringToBytesNull(keyBind_moveDown_String));
  tmpFile = concat(tmpFile, stringToBytesNull(keyBind_moveRight_String));
  tmpFile = concat(tmpFile, stringToBytesNull(keyBind_delete_String));
  
  //program version and magic text
  tmpFile = concat(tmpFile, _PROGRAMVERSION_FILE_);
  tmpFile = concat(tmpFile, stringToBytes(_magicText));

  saveBytes(settingsFile, tmpFile);//save the file
}

void FileLoadSettings(File settingsFile){//load map from file
  noLoop();//dont allow drawing
  byte[] settingsArray = loadBytes(settingsFile);//temporary array
  
  //String magic = "";
  ////println(mapFile.length);
  //for(int l = 0; l < _magicText.length(); l++){
  //  magic += (char)settingsFile[(settingsFile.length - _magicText.length()) + l];
  //}
  
  //if(!magic.equals(_magicText)){//is the file ours
  //  //loadingMap = false;//since this file was not ours we're no longer loading a map
  //  //println("not ours");
  //  loop();
  //  return;//file was not one of ours
  //}
  
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
      while(position < settingsArray.length && settingsArray[position] != 0){
        //print(char(settingsFile[position]));
        keyBinds[i] += char(settingsArray[position]);
        position++;
      }
      position++;
      //println();
    }
  }else{//we don't know that file version
    println("Settings Version Error (Loading).");//throw error
  }
  //printArray(keyBinds);
  loop();//allow drawing
}//void FileLoadMap() END

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