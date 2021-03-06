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
  // use OpenGL if translate() is utilized
  size(600, 600);//, OPENGL);

  // what joint positions should we ask Synapse for?
  // 1: body pos, 2: world pos, 3: screen pos
  skeleton.jointPosType = 1;

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
    PVector rh = skeleton.getJoint("righthand").posBody;
    PVector lh = skeleton.getJoint("lefthand").posBody;

    // map values
    posX = round(map(constrain(abs(lh.x), 280, 680), 280, 680, 600, 0));
    posY = round(map(constrain(abs(lh.y), 280, 680), 280, 680, 600, 0));

    speed = round(map(constrain(rh.x, 280, 680), 280, 680, 0, 100));
    pitch = round(map(constrain(rh.y, 280, 680), 280, 680, 0, 100));
  }

  // ## color depending on speed and pitch
  colorMode(HSB, 100);
  background(sqrt(speed *pitch));
  fill(speed, 100, 100);
  moduleColor = color(100-pitch, 100, 100);
  smooth();

  stroke(moduleColor, moduleAlpha);
  strokeWeight(10);
  rectMode(CENTER);

  for (int gridY=0; gridY<width; gridY+=25) {
    for (int gridX=0; gridX<height; gridX+=25) {
      float diameter = dist(posX, posY, gridX, gridY);
      diameter = diameter/max_distance * 40;
      // with OpenGL uncomment following lines
      //pushMatrix();
      //translate(gridX, gridY, diameter*5);
      //rect(0, 0, diameter, diameter);    //// also nice: ellipse(...)
      //popMatrix();
      rect(gridX, gridY, diameter, diameter);
    }
  }
}


// OSC CALLBACK FUNCTIONS

void oscEvent(OscMessage m) {
  skeleton.parseOSC(m);
}

