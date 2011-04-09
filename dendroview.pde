/**
 * Dendroview
 *
 * Viewer for a dendrogram
 *
 * Liam McNamara started 8 Apr
 * liamjjmcnamara@gmail.com
 */
import java.util.regex.Matcher;
import java.util.regex.Pattern;

class Instance {
  int ID;
  double time;
  Instance(int ID, double time) {
    this.ID=ID; 
    this.time=time;
  }
  public String toString() {
    String rv = "("+Integer.toString(ID)+","+Double.toString(time)+")";
    return rv;
  }
}

class Edge {
  Instance a;
  Instance b;
  double value;
  Edge(int IDa, double timea, int IDb, double timeb, double value) {
    this.a = new Instance(IDa, timea);
    this.b = new Instance(IDb, timeb);
    this.value = value;
  }
  public String toString() {
    String rv = a.toString()+"-"+b.toString()+" = "+Double.toString(value);// timea IDb timeb value;
    return rv;
  }
}

float xmag, ymag = 0;
float newXmag, newYmag = 0;
float zeroY=0;
float zeroX=0;
float zoom = 1.0;
String filename = "dendrogram.dg";
ArrayList<Edge> edgelist = new ArrayList<Edge>();
Pattern reg = Pattern.compile("\\(([0-9]+),([0-9]+)\\),\\(([0-9]+),([0-9]+)\\),([0-9\\.]+)");


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
    //println(lines[i]);
    Matcher m;
    m = reg.matcher(lines[i]);
    if (m.matches()) {
      int IDa = Integer.parseInt(m.group(1));
      double timea = Integer.parseInt(m.group(2)); 
      int IDb = Integer.parseInt(m.group(3));
      double timeb = Integer.parseInt(m.group(4)); 
      double value = Double.parseDouble(m.group(5));
      Edge e = new Edge(IDa,timea,IDb,timeb,value);
      println(e.toString());
      edgelist.add(e);
    } 
    else {
      println("No match: "+lines[i]);
    }
  }
}

void keyPressed() {
  if (keyCode == 32) {//space bar pressed
      //reset
      zeroX = mouseX;
      zeroY = mouseY;
      println("y "+zeroY);
      println("x "+zeroX);
  }
}

void paintInstance(int x, int y, int z) {
  pushMatrix();
  translate(x, y, z);
  stroke(1,1,1);
  fill(25,25,25);
  box(1);
  popMatrix();
}


// turn edgelsit into a 3D structure
void createDendrogram() {
}

void draw() { 
  background(0.2);

  pushMatrix(); 

  translate(width/2, height/2, -30); 

  newXmag = (mouseX-zeroX)/float(width) * TWO_PI;
  newYmag = (mouseY-zeroY)/float(height) * TWO_PI;

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

  scale(40);

  paintInstance(1,1,5);
  paintInstance(1,5,1);
  paintInstance(5,1,1);
  paintInstance(-5,1,1);
  paintInstance(1,-5,1);
  paintInstance(1,1,-5);
  
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

