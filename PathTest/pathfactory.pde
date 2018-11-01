class PathFactory {
  PathData data;
  
  float time;
  float pos;
  float vel;
  float acc;
  
  float i_pos, i_vel;
  float f_pos, f_vel;
  float max_vel, max_acc;
  
  float timestep;
  
  PathFactory(float i_pos, float i_vel, float f_pos, float f_vel, float max_vel, float max_acc, float timestep) {
    this.i_pos = i_pos;
    this.i_vel = i_vel;
    this.f_pos = f_pos;
    this.f_vel = f_vel;
    this.max_vel = max_vel;
    this.max_acc = max_acc;
    this.timestep = timestep;
    data = new PathData();
    data.timestep = this.timestep;
    
    this.pos = i_pos;
    this.vel = i_vel;
    
    if (!(direction(i_pos, f_pos) == direction(0, vel) && canDo(f_vel, abs(f_pos - i_pos))))
      cancelVelocity(0);
    
    accelerateTowardsTarget();
    continueLinearly();
    cancelVelocity(f_vel);
  }
  
  void cancelVelocity(float targ) {
    while (abs(vel - targ) > max_acc) {
      acc = max_acc * -direction(targ, vel);
      vel += acc * timestep;
      pos += vel * timestep;
      data.states.add(new PathState(time, pos, vel, acc));
      time += timestep;
    }
  }
  
  void accelerateTowardsTarget() {
    while (abs(vel) < max_vel && canDo(f_vel, abs(f_pos - pos))) {
      acc = max_acc * direction(pos, f_pos);
      vel += acc * timestep;
      pos += vel * timestep;
      data.states.add(new PathState(time, pos, vel, acc));
      time += timestep;
    }
  }
  
  void continueLinearly() {
    while (canDo(f_vel, abs(f_pos - pos))) {
      acc = 0;
      vel += acc * timestep;
      pos += vel * timestep;
      data.states.add(new PathState(time, pos, vel, acc));
      time += timestep;
    }
  }
  
  void zeroPoint() {
    
  }
  float displacementUntilVelocity(float targvel) {
    float time = 0;
    float pos = 0;
    float vel = this.vel;
    float acc = max_acc * direction(vel, targvel);
    while (abs(targvel - vel) > max_acc) {
      acc = max_acc * direction(vel, targvel);
      vel += acc * timestep;
      pos += vel * timestep;
      time += timestep;
    }
    return pos;
  }
  
  boolean canDo(float targvel, float distance) {
    return abs(displacementUntilVelocity(targvel)) < distance;
  }
}

float direction(float a, float b) {
  return a <= b ? 1 : -1;
}
