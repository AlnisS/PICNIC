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
  new PathFactory(0, sv, ep, 0, 2, .1, .01).data.show();
}
