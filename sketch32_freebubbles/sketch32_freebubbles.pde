// winniae@launsch.de GPL v3

import oscP5.*;
OscP5 oscP5;

// our Synapse tracked skeleton data
Skeleton skeleton = new Skeleton();

// five colors, fünf flächen
int[] colors = {
};
int MAX_COLORS = 3;
int MAX_WEIGHTS = 15;

ArrayList<Bubble> bubbles = new ArrayList<Bubble>();
long lastTime;
// remember if we hit anything
boolean ringing = false;


// wave : http://processing.org/examples/sinewave.html
int xspacing = 12;   // How far apart should each horizontal location be spaced (default 16)
int minxspacing = 1;
int maxyvalues;
int w;              // Width of entire wave

float theta = 0.0;  // Start angle at 0
float thetaVelocity = 0.07; // (default 0.02)
float amplitude = 15.0;  // Height of wave (default 75.0)
float period = 250.0;  // How many pixels before the wave repeats (default 500.0)
float dx;  // Value for incrementing X, a function of period and xspacing
float[] yvalues;  // Using an array to store height values for the wave
// end wave

void setup() {
  colorMode(HSB, 100);
  colors = append(colors, color(0, 100, 100, 50));
  colors = append(colors, color(25, 100, 100, 50));
  colors = append(colors, color(50, 100, 100, 50));
  colors = append(colors, color(75, 100, 100, 50));
  colors = append(colors, color(100, 100, 100, 50));

  // use full screen size 
  size(displayWidth, displayHeight);
  background(100);

  oscP5 = new OscP5(this, 12347);
  lastTime = millis();

  //wave
  w = width+16;
  dx = (TWO_PI / period) * xspacing;
  yvalues = new float[w/minxspacing];
}

void draw() {
  background(100);
  calcWave();
  renderWave();
  // randomize wave parameters
  thetaVelocity += random(-0.01, 0.01);

  skeleton.update(oscP5);
  if (skeleton.isTracking()) {
    // update parameters depending on kinect skelecton data
    PVector rh = skeleton.getJoint("righthand").posBody;
    PVector lh = skeleton.getJoint("lefthand").posBody;

    int posX = round(map(constrain(abs(rh.x), 240, 680), 240, 680, 0, displayWidth-1));
    int posY = round(map(constrain(abs(rh.y), 260, 680), 260, 680, displayHeight-1, 0));
    int volume = round(map(constrain(abs(lh.y), 280, 680), 280, 680, 0, 127));
    int currentColor, currentWeight;

    // determine current color, we got three horizontal layers
    // (code matches the Max implementation)
    int colorSelection = 4;
    if (abs(rh.y) < 400) {
      colorSelection = 0;
    }
    else if (abs(rh.y) < 540) {
      colorSelection = 1;
    }
    else {
      colorSelection = 2;
    }
    currentColor = colors[colorSelection];
    currentWeight = posX*MAX_WEIGHTS/displayWidth;

    // detect a hit when the left hand is 400 to the left of the body
    // but only once, reset hit marker when over -400 again
    Joint lhJoint = skeleton.getJoint("lefthand");
    int lhX = round(lh.x);
    if (lhX < -400 && !ringing) {
      // hit
      ringing = true;

      // new bubble! initialize all with 4s life time
      bubbles.add(new Bubble(posX, posY, 4000, currentColor, currentWeight, volume));
    }
    else if (lhX >= -400) {
      // reset hit marker
      // only reset when over -400
      ringing = false;
    }

    // calculate time difference since last draw
    int millisGone = (int) (millis() - lastTime);
    lastTime = millis();

    // draw notes and update duration
    for (int i = bubbles.size()-1; i >= 0; i--) {
      Bubble b = bubbles.get(i);
      b.draw();
      b.update(millisGone);
    }

    // draw pointer
    strokeWeight(5);
    stroke(0, 20);
    fill(currentColor, 20);
    ellipse(posX, posY, ringing?60:30, ringing?60:30);
  }
}


class Bubble {
  // duration in milliseconds
  // bubbleColor depends on the y-axis value, the display is separated into 3 layers
  // weight depends on the x-axis value, the display is separated into 15 layers (correlates with the pitch in Max)
  int posX, posY, duration, remaining, bubbleColor, weight, volume;

  Bubble(int posX, int posY, int duration, int bubbleColor, int weight, int volume) {
    this.posX = posX;
    this.posY = posY;
    this.duration = duration;
    this.remaining = duration;
    this.bubbleColor = bubbleColor;
    this.weight = weight;
    this.volume = volume * 2 + 50;
  }

  void draw() {
    strokeWeight(0);
    fill(bubbleColor, map(weight, 0, MAX_WEIGHTS, 10, 100));
    ellipse(posX, posY, volume * remaining/duration, volume*remaining/duration);
  }

  void update(int millisGone) {
    this.remaining -= millisGone;
    if (this.remaining <=0) {
      bubbles.remove(this);
    }
  }
}


// wave
void calcWave() {
  // Increment theta (try different values for 'angular velocity' here
  theta += thetaVelocity;

  // For every x value, calculate a y value with sine function
  float x = theta;
  for (int i = 0; i < yvalues.length; i++) {
    // add some randomness to the amplitude!!
    float myAmplitude = amplitude;
    //myAmplitude += random(-40, 40);

    float newYValue = sin(x)*myAmplitude;
    yvalues[i] = newYValue;//(yvalues[i]+newYValue)/2;
    x+=dx;
  }
}

void renderWave() {
  noStroke();
  fill(0,70);
  // A simple way to draw the wave with an ellipse at each location
  for (int x = 0; x < yvalues.length; x++) {
    ellipse((x*xspacing), (height/6+yvalues[x]), 16, 16);
    ellipse((x*xspacing), (height/2+yvalues[x]), 16, 16);
    ellipse((x*xspacing), (height*5/6+yvalues[x]), 16, 16);
  }
}
// end wave

// OSC CALLBACK FUNCTIONS

void oscEvent(OscMessage m) {
  skeleton.parseOSC(m);
}

