//------------------------------------------------------




//--------------------------------------------------------------------------------------------------////////Change these
//Global Parameter/Variables:
//------------------------------------------------------
float ATTRADIUS_MIN= -300;
float ATTRADIUS_MAX= 300;
//---------------------------------------------------------------------------------------------------////////////////////



float DES_COH= 80;
float STR_COH= 1;

float DES_ALI= 40;
float STR_ALI= 0.5;

float DES_SEP= 30;
float STR_SEP= 1.5;

float STR_FLOCK= 0.00;

float STR_GRAVITY= 0.01;


//------------------------------------------------------

float ATTRADIUS_INTERVAL= 0.1;

float MAXSPEED= 1;
int TRAIL_INTERVAL= 20;
int TRAIL_LENGTH= 200;

boolean BLN_lock= true;
boolean BLN_DRAWRADIUS= false;
boolean BLN_RENDERTRAIL= true;

float DYNAMIC_WEIGHT= 0;

int AGE_LIMIT= 100000; // Agent age limit (kills agens after time)



//------------------------------------------------------
//Class:
//------------------------------------------------------

class myPleAgent extends Ple_Agent {
  PApplet p5;
  VerletParticle p; 
  AttractionBehavior pAtt;

  color c;
  float sw;

  color c_trail;
  float sw_trail;

  float attStrength; //= -1.2f;  

  float attRadius_min_att; //0
  float attRadius_max_att; //300
  float attRadius_int; //interval 1
  float attRadius; //= 100;

  float targetForce_max= 0.2; //0 = no attraction from PleAgent

  float dWeight; //= 0.1; 
  float f_trailSegMax;

  boolean pLock;
  boolean blDisConnect= false;
  boolean blAscend=false;
  boolean bldrawTrail; //exist at all or not
  boolean blRenderTrail; //exist but render or not
  boolean bldrawRadius= BLN_DRAWRADIUS;

  int bounceType;
  //0= Bounce X,Y & Wrap Z start from top
  //1= Simple Bounce
  //2= Wrap and start from top
  //3= Simple Wrap
  //4= Bounce Y,Z & Wrap X start from left

  int ageLimit;
  int age;

  myPleAgent(PApplet _p5, Vec3D _loc) {
    super(_p5, _loc);

    maxspeed= 1;

    p= new VerletParticle(loc);
    physics.addParticle(p);

    pAtt= new AttractionBehavior(loc, attRadius, attStrength, 0.05f);
    physics.addBehavior(pAtt);

    initTail(100); // Tail lenght



    //-------------------------------------------------------------------------------------------------////////Change these
    //Local Parameter:
    //------------------------------------------------------
    c= color(234, 200, 170);
    sw= 6;

    c_trail= color (155, 100);
    sw_trail= 1;

    f_trailSegMax= 200; //Trail segment maximum length

    bldrawTrail= true;
    blRenderTrail= true;
    bldrawRadius= BLN_DRAWRADIUS;

    pLock= false;
    attStrength= 0;
    attRadius= 0;
    dWeight= 0;

    bounceType= 4;
    //0= Bounce X,Y & Wrap Z start from top
    //1= Simple Bounce
    //2= Wrap and start from top
    //3= Simple Wrap
    //4= Bounce Y,Z & Wrap X start from left

    ageLimit= AGE_LIMIT;
    age= int(random(AGE_LIMIT)); //0;

    //------------------------------------------------------
    //---------------------------------------------------------------------------------------------------////////////////////
  }

  //------------------------------------------------------
  //Updaters:
  //------------------------------------------------------
  void updateParameter() {
    attRadius_int= ATTRADIUS_INTERVAL; 
    attRadius_min_att= ATTRADIUS_MIN;
    attRadius_max_att= ATTRADIUS_MAX;

    maxspeed= MAXSPEED;
    //pLock= BLN_lock;
    dWeight= DYNAMIC_WEIGHT;
    blRenderTrail= BLN_RENDERTRAIL;

    ageLimit= AGE_LIMIT;
  }


  void run() {

    if (age < ageLimit) {
      updateParameter();

      if (blnUpdate == true) {
        if (pLock == false) {
          runPleAgent();
          runParticle();
          dynamicWeight(dWeight);

          runTrail();  //int startFrame, int endFrame, int frameInt
        }
        else {
          p.lock();
        }

        updateAttractorRadius();

        updateTail(1);
      }

      age ++;
    }

    else {
      agentCollection_ple.remove(this);
    }
  }
  
  void run1() {

    if (age < ageLimit) {
      updateParameter();

      if (blnUpdate == true) {
        if (pLock == false) {
          runPleAgent1();
          runParticle();
          dynamicWeight(dWeight);

          runTrail();  //int startFrame, int endFrame, int frameInt
        }
        else {
          p.lock();
        }

        updateAttractorRadius();

        updateTail(1);
      }

      age ++;
    }

    else {
      agentCollection_ple.remove(this);
    }
  }


  void render() {
    if (blRenderTrail == true) {
      renderTrail();
    }

    drawPoint();
    drawAttractorRadius();

    displayTailPoints(255, 255, 255, 200, 2, 0, 100, 200, 255, 4);
  }

  //------------------------------------------------------
  //Renderer:
  //------------------------------------------------------

  void drawPoint() {    
    stroke(c);
    strokeWeight(sw);
    point(loc.x, loc.y, loc.z);
  }

  //------------------------------------------------------
  //Trail Functions:
  //------------------------------------------------------

  void runTrail() {
    if (bldrawTrail == true) {
      //updateTail(10);
      if (blnUpdate == true) {
        dropTrail(TRAIL_INTERVAL, TRAIL_LENGTH);
      }
    }
  }

  //------------------------------------------------------

  void dropTrail(int every, int limit) {
    if (frameCount % every == 0) {
      trail.add(loc.copy());
    }
    if (trail.size() > limit) {
      trail.remove(0);
    }
  }


  //------------------------------------------------------

  void renderTrail() {
    stroke(c_trail);
    strokeWeight(sw_trail);
    drawTrail(f_trailSegMax);
  }

  //------------------------------------------------------

  void drawTail(float thMin, float thMax) {
    if (tail.length > 1) {
      for (int i = 1; i < tail.length; i++) {
        Vec3D v1 = (Vec3D) tail[i];
        Vec3D v2 = (Vec3D) tail[i-1];

        float d = v1.distanceTo(v2);
        if (d > thMin && d < thMax) {
          vLine(v1, v2);
        }
      }
    }
  }


  //------------------------------------------------------
  //Attractor Functions:
  //------------------------------------------------------

  void drawAttractorRadius() {
    if (bldrawRadius == true) {
      if (attRadius > 0) {
        if (dWeight > 0) {
          float alpha = map(abs(attStrength), 0, 0.5, 5, 50);
          //float alpha = 100;
          stroke(c, alpha);
          strokeWeight(attRadius);
          point(loc.x, loc.y, loc.z);
        }
      }
    }
  }


  //------------------------------------------------------

  void updateAttractorRadius() {

    if (attRadius <= attRadius_min_att) {
      blAscend = true;
    }
    if (attRadius >=  attRadius_max_att) {
      blAscend = false;
    }

    if (blAscend == false) {
      attRadius -= attRadius_int;
    }
    else if (blAscend == true) {
      attRadius += attRadius_int;
    }
  }

  //------------------------------------------------------
  //Particle Functions:
  //------------------------------------------------------

  void runParticle() {    
    if (dWeight > 0) {

      //bounceParticle();
    }
  }

  //------------------------------------------------------ //0= loc, 1= p

  void dynamicWeight(float dWeight) {

    Vec3D target= p.sub(loc);
    target.scaleSelf(dWeight);
    target.addSelf(loc);

    loc= target.copy();
    p.set(loc);
  }


  //------------------------------------------------------

  void bounceParticle() {
    if (p.z< -dDepth/2+10) {
      p.x= random(-wWidth/2, wWidth/2);
      p.y= random(-wWidth/2, wWidth/2);
      p.z= dDepth/2;
    }
  }

  //------------------------------------------------------
  //Ple Agent Functions:
  //------------------------------------------------------

  /*;
   float DES_COH= 80;
   float STR_COH= 1;
   
   float DES_ALI= 40;
   float STR_ALI= 0.5;
   
   float DES_SEP= 30;
   float STR_SEP= 1.5;
   
   float STR_FLOCK= 0.01;
   
   float STR_GRAVITY= 0.01;
   */

  // Here we add more functions to PleAgent

  void runPleAgent() {
    if (dWeight < 1) {
      flock(agentCollection_ple, DES_COH, DES_ALI, DES_SEP, STR_COH, STR_ALI, STR_FLOCK);

      //Gravity Z / up-down
      acc.scaleSelf(STR_FLOCK);
      acc.addSelf(1 * STR_GRAVITY, 0, 0);

      //Gravity X / left-right
      //acc.scaleSelf(STR_FLOCK);
      //acc.addSelf(STR_GRAVITY, 0, 0 );

      affectedByAttractors(targetForce_max);
      affectedByRepellers(targetForce_max);



      switch (bounceType) {
      case 0:
        bounceAgentXY(wWidth/2, hHeight/2, dDepth/2);  //Bounce X,Y & Wrap Z
        break;

      case 1:
        bounceSpace(wWidth/2, hHeight/2, dDepth/2);  //Simple Bounce
        break;

      case 2: 
        wrapPleAgent(wWidth/2f, hHeight/2f, dDepth/2f);  //Wrap and start from top
        break;

      case 3:
        wrapSpace(wWidth/2f, hHeight/2f, dDepth/2f);  //Simple Wrap
        break;

      case 4:
        bounceAgentYZ(wWidth/2, hHeight/2, dDepth/2);  //Bounce Y,Z & Wrap X
        break;

      /*case 5:
        bounceAgentYZ(wWidth/2, hHeight/2, dDepth/2);  //Bounce Y,Z & Wrap X
        break;*/
      }

      //wander2D(80, 50, 1);

      seek();

      update();
    }
  }
  
  void runPleAgent1() {
    if (dWeight < 1) {
      flock(agentCollection_ple1, DES_COH, DES_ALI, DES_SEP, STR_COH, STR_ALI, STR_FLOCK);

      //Gravity Z / up-down
      acc.scaleSelf(STR_FLOCK);
      acc.addSelf(-1 * STR_GRAVITY, 0, 0);

      //Gravity X / left-right
     // acc.scaleSelf(STR_FLOCK);
     // acc.addSelf(STR_GRAVITY, 0, 0 );

      affectedByAttractors(targetForce_max);
      affectedByRepellers(targetForce_max);



      switch (bounceType) {
      case 0:
        bounceAgentXY(wWidth/2, hHeight/2, dDepth/2);  //Bounce X,Y & Wrap Z
        break;

      case 1:
        bounceSpace(wWidth/2, hHeight/2, dDepth/2);  //Simple Bounce
        break;

      case 2: 
        wrapPleAgent(wWidth/2f, hHeight/2f, dDepth/2f);  //Wrap and start from top
        break;

      case 3:
        wrapSpace(wWidth/2f, hHeight/2f, dDepth/2f);  //Simple Wrap
        break;

      case 4:
        bounceAgentYZ1(wWidth/2, hHeight/2, dDepth/2);  //Bounce Y,Z & Wrap X
        break;

      /*case 5:
        bounceAgentYZ(wWidth/2, hHeight/2, dDepth/2);  //Bounce Y,Z & Wrap X
        break;*/
      }

      //wander2D(80, 50, 1);

      seek();

      update();
    }
  }



  //------------------------------------------------------
  //Additional Behaviors:
  //------------------------------------------------------


  void seek() {
  }


  //------------------------------------------------------
  void affectedByAttractors(float targetForce_max) {

    //myPleAgent att= (myPleAgent) agentCollection_att.get(0);
    myPleAgent att= closestAgent(agentCollection_att);

    if (att.attRadius > 0) {
      float attForce= map (att.attRadius, att.attRadius_min_att, att.attRadius_max_att, 0, targetForce_max);
      //towardsTarget(att.loc, attForce);

      applyAttractionBehaviour(att.loc, att.attRadius, att.attStrength, 0, 0.03);
    }
  }

  //------------------------------------------------------

  void affectedByRepellers(float targetForce_max) {
    //myPleAgent rep= (myPleAgent) agentCollection_rep.get(0);
    myPleAgent rep= closestAgent(agentCollection_rep);

    if (rep.attRadius > 0) {
      float repForce= map (rep.attRadius, rep.attRadius_min_att, rep.attRadius_max_att, 0, targetForce_max);
      //towardsTarget(rep.loc, -1 * repForce);

      applyAttractionBehaviour(rep.loc, rep.attRadius, rep.attStrength, 0, 0.03);
    }
  }

  //------------------------------------------------------

  void applyAttractionBehaviour(Vec3D attractor, float attRadius, float attrStrength, float jitter, float force) {
    float radiusSquared= attRadius * attRadius;
    Vec3D delta = attractor.sub(loc);
    float dist = delta.magSquared();
    if (dist < radiusSquared) {
      Vec3D f = delta.normalizeTo((1.0f - dist / radiusSquared))
        .jitter(jitter).scaleSelf(attrStrength);
      //p.addForce(f);
      acc.addSelf(f.scale(force));
    }
  }

  //------------------------------------------------------


  void towardsTarget(Vec3D target, float force) { //force= 0-1
    Vec3D desire= target.sub(loc);
    desire.normalizeTo(maxspeed);
    Vec3D steer= desire.sub(vel);
    steer.scaleSelf(force);
    steer.limit(maxforce);
    acc.addSelf(steer);
  }

  //------------------------------------------------------

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

  //------------------------------------------------------
  //Agent Wrap & Bounce:
  //------------------------------------------------------


  void wrapPleAgent(float dX, float dY, float dZ) {
    if (loc.x < -dX) loc= new Vec3D (random(-wWidth/2, wWidth/2), random(-hHeight/2, hHeight/2), dDepth/2);
    ;
    if (loc.y < -dY) loc= new Vec3D (random(-wWidth/2, wWidth/2), random(-hHeight/2, hHeight/2), dDepth/2);
    ;
    if (loc.z < -dZ) loc= new Vec3D (random(-wWidth/2, wWidth/2), random(-hHeight/2, hHeight/2), dDepth/2);
    ;
    if (loc.x > dX) loc= new Vec3D (random(-wWidth/2, wWidth/2), random(-hHeight/2, hHeight/2), dDepth/2);
    ;
    if (loc.y > dY) loc= new Vec3D (random(-wWidth/2, wWidth/2), random(-hHeight/2, hHeight/2), dDepth/2);
    ;
    if (loc.z > dZ) loc= new Vec3D (random(-wWidth/2, wWidth/2), random(-hHeight/2, hHeight/2), dDepth/2);
    ;
  }


  //------------------------------------------------------
  void bounceAgentXY(float dX, float dY, float dZ) {
    if (loc.x <= -dX) {
      vel.x *= -1;
      loc.x = -dX;
    }

    if (loc.x >= dX) {
      vel.x *= -1;
      loc.x = dX;
    }

    if (loc.y <= -dY) {
      vel.y *= -1;
      loc.y =  -dY;
    }

    if (loc.y >= dY) {
      vel.y *= -1;
      loc.y =  dY;
    }

    if (loc.z >= dZ) {
      vel.z *= -1;
      loc.z = dZ;
    }

    if (loc.z <= -dZ) {
      //loc.z = dZ;

      loc= new Vec3D (random(-wWidth/2, wWidth/2), random(-hHeight/2, hHeight/2), dDepth/2);
    }
  }
 //------------------------------------------------------
  void bounceAgentYZ(float dX, float dY, float dZ) {
    if (loc.x <= -dX) {
      vel.x *= -1;
      loc.x = -dX;
    }

    if (loc.x >= dX) {

      loc= new Vec3D (-wWidth/2, random(-hHeight/2, hHeight/2), dDepth/2);
    }

    if (loc.y <= -dY) {
      vel.y *= -1;
      loc.y =  -dY;
    }

    if (loc.y >= dY) {
      vel.y *= -1;
      loc.y =  dY;
    }

    if (loc.z >= dZ) {
      vel.z *= -1;
      loc.z = dZ;
    }

    if (loc.z <= -dZ) {
      vel.z *= -1;
      loc.z = -dZ;
    }
  }
  
  void bounceAgentYZ1(float dX, float dY, float dZ) {
    if (loc.x >= dX) {
      vel.x *= 1;
      loc.x = dX;
    }

    if (loc.x <= -dX) {

      loc= new Vec3D (wWidth/2, random(-hHeight/2, hHeight/2), dDepth/2);
    }

    if (loc.y <= -dY) {
      vel.y *= -1;
      loc.y =  -dY;
    }

    if (loc.y >= dY) {
      vel.y *= -1;
      loc.y =  dY;
    }

    if (loc.z >= dZ) {
      vel.z *= -1;
      loc.z = dZ;
    }

    if (loc.z <= -dZ) {
      vel.z *= -1;
      loc.z = -dZ;
    }
  }



  //------------------------------------------------------
  //Exporters:
  //------------------------------------------------------

  void exportTail() {
    output = createWriter("exportedPoints.txt");
    String st= "";

    for (int i = 0; i < tail.length; i++) {      
      Vec3D t= tail[i];
      st= st + (t.x + "," + t.y + "," + t.z + ";");  // here we export the coordinates of the vector using String concatenation!
    }

    output.println(st);
    output.flush();
    output.close();
    println("points have been exported");
  }

  //------------------------------------------------------
}
