// kind of hacky, but good enough for testing
class Actuator {
  float time;
  float pos;
  float vel;
  float acc;
  float timestep = .001;
  
  float tarvel;
  
  Actuator() {
    time = 0;
    pos = 0;
    vel = 0;
    acc = 0;
  }
  
  void update(float time) {
    while (this.time < time) {
      acc = 0;  // not currently used
      vel = .9999 * vel + .0001 * tarvel;  // make the actuator very sluggish
      if (vel > 3) vel = 3;  // limit motor speed
      pos += vel * timestep;
      this.time += timestep;
    }
  }
  
  void setVelocity(float f) {
    tarvel = f;
  }
  
  void show() {
    set((int) time, (int) pos + 100, color(255, 255, 0));
  }
}
