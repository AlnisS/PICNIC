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
    
    //println(p_m1(1, 1, 5, 7));
    //println((a3 - b1 / (2 * a1)) / 2);
  }

  // requres a1 and b1
  float f(float t) {
    return a1 * t * t + b1 * t;
  }
  
  float f(float t, float a, float b) {
    return a * t * t + b * t;
  }
  
  float df(float t) {
    return 2 * a1 * t + b1;
  }
  
  float ddf(float t) {
    return 2 * a1;
  }

  // requires m2, a2, and b2
  float g(float t) {
    return m2 * (t - a2) + b2;
  }
  
  float dg(float t) {
    return m2;
  }
  
  float ddg(float t) {
    return 0;
  }

  // requires m3, a3, and b3
  float h(float t) {
    return m3 * (t - a3) * (t - a3) + b3;
  }
  
  float dh(float t) {
    return m3 * 2 * t + m3 * 2 * -a3;
  }
  
  float ddh(float t) {
    return m3 * 2;
  }

  PathData getPathData(float timestep) {
    PathData pathData = new PathData();
    float end = a3 + t1;
    if (a2 > i3)  // TODO: figure out why this works
      end = (-p4 - m3 * 2 * -a3) / (m3 * 2) + parabolaOffset(a1, b1, a3, b3);
    for (float time = 0; time < end; time += timestep) {
      pathData.states.add(getAtTime(time));
    }
    return pathData;
  }
  
  PathState getAtTime(float time) {
    boolean two = a2 > i3;
    
    float pos = 0;
    float vel = 0;
    float acc = 0;
    if (two) {
      float midpoint = q1(a1, b1, -p_m1(a1, b1, a3, b3), 1);
      //println(q1(1.1, 4, 
      if (time < midpoint) {
        pos = f(time);
        vel = df(time);
        acc = ddf(time);
      } else {
        float o = parabolaOffset(a1, b1, a3, b3);
        pos = h(time - o);
        vel = dh(time - o);
        acc = ddh(time - o);
      }
    } else {
      if (time < a2) {
        pos = f(time);
        vel = df(time);
        acc = ddf(time);
      } else if (a2 <= time && time < i3) {
        pos = g(time);
        vel = dg(time);
        acc = ddg(time);
      } else if (i3 <= time && time < i0) {
        pos = h(time);
        vel = dh(time);
        acc = ddh(time);
      }
    }
    return new PathState(time, pos, vel, acc);
  }
  
  float p_m1(float a, float b, float h, float k) {
    return (k + f(-b / (2 * a), a, b)) / 2;
  }
  
  float parabolaOffset(float a, float b, float h, float k) {
    float p_m1 = p_m1(a, b, h, k);
    float p_r0 = q1(a, b, -p_m1, 1);
    float p_r1 = q1(-a, 2 * a * h, -a * pow(h, 2) + k - p_m1, 1);
    return p_r0 - p_r1;
  }
}

float q1(float a0, float b0, float c0, float s0) {
  return (-b0 + s0 * sqrt(pow(b0, 2) - 4 * a0 * c0)) / (2 * a0);
}
