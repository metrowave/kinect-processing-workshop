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

import oscP5.*;
OscP5 oscP5;

// our Synapse tracked skeleton data
Skeleton skeleton = new Skeleton();

void setup() {
  size(displayWidth, displayHeight);
  noCursor();
  
  // what joint positions should we ask Synapse for?
  // 1: body pos, 2: world pos, 3: screen pos
  skeleton.jointPosType = 1;
  
  oscP5 = new OscP5(this, 12347);
}


void draw() {
  int posX = mouseX;
  int posY = mouseY;
  
  // update and draw the skeleton if it's being tracked
  skeleton.update(oscP5);
  if (skeleton.isTracking()) {
    // update parameters depending on kinect skelecton data
    // get position of the right hand
    PVector rh = skeleton.getJoint("righthand").posBody;
    
    // translate (map) the kinect position values to screen values
    posX = round(map(constrain(abs(rh.y),100,680),100,680,displayHeight,0));
    posY = round(map(constrain(abs(rh.x),100,680),100,680,720,0));
    
    // if a hit is detected, draw a white background to for a "flashing" effect
    Joint rhJ = skeleton.getJoint("righthand");
    if (rhJ.hitDetected()) {
      background(255);
    }
  }

  // set the mode for later color definitions
  colorMode(HSB, 360, 100, 100);
  // draw no border
  noStroke();
  // draw background in one color
  background(posY/2, 100, 100);

  // set the color to fill the rectangle with
  fill(360-posY/2, 100, 100);
  // interprets the first two parameters of rect() as the shape's center point, while the third and fourth parameters are its width and height.
  rectMode(CENTER);
  // draw the centered square
  rect(displayWidth/2, displayHeight/2, posX+1, posX+1);
}


// OSC CALLBACK FUNCTIONS

void oscEvent(OscMessage m) {
  skeleton.parseOSC(m);
}

