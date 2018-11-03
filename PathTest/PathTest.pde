void setup() {
  size(200, 200);
}

float sv = -1.5;
float ep = 0;
void draw() {
  ep = abs(mouseY - 100);
  sv = -(mouseX * .015 - 1.5);
  
  background(0);
  PathGenerator test = new PathGenerator(0, sv, ep, sin(millis() * .002), 2, .1);
  test.update();
  PathData testData = test.getPathData(.1);
  testData.show();
  stroke(255);
  line(0, 100 - ep, 200, 100 - ep);
}
