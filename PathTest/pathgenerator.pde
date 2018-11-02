class PathGenerator {
  float p1;
  float p2;
  float p3;
  float p4;
  float p5;
  float p6;

  float a1;
  float b1;

  float m2;
  float a2;
  float b2;

  float m3;

  float t1;
  float q1;
  float b3;
  float t2;
  float q2;
  float a3;
  float i3;
  float i0;

  float v1;
  float i4;
  float b4;

  PathGenerator(float p1, float p2, float p3, float p4, float p5, float p6) {
    this.p1 = p1;
    this.p2 = p2;
    this.p3 = p3;
    this.p4 = p4;
    this.p5 = p5;
    this.p6 = p6;
  }

  void update() {
    a1 = .5 * p6;
    b1 = p2;

    m2 = p5;
    a2 = (p5 - p2) / p6;
    b2 = f(a2);

    m3 = - p6 / 2;

    t1 = p4 / p6;
    q1 = p6 / 2 * t1 * t1;
    b3 = p3 + q1;
    t2 = p5 / p6;
    q2 = p6 / 2 * t2 * t2;
    a3 = (b3 - q2 - b2) / m2 + t2 + a2;
    i3 = a3 - t2;
    i0 = a3 + t1;

    v1 = -b1 / (2 * a1);
    i4 = (a3 + v1) / 2;
    b4 = f(i4) - h(i4);
  }

  // requres a1 and b1
  float f(float t) {
    return a1 * t * t + b1 * t;
  }

  // requires m2, a2, and b2
  float g(float t) {
    return m2 * (t - a2) + b2;
  }

  // requires m3, a3, and b3
  float h(float t) {
    return m3 * (t - a3) * (t - a3) + b3;
  }

  PathData getPathData(float timestep) {
    boolean two = a2 > i3;

    PathData pathData = new PathData();
    for (float time = 0; time < a3 + t1; time += timestep) {
      float pos;
      float vel;
      float acc;
      float a = 0;
      float b = 0;
      float c = 0;
      if (two) {
      } else {
        if (time < a2) {
          a = f(time);
          b = f(time + .01);
          c = f(time + .02);
        } else if (a2 <= time && time < i3) {
          a = g(time);
          b = g(time + .01);
          c = g(time + .02);
        } else if (i3 <= time && time < i0) {
          a = h(time);
          b = h(time + .01);
          c = h(time + .02);
        }
      }
      pos = a;
      vel = (b - a) / .01;
      float vel2 = (c - b) / .01;
      acc = (vel2 - vel) / .01;

      pathData.states.add(new PathState(time, pos, vel, acc));
    }
    return pathData;
  }
}
