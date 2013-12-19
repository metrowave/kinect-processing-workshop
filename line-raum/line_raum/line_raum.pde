// winniae@launsch.de GPL v3

int winHeight = 600;
int winWidth = 600;

int lineSpace = winWidth;
int roomWidth = winWidth;

void setup() {
  size(winHeight, winWidth, OPENGL);
}

void draw() {
  background(255);

  beginCamera();
  camera();
  translate(mouseX-winWidth/2, 0, 0);// winWidth/2-mouseY*2);
  rotateX(radians(map(mouseY, 0, displayHeight, -45, 90)));
  endCamera();



  for (int i=1; i<=10; i++) {
    //line(i*lineSpace, winHeight/4, -i*lineSpace, i*lineSpace, winHeight*3/4, -i*lineSpace);
    translate(0, 0, -lineSpace);  
    line(winWidth/2-roomWidth/2, 0, winWidth/2-roomWidth/2, winHeight);
    line(winWidth/2+roomWidth/2, 0, winWidth/2+roomWidth/2, winHeight);
  }
}

