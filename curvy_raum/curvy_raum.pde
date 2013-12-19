// winniae@launsch.de GPL v3


int MAX_LINES = 20;
float[][] distortion = new float[MAX_LINES][10];

int WIN_X = 1000;
int WIN_Y = 800;

void setup() {
  size(WIN_X, WIN_Y, P3D);

  for (int j=0; j<10; j++) {
    for (int line=0; line<1; line++) {
      distortion[line][j] = random(-20, +20);
    }
  }
}

void draw() {
  background(255);
  noFill();

  //beginCamera();
  //camera();
  //translate(mouseX, 0, 0);
  //endCamera();
  translate(WIN_X/2 - MAX_LINES/2.0 * 50,0,0);
  
  strokeWeight(5);

  for (int line=1; line<=MAX_LINES; line++) {
    stroke(50*line, 10*line, 20*line);
    
    beginShape();


    if (line > 1 && line <= 1+ MAX_LINES  /3) {
      translate(50, 0, -200);
    }
    else if (line > MAX_LINES *2/3) {
      translate(50, 0, 200);
    }
    else {
      translate(50, 0, 0);
    }

    curveVertex(0, 50);
    curveVertex(0, 50);

    for (int i=0; i<10; i++) {
      curveVertex(distortion[line-1][i], (i+2)*50);

      if (line == 1) {
        int ydist = mouseY/50;
        if (i == ydist && mouseX < WIN_X/2) {
          distortion[line-1][i] = mouseX-50;
        }
        else {
          distortion[line-1][i] *= 0.95;
        }
      }
      else if (line == MAX_LINES) {
        int ydist = mouseY/50;
        if (i == ydist && mouseX > WIN_X/2) {
          distortion[line-1][i] = mouseX - WIN_X;
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

    curveVertex(0, 12*50);
    curveVertex(0, 12*50);
    endShape();
  }
}

