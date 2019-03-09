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