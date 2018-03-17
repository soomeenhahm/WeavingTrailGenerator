//written by Soomeen Hahm & Igor Pantic, March 2014 
//written for the Complex Morphologies workshop, Faculty of Architecture, University of Belgrade
//Modified and used on project TechKnit, RC6, AD, Bartlett, UCL, 2014

//SOOMEENHAHM.com, London UK 


//you can change this to record the animation every nth frame:
int intFInterval= 1; 


//------------------------------------------------------------------------------------------------------------////////Change these
//------------------------------------------------------
int wWidth= 1500;
int hHeight= 720;
int dDepth = 450;

boolean blnDrawBox= false;

int pop_p= 100; //population of agents
int pop_a= 1; //population of attractor
int pop_r= 1; //population of repeller

Vec3D GRAVITY= new Vec3D (-0.1, 0, 0); // Gravity Z
//Vec3D GRAVITY= new Vec3D (-0.1, 0, 0); // Gravity X

float THR_TRAIL= 30; //trail connection threshold

color c_trailCon= color (155, 100); //Trail connection colors
float sw_trailCon= 0.5;

String fileAttractor= "input/Attractor.txt";  //"input/Attractor.txt" When file is empty, creates "pop_a" amount of random attractors;
String fileRepeller= "input/Repeller.txt"; //"input/Repeller.txt"

int INT_ADDAGENT= 100; //add new agents in which intervals
int POP_NEW= 1; //add how many new agents
int POP_LIMIT= 999999; //limit of ple-agent population
//------------------------------------------------------
//------------------------------------------------------------------------------------------------------------////////////////////


import plethora.core.*;

import toxi.geom.*;
import toxi.geom.mesh.*;
import peasy.*;
import toxi.physics.*;
import toxi.physics.constraints.*;
import toxi.physics.behaviors.*;

ArrayList agentCollection_mesh;
ArrayList agentCollection_ple;
ArrayList agentCollection_ple1;//Ple_Agent
ArrayList agentCollection_ple3;
ArrayList agentCollection_ple2;



ArrayList agentCollection_att; //Attractor
ArrayList agentCollection_rep; //Repeller
ArrayList Collection_ar; //Attractor + Repeller

ArrayList locCollection_att;
ArrayList locCollection_rep;

PeasyCam cam;
VerletPhysics physics;

boolean blnPhysics = true;
boolean blnUpdate = true;
boolean blnIso = false;
boolean blnOrigin= false;
boolean blnLineBetween= false;
boolean isRecord = false;

boolean BLN_REFRESH= false;

boolean recordImg = false;
boolean recordAnimation = false;

//------------------------------------------------------
void setup() {
  size(2480, 1520, P3D);
  //colorMode(HSB);
  smooth();
  initLight();

  //cam= new PeasyCam(this, 0, 0, 0, 800);
  cam= new PeasyCam(this, 0, 0, 122, 1100);
  /*cam.rotateX (1.770);
   cam.rotateY (1.091);
   cam.rotateZ (2.921);
   */
 // cam.pan(-138, 0);

  setupGUI();
  setupIsoMesh();
  createPhysics();

  LineCollection = new ArrayList ();

  locCollection_att= ImportText(fileAttractor); 
  createAttractors();

  locCollection_rep= ImportText(fileRepeller);
  createRepellers();

  createARcollection();

  createPleAgents();
}

//------------------------------------------------------

void draw() {
  background(255);
  drawLight();
  //println (cam.getRotations());

  /*
  //Draw agents in interval
   if (frameCount % INT_ADDAGENT == 0) {
   if (agentCollection_ple.size() < POP_LIMIT) {
   addPleAgents();
   }
   }
   */

  //GravityOnOff(100);


  if (BLN_REFRESH == true) {
    createPhysics();

    createAttractors();
    createRepellers();
    createARcollection();    
    createPleAgents();    

    BLN_REFRESH= false;
  }

  if (blnUpdate == true) {
    if (blnPhysics == true) {
      physics.update();
    }

    updateAttAgents();
    updateRepAgents();
    updatePleAgents();
    updatePleAgents1();
  }

  if (blnOrigin == true) {
    drawOrigin();
  }

  drawTrailConnection();

  drawAttAgents();
  drawRepAgents();
  drawPleAgents();

  //drawSpring();
  //drawParticle();

  drawIsoMesh();

  if (blnDrawBox == true) {
    drawBox();
  }
  drawGUI();

  exportAgentTail(agentCollection_ple);
  exportAgentLoc(agentCollection_att);


  // RECORD ANIMATION-------------------------------------

  if (key == 'a') {
    recordAnimation = true;
  }
  if (recordAnimation == true) { 
    save("output/animation/img" + frameCount + ".jpg");
    println("recording frame_" + frameCount);
  }
  //------------------------------------------------------

  if (recordImg == true) { 
    if (frameCount%intFInterval == 0) {
      save("output/images/img" + frameCount + ".jpg");
      println("printing image_" + frameCount);
    }
  }
}


//------------------------------------------------------
//Additional Functions:
//------------------------------------------------------

/*
void GravityOnOff(int interval) {
 
 if ((frameCount % interval == 0) && (frameCount % interval*2 == 0)) {
 STR_GRAVITY = 0;
 println (STR_GRAVITY);
 }
 else if ((frameCount % interval == 0) && (frameCount % interval*2 != 0)) {
 STR_GRAVITY = 1;
 println (STR_GRAVITY);
 }
 }
 */

//------------------------------------------------------




//------------------------------------------------------
//Creators:
//------------------------------------------------------

void createPleAgents() {

  agentCollection_ple= new ArrayList();
  for (int i=0; i< pop_p; i++) {
    Vec3D loc= new Vec3D (-wWidth/2, random(100, 200), random(-35, -115)); //desen
    myPleAgent a= new myPleAgent(this, loc);  
    agentCollection_ple.add(a);
  }
  agentCollection_ple2= new ArrayList();
  for (int i=0; i< pop_p; i++) {
    Vec3D loc= new Vec3D (-wWidth/2, random(-200, -100), random(-35, -115)); //desen
    myPleAgent a= new myPleAgent(this, loc);  
    agentCollection_ple.add(a);
  }
  //-------------------------------------------
  agentCollection_ple1= new ArrayList();
  for (int i=0; i< pop_p; i++) {
    Vec3D loc= new Vec3D (wWidth/2, random(-80, 80), random(-80, 80)); // centralen
    myPleAgent a= new myPleAgent(this, loc);  
    agentCollection_ple1.add(a);
  }


  agentCollection_ple3= new ArrayList();
  for (int i=0; i< pop_p; i++) {
    Vec3D loc= new Vec3D (-wWidth/3, random(-60, 60), random(-185, -265)); //lqv
    myPleAgent a= new myPleAgent(this, loc);  
    agentCollection_ple.add(a);
  }
}

//------------------------------------------------------

/*
void addPleAgents() {
 for (int i=0; i< POP_NEW; i++) {
 Vec3D loc= new Vec3D (random(-wWidth/2, wWidth/2), random(-hHeight/2, hHeight/2), dDepth/2);
 myPleAgent a= new myPleAgent(this, loc);  
 agentCollection_ple.add(a);
 }
 }
 */

//------------------------------------------------------


void createAttractors() {
  agentCollection_att= new ArrayList();

  if (locCollection_att.size() > 0) {
    pop_a= locCollection_att.size();
  }

  for (int i=0; i< pop_a; i++) {
    Vec3D loc;
    if (locCollection_att.size() > 0) {
      loc= (Vec3D) locCollection_att.get(i);
    }
    else {
      loc= new Vec3D (random(-wWidth/2, wWidth/2), random(-hHeight/2, hHeight/2), random(-dDepth/2, dDepth/2));
    }

    myAttractor a= new myAttractor(this, loc); 
    agentCollection_att.add(a);
  }
}

//------------------------------------------------------

void createRepellers() {
  agentCollection_rep= new ArrayList();

  if (locCollection_rep.size() > 0) {
    pop_r= locCollection_rep.size();
  }

  for (int i=0; i< pop_r; i++) {
    Vec3D loc;
    if (locCollection_rep.size() > 0) {
      loc= (Vec3D) locCollection_rep.get(i);
    }
    else {
      loc= new Vec3D (random(-wWidth/2, wWidth/2), random(-hHeight/2, hHeight/2), random(-dDepth/2, dDepth/2));
    }

    myRepeller a= new myRepeller(this, loc); 
    agentCollection_rep.add(a);
  }
}

//------------------------------------------------------

void createARcollection() {
  Collection_ar= new ArrayList();
  Collection_ar.addAll(agentCollection_att);
  Collection_ar.addAll(agentCollection_rep);
  println(Collection_ar.size());
}

//------------------------------------------------------

void createPhysics() {
  physics= new VerletPhysics();
  physics.addBehavior(new GravityBehavior(GRAVITY));
  physics.setDrag(0.05f);
  physics.setWorldBounds (new AABB(new Vec3D(0, 0, 0), new Vec3D(wWidth/2, hHeight/2, dDepth/2)));
}


//------------------------------------------------------
//Updaters:
//------------------------------------------------------

void updatePleAgents() {
  for (int i=0; i<agentCollection_ple.size(); i++) {
    myPleAgent a= (myPleAgent) agentCollection_ple.get(i);
    a.run();
  }
}

void updatePleAgents1() {
  for (int i=0; i<agentCollection_ple1.size(); i++) {
    myPleAgent a= (myPleAgent) agentCollection_ple1.get(i);
    a.run1();
  }
}


//------------------------------------------------------

void updateAttAgents() {
  for (int i=0; i<agentCollection_att.size(); i++) {
    myPleAgent a= (myPleAgent) agentCollection_att.get(i);
    a.run();
  }
}

//------------------------------------------------------

void updateRepAgents() {
  for (int i=0; i<agentCollection_rep.size(); i++) {
    myPleAgent a= (myPleAgent) agentCollection_rep.get(i);
    a.run();
  }
}

//------------------------------------------------------


//------------------------------------------------------

void drawPleAgents() {
  for (int i=0; i<agentCollection_ple.size(); i++) {
    myPleAgent a= (myPleAgent) agentCollection_ple.get(i);
    a.render();
  }
  for (int i=0; i<agentCollection_ple1.size(); i++) {
    myPleAgent a= (myPleAgent) agentCollection_ple1.get(i);
    a.render();
  }
}


//------------------------------------------------------

void drawAttAgents() {
  for (int i=0; i<agentCollection_att.size(); i++) {
    myPleAgent a= (myPleAgent) agentCollection_att.get(i);
    a.render();
  }
}

//------------------------------------------------------

void drawRepAgents() {
  for (int i=0; i<agentCollection_rep.size(); i++) {
    myPleAgent a= (myPleAgent) agentCollection_rep.get(i);
    a.render();
  }
}

//------------------------------------------------------



void drawBox() {
  stroke(0);
  strokeWeight(1);
  noFill();
  box(wWidth, hHeight, dDepth);
}

//------------------------------------------------------

void drawOrigin() {
  stroke(255, 100, 100);
  strokeWeight(1);
  line(0, 0, 0, 100, 0, 0);
  line(0, 0, 0, 0, 100, 0);
  line(0, 0, 0, 0, 0, 100);
}

//------------------------------------------------------

void drawSpring() {

  for (int i=0; i< physics.springs.size(); i++) {
    VerletSpring s= (VerletSpring) physics.springs.get (i);
    stroke(155, 100);
    strokeWeight(1);
    line(s.a.x, s.a.y, s.a.z, s.b.x, s.b.y, s.b.z);
  }
}

//------------------------------------------------------

void drawParticle() {

  for (int i=0; i< physics.particles.size(); i++) {
    VerletParticle p= (VerletParticle) physics.particles.get (i);
    stroke(0, 255, 200);
    strokeWeight(2);
    point (p.x, p.y, p.z);
  }
}

//------------------------------------------------------
//Trail Connection
//------------------------------------------------------
ArrayList LineCollection;

void updateTrailConnection(float threshold) {
  LineCollection = new ArrayList ();

  if (agentCollection_ple_trail.size() > 0) {
    for (int i=0; i<agentCollection_ple_trail.size(); i++) {
      Vec3D loc= (Vec3D) agentCollection_ple_trail.get(i);

      for (int j=0; j<agentCollection_ple_trail.size(); j++) {
        Vec3D other= (Vec3D) agentCollection_ple_trail.get(j);

        if (loc != other) {
          float dist= loc.distanceTo (other);
          if (dist < threshold) {

            LineCollection.add(loc);
            LineCollection.add(other);
          }
        }
      }
    }
  }
}

//------------------------------------------------------
boolean blUpdateT= false;

void drawTrailConnection() {

  //if (blnLineBetween = true && blUpdateT == false) {
  //   updateTrailConnection(THR_TRAIL);

  //  blUpdateT= true;
  //}

  if (LineCollection.size() > 0) {
    for (int i=0; i<LineCollection.size(); i += 2) {
      Vec3D loc= (Vec3D) LineCollection.get(i);
      Vec3D other= (Vec3D) LineCollection.get(i+1);

      stroke(c_trailCon);
      strokeWeight(sw_trailCon);
      line(loc.x, loc.y, loc.z, other.x, other.y, other.z);
    }
  }
}


//------------------------------------------------------
//Exporters:
//------------------------------------------------------
boolean blnPrintTail = false;
PrintWriter output;
void exportAgentTail(ArrayList agentCollection_ple) {
  if (blnPrintTail == true) {
    output = createWriter("output/Tails_" + frameCount + ".txt");

    for (int i=0; i<agentCollection_ple.size(); i++) {
      myPleAgent a= (myPleAgent) agentCollection_ple.get(i);
      String st= "";
      for (int j = 0; j < a.trail.size(); j++) {      
        Vec3D t= (Vec3D) a.trail.get(j);
        st= st + (t.x + "," + t.y + "," + t.z + ";");  // here we export the coordinates of the vector using String concatenation!
      }
      output.println(st);
    }

    output.flush();
    output.close();
    println("tail points have been exported");

    blnPrintTail= false;
  }
}


//------------------------------------------------------
boolean blnPrintPts = false;
PrintWriter output1;
void exportAgentLoc(ArrayList agentCollection_ple) {
  if (blnPrintPts == true) {
    output1 = createWriter("output/Points_" + frameCount + ".txt");

    for (int i=0; i<agentCollection_ple.size(); i++) {
      myPleAgent a= (myPleAgent) agentCollection_ple.get(i);
      output1.println(a.loc.x + "," + a.loc.y + "," + a.loc.z);
    }

    output1.flush();
    output1.close();
    println("point locs have been exported");

    blnPrintPts= false;
  }
}

//------------------------------------------------------
//Importers:
//------------------------------------------------------
ArrayList ImportText(String fileName) {
  ArrayList collection= new ArrayList();
  String lines[]= loadStrings(fileName);
  for (int i=0; i<lines.length; i++) {
    float values[]= float(lines[i].split(","));
    Vec3D loc= new Vec3D(values[0], -values[1], values[2]);

    collection.add(loc);
  }

  return collection;
}

//------------------------------------------------------

void keyPressed() {
  if (key == 'i') {

    recordImg = !recordImg;
  }

  if (key == 'r' ) {
    isRecord = !isRecord;
  }
  if (isRecord) {
    saveFrame ("data/image" + frameCount + ".png");
  }

  if (key == 'p') {
    blnPhysics = !blnPhysics;
  }

  if (key == 'x') {
    blnPrintPts = !blnPrintPts;
  }


  if (key == 'b') {
    blnDrawBox= !blnDrawBox;
  }

  if (key == 'e' ) {
    exportTrail();
    exportTrail1();
    exportTrail3();
  }
}