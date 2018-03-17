//------------------------------------------------------




//--------------------------------------------------------------------------------------////////Change these
//Global Parameter: 
//------------------------------------------------------
float DYNAMIC_WEIGHT_ATT= 0.5;
float ATTSTRENGTH_ATT= 0.5;
float MAXSPEED_ATT= 1;
//--------------------------------------------------------------------------------------////////////////////






//------------------------------------------------------
//Class:
//------------------------------------------------------
class myAttractor extends myPleAgent {


  myAttractor(PApplet _p5, Vec3D _loc) {
    super(_p5, _loc);



    //--------------------------------------------------------------------------------------////////Change these
    //Local Parameter:
    //------------------------------------------------------
    c= color(0, 0, 255,20);
    sw= 10;

    bldrawTrail= false;
    pLock= true;
    bldrawRadius= false;

    attStrength= 0.505;//random(0.1, 0.5);
    attRadius= 250;//random (0, 300);
    dWeight= 0.5;

    bounceType=2;
    //----------------------------------------------------------------------------------------////////////////////
  }

  void updateParameter() {
    /*
    
     attStrength=  ATTSTRENGTH_ATT;
     
     attRadius_int= ATTRADIUS_INTERVAL; 
     attRadius_min_att= ATTRADIUS_MIN;
     attRadius_max_att= ATTRADIUS_MAX;
     
     maxspeed= MAXSPEED;
     pLock= BLN_lock;
     dWeight= DYNAMIC_WEIGHT_ATT;   
     //blRenderTrail= BLN_RENDERTRAIL;
     
     
     
     */

    bldrawRadius= BLN_DRAWRADIUS;
  }
}
