final int _DEBUG_ = -1;//what are we debugging
final int _DEBUGAMOUNT_ = 5000000;//5000000;//how many are we debugging

void debug(){
  if(_DEBUG_ == 0){
    for(int i = 0; i < _DEBUGAMOUNT_; i++){
      //mapTiles.get((int)random(256)).get((int)random(256)).add(new mTile((int)random(tileMaps.get(tileMapShow).numImages),(int)random(256),(int)random(256),(int)random(256), (int)random(2)==1));//(int)random(256)
      //mapTiles.get((int)random(cols)).get((int)random(rows)).add(new mTile((int)random(tileMaps.get(tileMapShow).numImages),(int)random(256),(int)random(256),(int)random(256), (int)random(2)==1));//(int)random(256)
    }
  }
  
  if(_DEBUG_ == 1){
    icons.add(new clickableIcon(scl * 13, scl * 13, "maps/map10.ddj", "TEST"));
    icons.add(new clickableIcon(scl * 15, scl * 13, "maps/map10-1.ddj", "TEST2"));
    icons.add(new clickableIcon(scl * 17, scl * 13, "maps/map10-2.ddj", "TEST3"));
    icons.add(new clickableIcon(scl * 19, scl * 13, "maps/map10-3.ddj", "TEST4"));
    icons.add(new clickableIcon(scl * 13, scl * 15, scl * 7, scl, "maps/map10-3.ddj", "TEST4"));
  }
}

//color RED = new color(255,0,0);
PImage alphaBack;
PImage hueBack;

PGraphics tmpGradient;

GLabel redLabel;
GLabel greenLabel;
GLabel blueLabel;

GLabel hueLabel;
GLabel saturationLabel;
GLabel brightnessLabel;

GLabel alphaLabel;

void setupGradientLabels(){
  redLabel = new GLabel(this, 200, 200, 100, 16, "");
  greenLabel = new GLabel(this, 200, 220, 100, 16, "");
  blueLabel = new GLabel(this, 200, 240, 100, 16, "");
  
  hueLabel = new GLabel(this, 200, 270, 100, 16, "");
  saturationLabel = new GLabel(this, 200, 290, 100, 16, "");
  brightnessLabel = new GLabel(this, 200, 310, 100, 16, "");
  
  hueLabel.setIcon(hueBack, 1, null, null);
  
  alphaLabel = new GLabel(this, 200, 340, 100, 16, "");
}

void drawRedGradient(){
  tmpGradient.beginDraw();
  tmpGradient.noStroke();
  for(float i = 0; i <= 1; i+=0.02){
    tmpGradient.fill(lerpColor(color(0, green(currentTileColor), blue(currentTileColor)), color(255, green(currentTileColor), blue(currentTileColor)), i));
    tmpGradient.rect((i*100), 0, 2, 16);
  }
  tmpGradient.endDraw();
  //image(tmpGradient,200,200);
}

void drawGreenGradient(){
  tmpGradient.beginDraw();
  tmpGradient.noStroke();
  for(float i = 0; i <= 1; i+=0.02){
    tmpGradient.fill(lerpColor(color(red(currentTileColor), 0, blue(currentTileColor)), color(red(currentTileColor), 255, blue(currentTileColor)), i));
    tmpGradient.rect((i*100), 0, 2, 16);
  }
  tmpGradient.endDraw();
  //image(tmpGradient,200,220);
}

void drawBlueGradient(){
  tmpGradient.beginDraw();
  tmpGradient.noStroke();
  for(float i = 0; i <= 1; i+=0.02){
    tmpGradient.fill(lerpColor(color(red(currentTileColor), green(currentTileColor), 0), color(red(currentTileColor), green(currentTileColor), 255), i));
    tmpGradient.rect((i*100), 0, 2, 16);
  }
  tmpGradient.endDraw();
  //image(tmpGradient,200,240);
}

//void drawHueGradient(){
//  //for(float i = 0; i <= 1.01; i+=0.01){
//  //  //if(i < 0.16){
//  //  //  fill(lerpColor(RED, YELLOW, map(i, 0.0, 0.16, 0.0, 1.0)));
//  //  //}else if(i >= 0.16 && i < 0.32){
//  //  //  fill(lerpColor(YELLOW, GREEN, map(i, 0.16, 0.32, 0.0, 1.0)));
//  //  //}else if(i >= 0.32 && i < 0.48){
//  //  //  fill(lerpColor(GREEN, CYAN, map(i, 0.32, 0.48, 0.0, 1.0)));
//  //  //}else if(i >= 0.48 && i < 0.64){
//  //  //  fill(lerpColor(CYAN, BLUE, map(i, 0.48, 0.64, 0.0, 1.0)));
//  //  //}else if(i >= 0.64 && i < 0.8){
//  //  //  fill(lerpColor(BLUE, MAGENTA, map(i, 0.64, 0.8, 0.0, 1.0)));
//  //  //}else{
//  //  //  fill(lerpColor(MAGENTA, RED, map(i, 0.8, 1.0, 0.0, 1.0)));
//  //  //}
//  //  colorMode(HSB, 255);
//  //  color hue = color(i*255, 255, 255);
//  //  colorMode(RGB, 255);
//  //  fill(hue);
//  //  noStroke();
//  //  rect(200 + (i*100), 270, 1, 16);
//  //}
//  image(hueBack, 200, 270);
//}

void drawSaturationGradient(){
  colorMode(HSB, 255);
  color lowSat = color(hue(currentTileColor), 0, brightness(currentTileColor));
  color highSat = color(hue(currentTileColor), 255, brightness(currentTileColor));
  colorMode(RGB, 255);
  tmpGradient.beginDraw();
  tmpGradient.noStroke();
  for(float i = 0; i <= 1; i+=0.02){
    tmpGradient.fill(lerpColor(lowSat, highSat, i));
    tmpGradient.rect((i*100), 0, 2, 16);
  }
  tmpGradient.endDraw();
  //image(tmpGradient,200,290);
}

void drawBrightnessGradient(){
  colorMode(HSB, 255);
  color lowBright = color(hue(currentTileColor), saturation(currentTileColor), 0);
  color highBright = color(hue(currentTileColor), saturation(currentTileColor), 255);
  colorMode(RGB, 255);
  tmpGradient.beginDraw();
  tmpGradient.noStroke();
  for(float i = 0; i <= 1; i+=0.02){
    tmpGradient.fill(lerpColor(lowBright, highBright, i));
    tmpGradient.rect((i*100), 0, 2, 16);
  }
  tmpGradient.endDraw();
  //image(tmpGradient,200,310);
}

void drawAlphaGradient(){
  tmpGradient.beginDraw();
  tmpGradient.noStroke();
  tmpGradient.clear();
  tmpGradient.image(alphaBack, 0, 0);
  for(float i = 0; i <= 1; i+=0.020001){
    tmpGradient.fill(color(red(currentTileColor), green(currentTileColor), blue(currentTileColor), i*255));
    tmpGradient.rect((i*100), 0, 2, 16);
    //println(i*100);
  }
  tmpGradient.endDraw();
  //image(tmpGradient,200,340);
}