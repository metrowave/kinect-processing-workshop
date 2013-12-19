// winniae@launsch.de GPL v3

import oscP5.*;
OscP5 oscP5;

// our Synapse tracked skeleton data
Skeleton skeleton = new Skeleton();

int WIN_X = displayWidth;
int WIN_Y = displayHeight;
int ballX;
int ballY;
int ballR;

PVector velocity;
float speedFactor = 10;

void setup() {
  // what joint positions should we ask Synapse for?
  // 1: body pos, 2: world pos, 3: screen pos
  skeleton.jointPosType = 1;

  oscP5 = new OscP5(this, 12347);

  size(displayWidth, displayHeight);
  WIN_X = displayWidth;
  WIN_Y = displayHeight;
  // red ball starting position
  ballX = WIN_X/2;
  ballY = WIN_Y/2;

  ballR = 50;

  // initialize velocity
  velocity = new PVector(random(0.3, 1), random(0.3, 1));
  velocity.x *= speedFactor;
  velocity.y *= speedFactor;
}

void draw() {
  skeleton.update(oscP5);
  if (skeleton.isTracking()) {
    // update parameters depending on kinect skelecton data
    PVector rh = skeleton.getJoint("righthand").posBody;
    // TODO going to map this
    ballR = round(map(constrain(rh.y, 280, 680), 280, 680, 0, displayHeight*3/8));
    float oldSpeedFactor = speedFactor;
    speedFactor = map(rh.x, 180, 680, 1, 100);
    velocity.x *= speedFactor/oldSpeedFactor;
    velocity.y *= speedFactor/oldSpeedFactor;
  }


  // background white, clears screen
  background(255);

  // draw red Ball
  fill(230, 20, 20, 55+2*speedFactor);
  strokeWeight(0);
  ellipse(ballX, ballY, ballR*2, ballR*2);


  // update ball position
  ballX += velocity.x;
  ballY += velocity.y;

  // apply noise
  velocity.x += noise(ballX, ballY) - 0.5; 
  velocity.y += noise(ballY, ballX) - 0.5;

  // should never be less than zero or bigger than max
  if (ballX < 0+ballR) {
    ballX = ballR;
  }
  if (ballY < 0+ballR) {
    ballY = ballR;
  }
  if (ballX > WIN_X-ballR) {
    ballX = WIN_X-ballR;
  }
  if (ballY > WIN_Y-ballR) {
    ballY = WIN_Y-ballR;
  }

  // detect wall collision and change direction (but check if not already heading in the right direction)
  if (ballX+ballR > WIN_X -speedFactor) { // right border
    if (velocity.x > 0) {
      velocity.x *= -1;
    }
  }
  if (ballX-ballR < speedFactor) { // left border
    if (velocity.x < 0) {
      velocity.x *= -1;
    }
  }
  if (ballY+ballR > WIN_Y -speedFactor) { // bottom border
    if (velocity.y > 0) {
      velocity.y *= -1;
    }
  }
  if (ballY-ballR < speedFactor) { // top border
    if (velocity.y < 0) {
      velocity.y *= -1;
    }
  }


  // check speedFactor max
  if (velocity.x > speedFactor) {
    velocity.x = speedFactor;
  }
  if (velocity.x * -1 > speedFactor) {
    velocity.x = -1 * speedFactor;
  }
  if (velocity.y > speedFactor) {
    velocity.y = speedFactor;
  }
  if (velocity.y * -1 > speedFactor) {
    velocity.y = -1 * speedFactor;
  } 
  // boost if too slow
  if (velocity.x < 1 && velocity.x*-1 < 1) {
    velocity.x *= speedFactor;
  }
  if (velocity.y < 1 && velocity.y*-1 < 1) {
    velocity.y *= speedFactor;
  }

  //println(velocity.x + " "+velocity.y + " | " + ballX +" "+ballY);
}


// OSC CALLBACK FUNCTIONS

void oscEvent(OscMessage m) {
  skeleton.parseOSC(m);
}

