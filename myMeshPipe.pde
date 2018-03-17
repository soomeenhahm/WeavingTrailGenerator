class myMeshPipe extends Ple_MeshPipe {
  PApplet p5;

  int numSegments;

  boolean bldrawMeshPipe; //exist at all or not
  boolean blRenderMeshPipe; //exist but render or not


  myMeshPipe(PApplet _p5) {
     super(_p5);

    bldrawMeshPipe = false;
    blRenderMeshPipe = false;
  }
}
