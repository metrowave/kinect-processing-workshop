// winniae@launsch.de GPL v3

import processing.video.*;
import oscP5.*;
OscP5 oscP5;

// our Synapse tracked skeleton data
Skeleton skeleton = new Skeleton();

Movie movie1, movie2, movie3;
boolean fullscreen = false;

void setup() {
  size(displayWidth, displayHeight);

  // what joint positions should we ask Synapse for?
  // 1: body pos, 2: world pos, 3: screen pos
  skeleton.jointPosType = 1;
  oscP5 = new OscP5(this, 12347);

  String path1 = "redball.mov";
  String path2 = "countdown15.mov";
  String path3 = "garbage.mov";
  movie1 = new Movie(this, path1);
  movie2 = new Movie(this, path2);
  movie3 = new Movie(this, path3);
  //movie1.loop();
  //movie2.loop();
  //movie3.loop();

  background(255);
}

void draw() {
  int posX = mouseX;
  int posY = mouseY;

  skeleton.update(oscP5);
  if (skeleton.isTracking()) {
    // update parameters depending on kinect skelecton data
    Joint head = skeleton.getJoint("head");
    PVector lh = skeleton.getJoint("lefthand").posBody;

    //posX = round(map(constrain(lh.x,240,680), 240, 680, 0, displayWidth));
    //posY = round(map(constrain(lh.y,240,680), 240, 680, 0, displayHeight));
    posX = round(constrain(abs(lh.x), 240, 680));
    posY = round(constrain(abs(lh.y), 240, 680));

    if (head.hitDetected() && head.hitLeft) {
      fullscreen = true;
    }
    if (head.hitDetected() && head.hitRight) {
      fullscreen = false;
    }
  }

  // fade out movie image
  //tint(255, map(posY, 0, displayHeight, 0, 255));
  tint(255, map(posY, 240, 680, 0, 255));

  //if (posX > 0 && posX < displayWidth/3) {
  if (posX < 260) {
    movie1.pause();
    movie2.pause();
    movie3.pause();
  }
  //if (posX > 0 && posX < displayWidth/3) {
  if (posX >= 260 && posX < 400) {
    movie1.loop();
    if (fullscreen) {
      image(movie1, 0, 0, displayWidth, displayHeight);
    }
    else {
      image(movie1, 160, displayHeight/2);
    }  
    movie2.pause();
    movie3.pause();
  }
  //if (posX > displayWidth/3 && posX < displayWidth*2/3) {
  if (posX >= 400 && posX < 540) {
    movie2.loop();
    if (fullscreen) {
      image(movie2, 0, 0, displayWidth, displayHeight);
    }
    else {
      image(movie2, 160 + displayWidth/3, displayHeight/2);
    }
    movie1.pause();
    movie2.pause();
  }
  //if (posX > displayWidth*2/3 && posX < displayWidth) {
  if (posX > 540) {
    movie3.loop();
    if (fullscreen) {
      image(movie3, 0, 0, displayWidth, displayHeight);
    }
    else {
      image(movie3, 160 + displayWidth*2/3, displayHeight/2);
    }
    movie1.pause();
    movie2.pause();
  }
}

// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
}

// OSC CALLBACK FUNCTIONS

void oscEvent(OscMessage m) {
  skeleton.parseOSC(m);
}

