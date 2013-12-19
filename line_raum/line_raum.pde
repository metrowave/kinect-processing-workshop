// winniae@launsch.de GPL v3

int winHeight = 600;
int winWidth = 600;

int lineSpace = winWidth;
int roomWidth = winWidth;

import oscP5.*;
OscP5 oscP5;
// our Synapse tracked skeleton data
Skeleton skeleton = new Skeleton();


void setup() {
  size(winHeight, winWidth, OPENGL);

  // what joint positions should we ask Synapse for?
  // 1: body pos, 2: world pos, 3: screen pos
  skeleton.jointPosType = 2;
  oscP5 = new OscP5(this, 12347);
}

void draw() {
  background(255);

  int posX = mouseX;
  int posY = mouseY;
  int posZ = mouseY;

  skeleton.update(oscP5);
  if (skeleton.isTracking()) {
    PVector rh = skeleton.getJoint("righthand").posWorld;
    PVector torso = skeleton.getJoint("torso").posWorld;
    posX = round(map(constrain(abs(rh.x), 0, 1000), 0, 1000, 0, displayWidth));
    posY = round(map(constrain(abs(rh.y), 0, 1000), 0, 1000, 0, displayHeight));
    posZ = round(map(torso.z, 0, 8000, 0, displayHeight));
  }


  beginCamera();
  camera();
  translate(posX-winWidth/2, 0, winWidth/2-posZ*2);
  rotateX(radians(map(posY, 0, displayHeight, -45, 90)));
  endCamera();



  for (int i=1; i<=10; i++) {
    //line(i*lineSpace, winHeight/4, -i*lineSpace, i*lineSpace, winHeight*3/4, -i*lineSpace);
    translate(0, 0, -lineSpace);  
    line(winWidth/2-roomWidth/2, 0, winWidth/2-roomWidth/2, winHeight);
    line(winWidth/2+roomWidth/2, 0, winWidth/2+roomWidth/2, winHeight);
  }
}


// OSC CALLBACK FUNCTIONS

void oscEvent(OscMessage m) {
  skeleton.parseOSC(m);
}

