// P_2_1_2_03.pde
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

/**
 * changing size of circles in a rad grid depending the mouseposition
 *    
 * MOUSE
 * position x/y        : module size and offset z
 * 
 */

import processing.opengl.*;

import oscP5.*;
OscP5 oscP5;

// our Synapse tracked skeleton data
Skeleton skeleton = new Skeleton();

float tileCount = 20;
color moduleColor = color(0);
int moduleAlpha = 180;
int actRandomSeed = 0;
int max_distance = 500; 

void setup() {
  size(600, 600, OPENGL);
  oscP5 = new OscP5(this, 12347);
}

void draw() {
  int posX = mouseX;
  int posY = mouseY;
  int speed = 40;
  int pitch = 20;
  skeleton.update(oscP5);
  if (skeleton.isTracking()) {
    // update parameters depending on kinect skelecton data
    PVector rh = skeleton.getJoint("righthand").posScreen;
    PVector lh = skeleton.getJoint("lefthand").posScreen;

    posX = round(map(lh.x, 0, 800, 0, 600));
    // TODO let's try the depth as Y value
    posY = round(map(lh.y, 0, 600, 0, 600));
    //posY = 300; // TODO or just fix it for now?!? left-right movement only

    speed = round(map(rh.x, 280, 680, 0, 100));
    pitch = round(map(rh.y, 280, 680, 0, 100));
  }

  // ## color depending on speed and pitch
  colorMode(HSB, 100);
  fill(speed, 100, 100);
  moduleColor = color(100-pitch, 100, 100);
  // ## end

  background(sqrt(speed *pitch));
  smooth();
  //noFill();



  stroke(moduleColor, moduleAlpha);
  strokeWeight(10);

  for (int gridY=0; gridY<width; gridY+=25) {
    for (int gridX=0; gridX<height; gridX+=25) {

      float diameter = dist(posX, posY, gridX, gridY);
      diameter = diameter/max_distance * 40;
      pushMatrix();
      translate(gridX, gridY, diameter*5);
      rect(0, 0, diameter, diameter);    //// also nice: ellipse(...)
      popMatrix();
    }
  }
}


// OSC CALLBACK FUNCTIONS

void oscEvent(OscMessage m) {
  skeleton.parseOSC(m);
}

