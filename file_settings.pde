/*
load and save program settings
  key binds



file format:

two (2) bytes - file format version
two (2) bytes - header length

three (3) bytes - background color (red, green, blue)

key binds
???!?!?!?!?!?!?!?

sixteen (16) bytes - application version
sixteen (16) bytes - magic text ("wawa1474DragDraw")
*/

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

final int _FILEVERSION_SETTINGS_ = 0;//what version of file saving and loading

void FileCreateSettings(File settingsFile){
  byte[] tmpFile = {
    0x00, 0x00,//file version
    //all strings are null (0) terminated
    0x43, 0x54, 0x52, 0x4C, 0x20, 0x2B, 0x20, 0x53, 0x48, 0x49, 0x46, 0x54, 0x20, 0x2B, 0x20, 0x45, 0x00,//export canvas - CTRL + SHIFT + E
    0x43, 0x54, 0x52, 0x4C, 0x20, 0x2B, 0x20, 0x53, 0x48, 0x49, 0x46, 0x54, 0x20, 0x2B, 0x20, 0x53, 0x00,//save map as - CTRL + SHIFT + S
    0x43, 0x54, 0x52, 0x4C, 0x20, 0x2B, 0x20, 0x4E, 0x00,//new map - CTRL + N
    0x43, 0x54, 0x52, 0x4C, 0x20, 0x2B, 0x20, 0x4F, 0x00,//open map - CTRL + O
    0x43, 0x54, 0x52, 0x4C, 0x20, 0x2B, 0x20, 0x53, 0x00,//save map - CTRL + S
    0x46, 0x00,//color tiles - F
    0x51, 0x00,//tile group - Q
    0x58, 0x00,//cut - X
    0x43, 0x00,//copy - C
    0x56, 0x00,//paste - V
    0x52, 0x00,//tile debug - R
    0x45, 0x00,//copy color - E
    0x50, 0x00,//set background color - P
    0x4F, 0x00,//background lins - O
    0x57, 0x00,//up - W
    0x41, 0x00,//left - A
    0x53, 0x00,//down - S
    0x44, 0x00,//right - D
    0x44, 0x45, 0x4C, 0x45, 0x54, 0x45, 0x00,//delete tiles - DELETE
  };
  
  tmpFile[0] = (byte)(_FILEVERSION_SETTINGS_ >> 8);//upper byte
  tmpFile[1] = (byte)_FILEVERSION_SETTINGS_;//lower byte
  
  tmpFile = concat(tmpFile, magicToArray());

  saveBytes(settingsFile, tmpFile);//save the file
}

void FileLoadSettings(){//load map from file
  noLoop();//dont allow drawing
  byte[] settingsFile = loadBytes("settings.set");//temporary array
  
  String magic = "";
  //println(mapFile.length);
  for(int l = 0; l < _magicText.length(); l++){
    magic += (char)settingsFile[(settingsFile.length - _magicText.length()) + l];
  }
  
  if(!magic.equals(_magicText)){//is the file ours
    //loadingMap = false;//since this file was not ours we're no longer loading a map
    //println("not ours");
    loop();
    return;//file was not one of ours
  }
  
  int fileVersion;//what file version is the file
  
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////FILE METADATA
  //File Version
  fileVersion = int(settingsFile[0] << 8);//upper byte
  fileVersion |= int(settingsFile[1]);//lower byte
  //println("Settings Version - " + fileVersion);
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////FILE METADATA
  
  if(fileVersion == 0){//whats the file version
    int position = 2;
    
    //Load Map Tiles
    for(int i = 0; i < keyBinds.length; i++){//Loop through all the rows
      keyBinds[i] = new String();
      keyBinds[i] = "";
      while(position < settingsFile.length && settingsFile[position] != 0){
        //print(char(settingsFile[position]));
        keyBinds[i] += char(settingsFile[position]);
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