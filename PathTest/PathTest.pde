void setup() {
  size(200, 200);
  noLoop();
}

void draw() {
  background(0);
  PathData data = generateTestPath();
  data.show();
  println(deltaVelocityToDeltaPosition(0, 1, 1, .01));
}

PathData generateTestPath() {
  PathData data = new PathData();
  
  float timestep = 1;
  float maxvel = 2;
  float maxacc = .05;
  
  float time = 0;
  float pos = 0;
  float vel = 0;
  float acc = 0;
  
  while (vel < maxvel) {
    acc = maxacc;
    vel += acc * timestep;
    pos += vel * timestep;
    data.states.add(new PathState(time, pos, vel, acc));
    time += timestep;
  }
  while (pos < 100) {
    acc = 0;
    vel += acc * timestep;
    pos += vel * timestep;
    data.states.add(new PathState(time, pos, vel, acc));
    time += timestep;
  }
  while (vel > 0) {
    acc = -maxacc;
    vel += acc * timestep;
    pos += vel * timestep;
    data.states.add(new PathState(time, pos, vel, acc));
    time += timestep;
  }
  return data;
}

float deltaVelocityToDeltaPosition(float vel1, float vel2, float acc1, float timestep) {
  if (vel1 > vel2) {
    float tmp = vel1;
    vel1 = vel2;
    vel2 = tmp;
  }
  
  float time = 0;
  float pos = 0;
  float vel = vel1;
  float acc = acc1;
  
  while (vel < vel2) {
    acc = acc1;
    vel += acc * timestep;
    pos += vel * timestep;
    time += timestep;
  }
  
  return pos;
}
