//------------------------------------------------------




//--------------------------------------------------------------------------------------////////Change these
color c_wire= color (50);
float sw_wire= 0.5;
//--------------------------------------------------------------------------------------////////////////////




//------------------------------------------------------
//Global Parameter:
//------------------------------------------------------
float ISO= 0.3f;
float BRUSHSIZE= 1;
float BRUSHSIZE_MIN= 5;

float BRUSHSIZE_MAX= 20;

int GRID_SIZE= 10; //resolution of the mesh (size of the array, resolusion of the voxel)
boolean BLN_Wire= false;
boolean BLN_RENDERTRAIL_PTS= false;

int ISO_DISPLAY=0;

//------------------------------------------------------
//Iso:
//------------------------------------------------------

import toxi.geom.mesh.TriangleMesh;
import toxi.volume.ArrayIsoSurface;
import toxi.volume.RoundBrush;
import toxi.volume.VolumetricBrush;
import toxi.volume.VolumetricSpaceArray;
import toxi.processing.*;

ArrayList<myIsoPt> isoPts;

VolumetricSpaceArray volume;
ArrayIsoSurface surface;
VolumetricBrush brush;

TriangleMesh mesh= new TriangleMesh("mesh1");

ToxiclibsSupport gfx;

Vec3D SCALE= new Vec3D (wWidth, hHeight, dDepth); //scale of the world


//------------------------------------------------------
//Global Function _Iso:
//------------------------------------------------------
void setupIsoMesh() {
  //initiate iso classes
  volume= new VolumetricSpaceArray(SCALE, int(wWidth/GRID_SIZE), int(hHeight/GRID_SIZE), int(dDepth/GRID_SIZE));
  surface= new ArrayIsoSurface(volume);
  brush= new RoundBrush(volume, SCALE.x/2);

  isoPts= new ArrayList<myIsoPt>();

  gfx= new ToxiclibsSupport(this);
}

//------------------------------------------------------
void drawIsoMesh() {
  collectTrailPts();
  createIsoBasePts();

  //lights();

  volume= new VolumetricSpaceArray(SCALE, int(wWidth/GRID_SIZE), int(hHeight/GRID_SIZE), int(dDepth/GRID_SIZE));
  surface= new ArrayIsoSurface(volume);
  brush= new RoundBrush(volume, SCALE.x/2);

  volume.clear();

  for (myIsoPt p: isoPts) {
    p.run();
  }

  volume.closeSides();
  surface.reset();
  surface.computeSurfaceMesh(mesh, ISO);


  /*if (BLN_Wire == false) {
   stroke(c_wire);
   fill(255);
   strokeWeight(sw_wire);
   }
   else {
   stroke(c_wire);
   noFill();
   strokeWeight(sw_wire);
   }*/


  switch (ISO_DISPLAY) {
  case 0:
    lights();
    stroke(c_wire);
    fill(255);
    strokeWeight(sw_wire);
    gfx.mesh(mesh, true); //true
    break;

  case 1:
    drawFaces(true);
    break;

  case 2:
    drawFaces(false);
    break;

  case 3:
    lights();
    noStroke();
    fill(255);
    gfx.mesh(mesh, true); //true
    break;

  case 4:
    stroke(c_wire);
    noFill();
    strokeWeight(sw_wire);
    gfx.mesh(mesh, true); //true
    break;
  }
}


//------------------------------------------------------
//Global Function:
//------------------------------------------------------
ArrayList agentCollection_ple_trail;

void collectTrailPts() {
  agentCollection_ple_trail= new ArrayList ();
  for (int i=0; i<agentCollection_ple.size(); i++) {
    myPleAgent a= (myPleAgent) agentCollection_ple.get(i);
    for (int j = 0; j < a.trail.size(); j++) {  

      Vec3D t= (Vec3D) a.trail.get(j);
      agentCollection_ple_trail.add(t);
    }
  }
  //println(agentCollection_ple_trail.size());
}

//------------------------------------------------------
void createIsoBasePts() {
  isoPts= new ArrayList();
  for (int i=0; i<agentCollection_ple_trail.size(); i++) {
    Vec3D loc= (Vec3D) agentCollection_ple_trail.get(i);
    myIsoPt p= new myIsoPt(loc);
    isoPts.add(p);
  }
}

//------------------------------------------------------
//Class:
//------------------------------------------------------

class myIsoPt {
  Vec3D loc;
  float sw;

  float sw_min= 4;
  float sw_max= 30;

  float brushSize_rel;

  myIsoPt(Vec3D _loc) {
    loc= _loc;

    sw= 15;
    brushSize_rel= sw; //relative brush size
  }

  void run() {

    //if (blnIso == true) {
    scaleByAttractors();
    // }

    if (BLN_RENDERTRAIL_PTS == true) { //Render mesh trail points / true=on, false=off
      stroke(234, 170, 200, 150); //mesh trail color
      strokeWeight(sw);
      point(loc.x, loc.y, loc.z);
    }

    if (blnIso == true) {           
      brushSize_rel= map (sw, sw_min, sw_max, sw_min *3, sw_max *3 );
      brush.setSize(brushSize_rel*BRUSHSIZE); //size of 80
      brush.drawAtAbsolutePos(loc, 1); //density of 1
      updateFaces();
      //blnIso= false;
    }
  }


  void scaleByAttractors() {
    sw_min= BRUSHSIZE_MIN;
    sw_max= BRUSHSIZE_MAX;

    myPleAgent att= closestAgent(Collection_ar);

    float dist= loc.distanceTo(att.loc);
    //float mag= att.attRadius;

    if (dist > 0 && dist < 200) {
      sw= map (dist, 0, 200, sw_max, sw_min);
    }
    else {
      sw= 4;
    }
  }

  myPleAgent closestAgent(ArrayList boids) {

    float cloDist = 1000000;
    int cloId = 0;

    for (int i = 0; i < boids.size(); i ++) {
      myPleAgent pa  = (myPleAgent)boids.get(i);
      float d = loc.distanceTo(pa.loc);
      if (d < cloDist && d > 0) {
        cloDist = d;
        cloId = i;
      }
    }    
    myPleAgent closestpa  = (myPleAgent)boids.get(cloId);

    return closestpa;
  }
}

//------------------------------------------------------
//------------------------------------------------------
