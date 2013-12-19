// winniae@launsch.de GPL v3

float[][] distortion = new float[10][10];

void setup() {
  size(800, 800, P3D);

  for (int j=0; j<10; j++) {
    for (int line=0; line<1; line++) {
      distortion[line][j] = random(-20, +20);
    }
  }
}

void draw() {
  background(255);
  noFill();

  for (int line=1; line<=10; line++) {
    beginShape();
    curveVertex(line*50, 50);
    curveVertex(line*50, 50);

    for (int i=0; i<10; i++) {
      curveVertex(line*50 + distortion[line-1][i], (i+2)*50);

      if (line == 1) {
        int ydist = mouseY/50;
        if (i == ydist && mouseX < 250) {
          distortion[line-1][i] = mouseX-50;
        }
        else {
            distortion[line-1][i] *= 0.95;
            println(distortion[line-1]);
        }
      }
      else if (line == 10) {
        int ydist = mouseY/50;
        if (i == ydist && mouseX > 250) {
          distortion[line-1][i] = mouseX - 500;
        }
        else {
            distortion[line-1][i] *= 0.95;
        }
      }
      else {
        // difference between the two distortions

        distortion[line-1][i] += (distortion[line-2][i] - distortion[line-1][i])/5 + (distortion[line-0][i] - distortion[line-1][i])/5;
      }
    }

    curveVertex(line*50, 12*50);
    curveVertex(line*50, 12*50);
    endShape();
  }
}

