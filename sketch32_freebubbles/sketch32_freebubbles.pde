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
// remember last left hand x position for movement detection
// remember direction, too (always plus or minus 1)
int lastLhX = 0;
int lastDir = -1; 
int MOV_THRESHOLD = 1;

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
}

void draw() {
  skeleton.update(oscP5);
  if (skeleton.isTracking()) {
    // update parameters depending on kinect skelecton data
    PVector rh = skeleton.getJoint("righthand").posScreen;
    PVector lh = skeleton.getJoint("lefthand").posScreen;

    int posX = round(map(constrain(rh.x, 200, 400), 200, 400, 0, displayWidth-1));
    int posY = round(map(constrain(rh.y, 200, 300), 200, 300, 0, displayHeight-1));
    int volume = round(map(constrain(lh.y, 200, 300), 200, 300, 100, 0));
    int currentColor, currentWeight;
    boolean newBubble = false;

    // current color
    // draw pointer

    currentColor = colors[posY*MAX_COLORS/displayHeight];
    currentWeight = posX*MAX_WEIGHTS/displayWidth;

    Joint lhJoint = skeleton.getJoint("lefthand");
    int lhX = round(lh.x);

    //if (frameCount % 60 == 0) {
    //  println(frameCount + " " + lhX + " " + lastLhX + " " + lastDir);
    //}
    if (abs(lhX - lastLhX) > MOV_THRESHOLD && (lhX - lastLhX) * lastDir < 0) {
      // hit detection depending simply on movement
      lastLhX = lhX;
      lastDir *= -1; 

      bubbles.add(new Bubble(posX, posY, 4000, currentColor, currentWeight, volume));
      newBubble = true;

      // reset or it may draw too often
      lhJoint.resetHit();
    }

    background(100);
    int millisGone = (int) (millis() - lastTime);
    lastTime = millis();

    // draw notes
    for (int i = bubbles.size()-1; i >= 0; i--) {
      Bubble b = bubbles.get(i);
      b.draw();
      b.update(millisGone);
    }

    // pointer
    strokeWeight(5);
    stroke(0, 20);
    fill(currentColor, 20);
    ellipse(posX, posY, newBubble?60:30, newBubble?60:30);
  }
}


class Bubble {
  // duration in milliseconds
  // bubbleColor depends on the y-axis value, the display is separated into 3 layers
  // weight depends on the x-axis value, the display is separated into 15 layers
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

// OSC CALLBACK FUNCTIONS

void oscEvent(OscMessage m) {
  skeleton.parseOSC(m);
}

