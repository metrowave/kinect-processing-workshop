// ## winniae@launsch.de 
// ## License GPL v3
//
// ## Work under the following notices has been incorporated:
//
// P_1_0_01.pde
// 
// Generative Gestaltung, ISBN: 978-3-87439-759-9
// First Edition, Hermann Schmidt, Mainz, 2009
// Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
// Copyright 2009 Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
//
// http://www.generative-gestaltung.de
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// Modifications by winniae:
// ## Can receive input data (x and y positions) from a Kinect via Synapse OSC events

/**
 * changing colors and size by moving the mouse
 *    
 * MOUSE
 * position x          : size
 * position y          : color
 * 
 * KEYS
 * s                   : save png
 * p                   : save pdf
 */

import processing.pdf.*;
import java.util.Calendar;

import oscP5.*;
OscP5 oscP5;

// our Synapse tracked skeleton data
Skeleton skeleton = new Skeleton();

boolean savePDF = false;


void setup() {
  size(displayWidth, displayHeight);
  noCursor();
  
  oscP5 = new OscP5(this, 12347);
}


void draw() {
  // this line will start pdf export, if the variable savePDF was set to true 
  if (savePDF) beginRecord(PDF, timestamp()+".pdf");

  int posX = mouseX;
  int posY = mouseY;
  // update and draw the skeleton if it's being tracked
  skeleton.update(oscP5);
  if (skeleton.isTracking()) {
    // update parameters depending on kinect skelecton data
    PVector rh = skeleton.getJoint("righthand").posScreen;
    posX = round(map(rh.y,0,480,displayHeight,0));
    posY = round(map(rh.x,0,680,720,0));
    
    Joint rhJ = skeleton.getJoint("righthand");
    if (rhJ.hitDetected()) {
      background(255);
    }
  }


  colorMode(HSB, 360, 100, 100);
  rectMode(CENTER); 
  noStroke();
  background(posY/2, 100, 100);

  fill(360-posY/2, 100, 100);
  rect(displayWidth/2, displayHeight/2, posX+1, posX+1);

  // end of pdf recording
  if (savePDF) {
    savePDF = false;
    endRecord();
  }
}


void keyPressed() {
  if (key=='s' || key=='S') saveFrame(timestamp()+"_##.png");
  if (key=='p' || key=='P') savePDF = true;
}


String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}


// OSC CALLBACK FUNCTIONS

void oscEvent(OscMessage m) {
  skeleton.parseOSC(m);
}

