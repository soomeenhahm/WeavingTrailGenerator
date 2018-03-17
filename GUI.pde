//------------------------------------------------------
//GUI:
//------------------------------------------------------

import controlP5.*;
ControlP5 ui;


//------------------------------------------------------

void setupGUI() {

  ui= new ControlP5(this);

  ui.setColorForeground (color (150));
  ui.setColorBackground (color (200));
  ui.setColorActive (color (240));
  ui.setColorCaptionLabel(color (0));
  ui.setColorValueLabel(color (0));

  int pos= 20;
  int posint= 15;  

  int sLength= 150;
  int sHeight= 14;

  //------------------------------------------------------
  //Flock:

  ui.addSlider("STR_FLOCK", 0, 1, STR_FLOCK, 20, pos, sLength, sHeight);

  pos += posint;
  ui.addSlider("MAXSPEED", 0.1, 50, MAXSPEED, 20, pos, sLength, sHeight);

  pos += posint;
  ui.addSlider("STR_GRAVITY", 0, 10, STR_GRAVITY, 20, pos, sLength, sHeight);

  pos += posint;
  ui.addSlider("DES_COH", 1, 300, DES_COH, 20, pos, sLength, sHeight);

  pos += posint;
  ui.addSlider("STR_COH", 0.001, 5, STR_COH, 20, pos, sLength, sHeight);

  pos += posint;
  ui.addSlider("DES_ALI", 1, 300, DES_ALI, 20, pos, sLength, sHeight);

  pos += posint;
  ui.addSlider("STR_ALI", 0.001, 5, STR_ALI, 20, pos, sLength, sHeight);

  pos += posint;
  ui.addSlider("DES_SEP", 1, 300, DES_SEP, 20, pos, sLength, sHeight);

  pos += posint;
  ui.addSlider("STR_SEP", 0.001, 5, STR_SEP, 20, pos, sLength, sHeight);

  pos += posint;
  ui.addSlider("AGE_LIMIT", 100, 1000000, AGE_LIMIT, 20, pos, sLength, sHeight);

  //------------------------------------------------------
  //New Agent:

  pos += posint;

  pos += posint;
  ui.addSlider("INT_ADDAGENT", 1, 10000, INT_ADDAGENT, 20, pos, sLength, sHeight);

  pos += posint;
  ui.addSlider("POP_NEW", 1, 50, POP_NEW, 20, pos, sLength, sHeight);

  pos += posint;
  ui.addSlider("POP_LIMIT", 1000, 9999999, POP_LIMIT, 20, pos, sLength, sHeight);


  //------------------------------------------------------
  //Trail:
  pos += posint;

  pos += posint;
  ui.addButton("DrawTrail").setPosition(20, pos).setSize(sLength, sHeight);

  pos += posint;
  ui.addButton("DrawTrailPts").setPosition(20, pos).setSize(sLength, sHeight);

  pos += posint;
  ui.addSlider("TRAIL_INTERVAL", 1, 100, TRAIL_INTERVAL, 20, pos, sLength, sHeight);

  pos += posint;
  ui.addSlider("TRAIL_LENGTH", 10, 1200, TRAIL_LENGTH, 20, pos, sLength, sHeight);

  pos += posint;
  ui.addSlider("DYNAMIC_WEIGHT", 0, 1, DYNAMIC_WEIGHT, 20, pos, sLength, sHeight);



  //------------------------------------------------------
  //Attractors:

  pos += posint;

  pos += posint;
  ui.addButton("LockParticle").setPosition(20, pos).setSize(sLength, sHeight);

  pos += posint;
  ui.addSlider("ATTSTRENGTH_ATT", 0.01, 1, ATTSTRENGTH_ATT, 20, pos, sLength, sHeight);

  pos += posint;
  ui.addSlider("ATTSTRENGTH_REP", 0.01, 1, ATTSTRENGTH_REP, 20, pos, sLength, sHeight);

  pos += posint;
  ui.addSlider("ATTRADIUS_INTERVAL", 0.01, 2, ATTRADIUS_INTERVAL, 20, pos, sLength, sHeight);

  pos += posint;
  ui.addButton("Draw_Attractor_Radius").setPosition(20, pos).setSize(sLength, sHeight);




  //------------------------------------------------------
  //Iso:
  pos += posint;

  pos += posint;
  ui.addButton("IsoSurface").setPosition(20, pos).setSize(sLength, sHeight);

  pos += posint;
  ui.addButton("DisplayMode").setPosition(20, pos).setSize(sLength, sHeight);

  pos += posint;
  ui.addSlider("ISO", 0, 1, ISO, 20, pos, sLength, sHeight); //value, min, max, position_info * 4;

  pos += posint;
  ui.addSlider("BRUSHSIZE", 0.1, 3, BRUSHSIZE, 20, pos, sLength, sHeight);

  pos += posint;
  ui.addSlider("BRUSHSIZE_MIN", 1, 30, BRUSHSIZE_MIN, 20, pos, sLength, sHeight);

  pos += posint;
  ui.addSlider("BRUSHSIZE_MAX", 5, 100, BRUSHSIZE_MAX, 20, pos, sLength, sHeight);

  pos += posint;
  ui.addSlider("GRID_SIZE", 5, 30, GRID_SIZE, 20, pos, sLength, sHeight);



  //------------------------------------------------------
  //Trail Connection:

  pos += posint;

  pos += posint;
  ui.addSlider("THR_TRAIL", 3, 100, THR_TRAIL, 20, pos, sLength, sHeight);

  pos += posint;
  ui.addButton("Update_Trail_Connection").setPosition(20, pos).setSize(sLength, sHeight);



  //------------------------------------------------------
  //Global:
  pos += posint;
  pos += posint;


  pos += posint;

  pos += posint;
  ui.addButton("Update").setPosition(20, pos).setSize(sLength, sHeight);

  pos += posint;
  ui.addButton("Refresh").setPosition(20, pos).setSize(sLength, sHeight);



  //------------------------------------------------------
  //Exporter:

  pos += posint;

  pos += posint;
  ui.addButton("Export_STL").setPosition(20, pos).setSize(sLength, sHeight);

  pos += posint;
  ui.addButton("Export_Tail_Pts").setPosition(20, pos).setSize(sLength, sHeight);




  //------------------------------------------------------
  ui.setAutoDraw(false);
}

//------------------------------------------------------


void drawGUI() {    
  if (ui.isMouseOver()) {
    cam.setActive(false);
  } 
  else {
    cam.setActive(true);
  }   

  hint(DISABLE_DEPTH_TEST);//let processing stop calculate in 3D
  cam.beginHUD();
  noLights();
  ui.draw();
  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
}

//------------------------------------------------------
//Button Events:
//------------------------------------------------------

void Update() {
  blnUpdate = !blnUpdate;
}

void IsoSurface() {
  blnIso = !blnIso;
}

void Draw_Attractor_Radius() {
  BLN_DRAWRADIUS = !BLN_DRAWRADIUS;
}

void LockParticle() {
  BLN_lock= !BLN_lock;
}

void DrawTrail() {
  BLN_RENDERTRAIL= !BLN_RENDERTRAIL;
}

void Refresh() {
  BLN_REFRESH= !BLN_REFRESH;
}

void Export_STL() {
  mesh.saveAsSTL(sketchPath(mesh.name + ".stl"));    
  println("stl saved!");
}

void Export_Tail_Pts() {
  blnPrintTail = !blnPrintTail;
}

void WireFrame() {
  BLN_Wire= !BLN_Wire;
}

void Update_Trail_Connection() {
  updateTrailConnection(THR_TRAIL);
  blnLineBetween = !blnLineBetween;
}

void DrawTrailPts() {
  BLN_RENDERTRAIL_PTS= !BLN_RENDERTRAIL_PTS;
}

void DisplayMode() {
  if (ISO_DISPLAY<4) {
    ISO_DISPLAY ++ ;
  }
  else {
    ISO_DISPLAY=0;
  }
}
//------------------------------------------------------
