//------------------------------------------------------




//--------------------------------------------------------------------------------------////////Change these
//Global Parameter:
//------------------------------------------------------
float DYNAMIC_WEIGHT_REP= 0.5;
float ATTSTRENGTH_REP= 0.5;
float MAXSPEED_REP= 1;
//--------------------------------------------------------------------------------------////////////////////






//------------------------------------------------------
//Class:
//------------------------------------------------------
class myRepeller extends myPleAgent {


  myRepeller(PApplet _p5, Vec3D _loc) {
    super(_p5, _loc);




    //--------------------------------------------------------------------------------------////////Change these
    //Local Parameter:
    //------------------------------------------------------
    c= color(255, 0, 0,20);
    sw= 50;

    bldrawTrail= false;
    pLock= true;
    bldrawRadius= false;

    attStrength= -0.5; //random(-0.1, -0.5);
    attRadius= 200;//random (0, 300);
    dWeight= 0.1;

    bounceType=1;
    //0= Bounce X,Y & Wrap Z start from top
    //1= Simple Bounce
    //2= Wrap and start from top
    //3= Simple Wrap
    //4= Bounce Y,Z & Wrap X start from left
    //----------------------------------------------------------------------------------------////////////////////
  }

  void updateParameter() {
    /*
    attStrength=  -1 * ATTSTRENGTH_REP;
     
     attRadius_int= ATTRADIUS_INTERVAL; 
     attRadius_min_att= ATTRADIUS_MIN;
     attRadius_max_att= ATTRADIUS_MAX;
     
     maxspeed= MAXSPEED_REP;
     pLock= BLN_lock;
     dWeight= DYNAMIC_WEIGHT_REP;
     //blRenderTrail= BLN_RENDERTRAIL;
     
     
     */

    bldrawRadius= BLN_DRAWRADIUS;
  }
}
