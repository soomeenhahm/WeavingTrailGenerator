
PVector l[];//lights stored as vectors
float str;
void initLight() {//by Marius Watz
  randomSeed(11);
  l=new PVector[7];
  for (int i=0; i<l.length; i++) {
    str=random(TWO_PI);
    l[i]=new PVector(cos(str)*10, 0.3, sin(str)*10);
  }
  str=random(120, 180);
}


void drawLight() {
  for (int i=0; i<l.length; i++) {
    directionalLight(str, str, str, l[i].x, l[i].y, l[i].z);//all the lights
  }
}

ArrayList meshFaces;

void updateFaces() {
  meshFaces= new ArrayList();
  if (mesh.faces.size() > 0) {
    for (int i=0; i< mesh.faces.size(); i++) {
      Face f =(Face)mesh.faces.get(i);
      meshFaces.add(f);
    }
  }
}

void drawFaces(boolean BLN_Wire) {
  //fill (random(255), 150, 150, 100);
  noStroke();

  if (mesh.faces.size() > 0) {
    beginShape(TRIANGLES);
    for (int i=0; i< meshFaces.size(); i++) {
      Face f =(Face)meshFaces.get(i);

      // create vertices for each corner point

      float sc= 0.008;
      float a= 1;
      float vNoise= noise(f.a.x * sc +a, f.a.y * sc +a, f.a.z * sc +a);
      fill(vNoise*50, vNoise*255, 255);  //----------------------------------------------------------Change here

      if (BLN_Wire == false) {
        noStroke();
      }
      else {
        stroke(c_wire);
        fill(vNoise*50, vNoise*255, 255);  //----------------------------------------------------------Change here
        strokeWeight(sw_wire);
      }

      //stroke(c_wire);
      //strokeWeight(sw_wire);

      vertex(f.a);
      vertex(f.b);
      vertex(f.c);
    }
    endShape(CLOSE);
  }
}

void vertex(Vec3D v) {
  vertex(v.x, v.y, v.z);
}
