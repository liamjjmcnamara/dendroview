/**
 * Dendroview
 *
 * Viewer for a dendrogram
 *
 * Liam McNamara started 8 Apr
 * liamjjmcnamara@gmail.com
 */
import java.util.HashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

class Instance {
  int ID;
  int realID;
  float time; // 
  float realTime; // the actual time from the trace
  Instance(int ID, float time) {
    this.realID=ID;
    this.ID = nodeLookup(ID); // remap to Xpos ID 
    this.realTime=time;
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
  float value;
  Edge(int IDa, float timea, int IDb, float timeb, float value) {
    this.a = new Instance(IDa, timea);
    this.b = new Instance(IDb, timeb);
    this.value = value;
  }
  public String toString() {
    String rv = a.toString()+"-"+b.toString()+" = "+Double.toString(value);// timea IDb timeb value;
    return rv;
  }
}

boolean flat = false; //is the graph 2D?
int flatZ = -100; // where is the flat plane?
//String filename = "dendrogram.dg";
//String filename = "badgerMarch.dg";
//String filename = "test23.100.10.dg";
String filename = "enron_internal_directed.dg";
float xmag, ymag = 0;
float newXmag, newYmag = 0;
float zeroY=0;
float zeroX=0;
float zoom = 1.0;
float startTime = Float.MAX_VALUE;
float startDisplay = 0;
float endTime = 0;
float endDisplay = 200;
float nodeSpacing=2;
float offset = 0; //just to keep number small
int nodeOffset = 0;
float timeOffset = 0;
HashMap<Integer,Integer> lookupTable = new HashMap<Integer,Integer>(); //for nodeID -> graph X value
float Xpos = 0; //first Xaxis position for nodes

ArrayList<Edge> edgelist = new ArrayList<Edge>();
Pattern reg = Pattern.compile("\\(([0-9]+),([0-9\\.]+)\\),\\(([0-9]+),([0-9\\.]+)\\),([0-9\\.]+)");


// make the window and set colour mode 
void setup() { 
  size(740, 560, P3D); 
  noStroke(); 
  colorMode(RGB, 1);
  processOptions();
  processFile(filename);

}

void processOptions() {
  println("Setting options");
}

// read dendrogram edge file
void processFile(String filename) {
  println("Processing file: " + filename);
  File fd = new File(filename);
  String lines[] = loadStrings(filename);
  
  if (lines != null) {
    for (int i = 0; i < lines.length; i++) { 
      //println(lines[i]);
      Matcher m;
      m = reg.matcher(lines[i]);
      if (m.matches()) {
        int IDa = Integer.parseInt(m.group(1));
        float timea = Float.parseFloat(m.group(2)); 
        int IDb = Integer.parseInt(m.group(3));
        float timeb = Float.parseFloat(m.group(4)); 
        float value = Float.parseFloat(m.group(5));
        Edge e = new Edge(IDa,timea,IDb,timeb,value);
        //println(e.toString());
        edgelist.add(e);
        if (timea < startTime) {startTime=timea;}
        if (timeb > endTime) {endTime=timeb;}
      } 
      else {
        println("No match: "+lines[i]);
      }
    }
  }
  println("Starttime: "+startTime+" Endtime: "+endTime);
  nodeOffset = (lookupTable.size()/2); //shift node along by half node set size
  timeOffset = 100;
  remapNodeTimes(); //rescale all instance times in one go
  //exit();
}

void remapNodeTimes() {
  float range = endTime-startTime;
  for (Edge e: edgelist) {
    e.a.time = ((e.a.realTime-startTime)/range)*endDisplay - timeOffset;    
    e.b.time = ((e.b.realTime-startTime)/range)*endDisplay - timeOffset;
  } 
}

// turn edgelsit into a 3D structure
void drawDendrogram() {
  //println("Drawing dendrogram");
  stroke(0);
  for (int c=0; c<Xpos; c+=nodeSpacing) {
    line( c-nodeOffset, -timeOffset, flatZ, c-nodeOffset, +timeOffset, flatZ);
  }
  for (Edge e: edgelist) {
      //println("edge: ");
      drawEdge(e);
  }
}

int nodeLookup(int ID) {
  if (!lookupTable.containsKey(ID)) {
    lookupTable.put(ID,(int)Xpos);
    Xpos+=nodeSpacing;
  }
  return lookupTable.get(ID); 
}

void drawEdge(Edge e) {
   paintInstance(e.a.ID, e.a.time, flatZ);
   //println(e.a.ID+" "+e.a.time+" "+flatZ);
   paintInstance(e.b.ID, e.b.time, flatZ);
   paintLine(e.a,e.b,e.value);
}

void draw() { 
  background(0.2); //make background grey

  pushMatrix(); //save origintransform

  translate(width/2, height/2, -30); 

  newXmag = (mouseX-zeroX)/float(width) * TWO_PI;
  newYmag = (mouseY-zeroY)/float(height) * TWO_PI;
  
  if (flat) {newXmag=0; newYmag=0;} //ignore the mouse

  float diff = xmag-newXmag;
  if (abs(diff) >  0.01) { 
    xmag -= diff/4.0;
  }

  diff = ymag-newYmag;
  if (abs(diff) >  0.01) { 
    ymag -= diff/4.0;
  }

  rotateX(ymag); 
  rotateY(xmag); 
  scale(50);

  drawDendrogram();

  popMatrix();
} 

void keyPressed() {
  //println(keyCode);
  if (keyCode == 32) {//space bar pressed
      //reset
      zeroX = mouseX;
      zeroY = mouseY;
      println("y "+zeroY);
      println("x "+zeroX);
  } else if (keyCode==65) {
       flatZ += 10; 
  } else if (keyCode==90) {
       flatZ -= 10; 
  } else if (keyCode==36) { // 'home' key, recentres'ish
      flatZ = 200;
      zeroX = 0;
      zeroY = 0;
  }
}

void paintInstance(int x, float y, float z) {
  if (flat) {z=flatZ;}
  //println("Instance: "+(x-nodeOffset)+" "+y+" "+z);
  pushMatrix();
  translate((float)x-nodeOffset, y, z);
  stroke(1,1,1);
  fill(25,25,25);
  box(0.5);
  popMatrix();
}

void paintLine(Instance a, Instance b, float weight) {
  pushMatrix();
  stroke(0.5, weight/10);
  line((float)a.ID-nodeOffset, a.time, flatZ, (float)b.ID-nodeOffset, b.time, flatZ);
  //println("Line: "+((float)a.ID-nodeOffset)+" "+a.time+" "+flatZ+" "+((float)b.ID-nodeOffset)+" "+ b.time+" "+ flatZ);
  popMatrix(); 
}

