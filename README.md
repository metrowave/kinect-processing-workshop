kinect-processing-workshop
==========================

Example Code for a workshop teaching using the Kinect with Processing.org with the help of Synapse.


#### Basis Code für die Kinect Daten  
https://github.com/winniae/Synapse-Templates  
benötigt Processing.org library:  
http://www.sojamo.de/libraries/oscP5/
#### Skeleton Datei in Projekt kopieren
#### OSC und Skeleton Objekt erzeugen
<pre>
import oscP5.*;
OscP5 oscP5;
// our Synapse tracked skeleton data
Skeleton skeleton = new Skeleton();
void setup() {
  oscP5 = new OscP5(this, 12347);
}
</pre>
#### Minimal Skeleton drawing
<pre>
void draw() {
  skeleton.update(oscP5);
  if (skeleton.isTracking()) {
    PVector rh = skeleton.getJoint("righthand").posScreen;
    ellipse(rh.x, rh.y, 100, 100);
  }
}
</pre>
#### Muss vorhanden sein damit das Skeleton die Daten von OSC bekommt.
<pre>
// OSC CALLBACK FUNCTIONS
void oscEvent(OscMessage m) {
  skeleton.parseOSC(m);
}
</pre>
#### Kinect Positionsdaten Auswahl
<pre>
setup() {
  // what joint positions should we ask Synapse for?
  // 1: body pos, 2: world pos, 3: screen pos
  skeleton.jointPosType = 1;
}
draw() {
  ..
  Joint rh = skeleton.getJoint("righthand");
  PVector rhScreen = rh.posScreen;
  PVector rhBody = rh.posBody;
  PVector rhWorld = rh.posWorld;
}
</pre>
#### Full Screen Modus  
size(displayWidth, displayHeight);  
cmd + shift + r
#### Skalieren  
ballR = round(map(constrain(rh.y, 280, 680), 280, 680, 0, displayHeight*3/8));