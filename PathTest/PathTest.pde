void setup() {
  size(200, 200);
  //noLoop();
}

float sv = -1.5;
float ep = 0;
void draw() {
  background(0);
  //PathData data = generateTestPath();
  //println(mouseX * .015 - 1.5);
  //generatePath(100, mouseX * .015 - 1.5, mouseY, 0, 2, .1, .01).show();
  //println(deltaVelocityToDeltaPosition(0, 1, 1, .01));
  //println("done");
  
  if (sv > 1.5) {
    sv = -1.5;
    ep += 5;
  } else sv += .1;
  println(sv, ep);
  //generatePath(100, sv, ep, 0, 2, .1, .01).show();
  new PathFactory(100, sv, ep, 0, 2, .1, .1).data.show();
  //println("start");
  //generatePath(100, 1.4, 90, 0, 2, .1, .01).show();
  //new PathFactory(100, 0, 150, 0, 2, .1, .01).data.show();
  //println("done");
}

PathData generatePath(float i_pos, float i_vel, float f_pos, float f_vel, float max_vel, float max_acc, float timestep) {
  PathData data = new PathData();
  
  float time = 0;
  float pos = i_pos;
  float vel = i_vel;
  float acc = 0;
  
  float direction = f_pos > i_pos ? 1 : -1;
  if (f_pos == i_pos) direction = i_vel < 0 ? 1 : -1;
  
  while (abs(vel) < max_vel && abs(deltaVelocityToDeltaPosition(vel, 0, max_acc, timestep)) < abs(f_pos - pos)) {
    acc = max_acc * direction;
    vel += acc * timestep;
    pos += vel * timestep;
    data.states.add(new PathState(time, pos, vel, acc));
    time += timestep;
  }
  while (abs(deltaVelocityToDeltaPosition(vel, 0, max_acc, timestep)) < abs(f_pos - pos)) {
    acc = 0;
    vel += acc * timestep;
    pos += vel * timestep;
    data.states.add(new PathState(time, pos, vel, acc));
    time += timestep;
  }
  while (abs(vel) > max_acc) {
    acc = -max_acc * direction;
    vel += acc * timestep;
    pos += vel * timestep;
    data.states.add(new PathState(time, pos, vel, acc));
    time += timestep;
    println(vel, max_acc);
    delay(10);
  }
  data.states.add(new PathState(time, pos + vel * timestep, 0, -vel));
  
  return data;
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
