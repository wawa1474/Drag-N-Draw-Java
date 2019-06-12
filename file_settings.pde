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

final int keyBind_saveCanvas = 0;
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
  
  if(fileVersion == 0){//whats the file version{//we don't know that file version
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
  }else{
    println("Settings Version Error (Loading).");//throw error
  }
  //printArray(keyBinds);
  loop();//allow drawing
}//void FileLoadMap() END