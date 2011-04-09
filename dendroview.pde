/**
 * Dendroview
 *
 * Viewer for a dendrogram
 *
 * Liam McNamara started 8 Apr
 * liamjjmcnamara@gmail.com
 */


class Instance {
  float time;
  int ID;
}
class Edge {
  Instance a;
  Instance b;
  double value;
}

float xmag, ymag = 0;
float newXmag, newYmag = 0; 
String filename = "dendrogram.dg";
Edge[] edgelist;


// make the window and set colour mode 
void setup() { 
  size(740, 560, P3D); 
  noStroke(); 
  colorMode(RGB, 1);
  options();
  processFile(filename);
} 

void options() {
  println("Setting options");
}

// read dendrogram edge file
void processFile(String filename) {
  println("Processing file: " + filename);
  
  String lines[] = loadStrings(filename); 
    for (int i = 0; i < lines.length; i++) { 
      println(lines[i]);    
    } 
}

// turn edgelsit into a 3D structure
void createDendrogram() {
} 

void draw() { 
  background(0.2);

  pushMatrix(); 

  translate(width/2, height/2, -30); 

  newXmag = mouseX/float(width) * TWO_PI;
  newYmag = mouseY/float(height) * TWO_PI;

  float diff = xmag-newXmag;
  if (abs(diff) >  0.01) { 
    xmag -= diff/4.0;
  }

  diff = ymag-newYmag;
  if (abs(diff) >  0.01) { 
    ymag -= diff/4.0;
  }

  rotateX(-ymag); 
  rotateY(-xmag); 

  scale(90);
  beginShape(QUADS);

  fill(0, 1, 1); 
  vertex(-1,  1,  1);
  fill(1, 1, 1); 
  vertex( 1,  1,  1);
  fill(1, 0, 1); 
  vertex( 1, -1,  1);
  fill(0, 0, 1); 
  vertex(-1, -1,  1);

  fill(1, 1, 1); 
  vertex( 1,  1,  1);
  fill(1, 1, 0); 
  vertex( 1,  1, -1);
  fill(1, 0, 0); 
  vertex( 1, -1, -1);
  fill(1, 0, 1); 
  vertex( 1, -1,  1);

  fill(1, 1, 0); 
  vertex( 1,  1, -1);
  fill(0, 1, 0); 
  vertex(-1,  1, -1);
  fill(0, 0, 0); 
  vertex(-1, -1, -1);
  fill(1, 0, 0); 
  vertex( 1, -1, -1);

  fill(0, 1, 0); 
  vertex(-1,  1, -1);
  fill(0, 1, 1); 
  vertex(-1,  1,  1);
  fill(0, 0, 1); 
  vertex(-1, -1,  1);
  fill(0, 0, 0); 
  vertex(-1, -1, -1);

  fill(0, 1, 0); 
  vertex(-1,  1, -1);
  fill(1, 1, 0); 
  vertex( 1,  1, -1);
  fill(1, 1, 1); 
  vertex( 1,  1,  1);
  fill(0, 1, 1); 
  vertex(-1,  1,  1);

  fill(0, 0, 0); 
  vertex(-1, -1, -1);
  fill(1, 0, 0); 
  vertex( 1, -1, -1);
  fill(1, 0, 1); 
  vertex( 1, -1,  1);
  fill(0, 0, 1); 
  vertex(-1, -1,  1);

  endShape();

  popMatrix();
} 

