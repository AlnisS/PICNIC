void setup() {
  size(200, 200);
}

float sv = -1.5;
float ep = 0;
void draw() {
  background(0);
  if (sv > 1.5) {
    sv = -1.5;
    ep += 10;
  } else sv += .1;
  PathGenerator test = new PathGenerator(0, sv, ep, 1, 2, .1);
  test.update();
  PathData testData = test.getPathData(.1);
  testData.show();
}
