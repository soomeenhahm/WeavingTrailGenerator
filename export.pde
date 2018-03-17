void exportTrail() {
  output = createWriter("data/Trail"+ ".txt");
  for (int j=0; j<agentCollection_ple.size(); j++) {
    myPleAgent a= (myPleAgent) agentCollection_ple.get(j);
    for (int i=1; i < a.trail.size(); i++) {
      Vec3D s1= (Vec3D) a.trail.get(i);
      Vec3D s2= (Vec3D) a.trail.get(i-1);
      String tempStr = ""; 
      if ( a.trail.size() > 0 ) {
        tempStr = tempStr + str(s1.x)+"," + str(s1.y)+"," + str(s1.z) + "/" + str(s2.x)+"," + str(s2.y)+"," + str(s2.z);
      }

      if (tempStr != "") {
        output.println(tempStr);
      }
    }
  }
  output.close();
  println( "spring_exported" );
}

void exportTrail1() {
  output = createWriter("data/Trail1"+ ".txt");
  for (int j=0; j<agentCollection_ple1.size(); j++) {
    myPleAgent a= (myPleAgent) agentCollection_ple1.get(j);
    for (int i=1; i < a.trail.size(); i++) {
      Vec3D s1= (Vec3D) a.trail.get(i);
      Vec3D s2= (Vec3D) a.trail.get(i-1);
      String tempStr = ""; 
      if ( a.trail.size() > 0 ) {
        tempStr = tempStr + str(s1.x)+"," + str(s1.y)+"," + str(s1.z) + "/" + str(s2.x)+"," + str(s2.y)+"," + str(s2.z);
      }

      if (tempStr != "") {
        output.println(tempStr);
      }
    }
  }
  output.close();
  println( "spring_exported" );
}

void exportTrail3() {
  output = createWriter("data/Trail3"+ ".txt");
  for (int j=0; j<agentCollection_ple3.size(); j++) {
    myPleAgent a= (myPleAgent) agentCollection_ple3.get(j);
    for (int i=1; i < a.trail.size(); i++) {
      Vec3D s1= (Vec3D) a.trail.get(i);
      Vec3D s2= (Vec3D) a.trail.get(i-1);
      String tempStr = ""; 
      if ( a.trail.size() > 0 ) {
        tempStr = tempStr + str(s1.x)+"," + str(s1.y)+"," + str(s1.z) + "/" + str(s2.x)+"," + str(s2.y)+"," + str(s2.z);
      }

      if (tempStr != "") {
        output.println(tempStr);
      }
    }
  }
  output.close();
  println( "spring_exported" );
}
