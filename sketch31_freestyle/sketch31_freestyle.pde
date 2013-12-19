import processing.pdf.*;
import java.util.Calendar;

import oscP5.*;
OscP5 oscP5;

// our Synapse tracked skeleton data
Skeleton skeleton = new Skeleton();

int[] colors = {
  color(181, 157, 0, 100), color(0, 130, 164, 100), color(87, 35, 129, 100), color(197, 0, 123, 100)
};

int LINE_HEIGHT = 200;
int stepSize = LINE_HEIGHT/20;
int x, y;

void setup() {
  // use full screen size 
  size(displayWidth, displayHeight);
  background(255);
  
  frameRate(15);

  x = 0;
  y = LINE_HEIGHT/2;

  oscP5 = new OscP5(this, 12347);
}

void draw() {
  int noteColor = round(map(mouseX, 0, displayWidth, 0, 100));
  int volume = round(map(mouseY, 0, displayHeight, LINE_HEIGHT, 0));
  boolean drawNote = false;

  skeleton.update(oscP5);
  if (skeleton.isTracking()) {
    // update parameters depending on kinect skelecton data
    PVector rh = skeleton.getJoint("righthand").posScreen;
    PVector lh = skeleton.getJoint("lefthand").posScreen;

    // note color
    noteColor = round(map(rh.x, 400, 200, 0, 100));
    // volume
    volume = round(map(rh.y, 360, 120, 0, 100));

    // play note
    if (lh.y < 240) {
      drawNote = true;
    }

    Joint lhJoint = skeleton.getJoint("lefthand");

    // special
    if (lhJoint.hitDetected() && lhJoint.hitLeft) {
      // clear
      background(100);
    }
  }

  x += stepSize;
  if (x + stepSize > displayWidth) {
    x = 0;
    y += LINE_HEIGHT;
  }

  if (y + LINE_HEIGHT/2 > displayHeight) {
    y = LINE_HEIGHT/2;
  }


  if (mousePressed || drawNote) {
    colorMode(HSB, 100);
    strokeWeight(0);
    
    // the actual note circle
    fill(noteColor, 100, 100, 10);
    ellipse(x, y + noteColor - 50, volume, volume);
  }
}


// OSC CALLBACK FUNCTIONS

void oscEvent(OscMessage m) {
  skeleton.parseOSC(m);
}

