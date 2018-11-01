void setup() {
  size(200, 200);
}

float sv = -1.5;
float ep = -100;
void draw() {
  background(0);
  if (sv > 1.5) {
    sv = -1.5;
    ep += 10;
  } else sv += .1;
  
  PathData testData = new PathFactory(0, sv, ep, 0, 2, .1, .01).data;
  testData.show();
  Actuator actuator = new Actuator();
  PathExecutor pathExecutor = new PathExecutor(testData, actuator);
  
  for (float time = 0; time < 100; time += 1) {
    pathExecutor.update(time);
    actuator.update(time);
    
    set((int) time, 100 + (int) pathExecutor.errorP, color(0, 255, 255));
    actuator.show();
  }
}
