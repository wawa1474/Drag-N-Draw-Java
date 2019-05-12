/*
do we switch all custom buttons and sliders to G4P
or redo custom image buttons with controlP5

label color sliders
add alpha slider
add hex color number input/output
add hsv color number input/output


redo how context switching is done
  make a menu system

make it so the user can resize the map field

add menu bar in order to clean up ui
  file, edit, view, history?, tools, help

change file drop down "exit" to "quit"
add edit drop down "delete"

get rid of number things in ui?
  total tiles
  drawn tiles
  mouse xy
  screen xy

clean up keyboard mappings
  dont use ctrl + alt as that messes up international key boards
  figure out how to make them remappable
  have alt + key binds
    file = alt + f
    edit = alt + e
    etc.
  have complex key binds
    save map = ctrl + s
    export image ?= ctrl + shift + e
    new map = ctrl + n
    open map = ctrl + o
    cut = ctrl + x
    copy = ctrl + c
    paste = ctrl + v

Player Flayer will be a character creator
Tile N' Style will make tile maps and the necessary meta data files
Villager Pillager will make NPCs and monsters
Drag N' Draw will make the map files
Roll N' Play will be a role-playing game

redo tile map system
  allow multiple tile maps at once
  redo how they are shown and used by user
  change tile image changing to somehow free up mouse wheel

make "tool" system
  recolor tool (currently right-click) would be a selectable tool
  place tile (currently left-click) would be a selectable tool
  place color tile (currently middle-click) would be a selectable tool
  anything else? group selection tool maybe instead of a button?

use a pallette based color system to compress color data?
  256 or 65536 color pallette

for icons have a settable color (16 colors?)
  and maybe make it so there's no color border?

Try loading tile map based on name
if that fails try loading by location
if that fails throw error

hexagon tiles?
  //pushMatrix();
  //translate(scl * 4.5, scl * 4.5);
  ////rotate(frameCount / -100.0);
  //polygon(-(scl), -(scl/2), scl/2, 6);  // Hexagon
  //polygon(0, 0, scl/2, 6);  // Hexagon
  //polygon(scl, scl/2, scl/2, 6);  // Hexagon
  //popMatrix();
  //fill(0);
  //if (mousePressed) {
  //  drawHexagon2(scl * 4.5, scl * 4.5, scl/2);
  //}
  //else {
  //  drawHexagon(scl * 4.5, scl * 4.5, scl/2);
  //}
  
//void polygon(float x, float y, float radius, int npoints) {
//  float angle = TWO_PI / npoints;
//  fill(BLACK);
//  beginShape();
//  for (float a = 0; a < TWO_PI; a += angle) {
//    float sx = x + cos(a) * radius;
//    float sy = y + sin(a) * radius;
//    vertex(sx, sy);
//  }
//  endShape(CLOSE);
//}


//void drawHexagon(float x, float y, float radius) {
//  pushMatrix();
//  translate(x, y);
//  beginShape();
//  for (int i = 0; i < 6; i++) {
//    pushMatrix();
//    float angle = PI*i/3;
//    vertex(cos(angle) * radius, sin(angle) * radius);
//    popMatrix();
//  }
//  endShape(CLOSE);
//  popMatrix();
//}

//void drawHexagon2(float x, float y, float radius) {
//  pushMatrix();
//  translate(x, y);
//  rotate(PI/6.0);
//  beginShape();
//  for (int i = 0; i < 6; i++) {
//    pushMatrix();
//    float angle = PI*i/3;
//    vertex(cos(angle) * radius, sin(angle) * radius);
//    popMatrix();
//  }
//  endShape(CLOSE);
//  popMatrix();
//}
*/