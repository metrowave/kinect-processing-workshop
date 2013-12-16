// winniae@launsch.de GPL v3

import oscP5.*;
OscP5 oscP5;

// our Synapse tracked skeleton data
Skeleton skeleton = new Skeleton();

// five colors, fünf flächen
int[] colors = {
};

ArrayList<Bubble> bubbles = new ArrayList<Bubble>();
long lastTime;

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

    int posX = round(map(constrain(rh.x, 200, 400), 200, 400, 0, displayWidth));
    int posY = round(map(constrain(rh.y, 200, 400), 200, 400, 0, displayHeight));
    int currentColor;

    // current color
    // draw pointer
    if (posY < displayHeight/5) {
      currentColor = colors[0];
    }
    else if (posY < displayHeight*2/5) {
      currentColor = colors[1];
    }
    else if (posY < displayHeight*3/5) {
      currentColor = colors[2];
    }
    else if (posY < displayHeight*4/5) {
      currentColor = colors[3];
    }
    else {
      currentColor = colors[4];
    }


    Joint lhJoint = skeleton.getJoint("lefthand");

    // special
    if (lhJoint.hitDetected()) {
      if (lhJoint.hitForward) {
        // clear
        bubbles.clear();
      }
      else if (lhJoint.hitDown) {
        bubbles.add(new Bubble(posX, posY, 500, currentColor));
      }
      else if (lhJoint.hitLeft) {
        bubbles.add(new Bubble(posX, posY, 1000, currentColor));
      }
      else if (lhJoint.hitRight) {
        bubbles.add(new Bubble(posX, posY, 2000, currentColor));
      }
      else if (lhJoint.hitUp) {
        bubbles.add(new Bubble(posX, posY, 4000, currentColor));
      }

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
    fill(currentColor);
    ellipse(posX, posY, 30, 30);
  }
}


class Bubble {
  // duration in milliseconds
  int posX, posY, duration, bubbleColor;

  Bubble(int posX, int posY, int duration, int bubbleColor) {
    this.posX = posX;
    this.posY = posY;
    this.duration = duration;
    this.bubbleColor = bubbleColor;
  }

  void draw() {
    strokeWeight(0);
    fill(bubbleColor);
    ellipse(posX, posY, sqrt(duration)*5, sqrt(duration)*5);
  }

  void update(int millisGone) {
    this.duration -= millisGone;
    if (this.duration <=0) {
      bubbles.remove(this);
    }
  }
}

// OSC CALLBACK FUNCTIONS

void oscEvent(OscMessage m) {
  skeleton.parseOSC(m);
}

