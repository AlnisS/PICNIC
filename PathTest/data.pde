class PathState {
  float time;
  float pos;
  float vel;
  float acc;
  
  PathState(float time, float pos, float vel, float acc) {
    this.time = time;
    this.pos = pos;
    this.vel = vel;
    this.acc = acc;
  }
  
  void show() {
    set((int) time, (int) -pos + 100, #FF0000);
    set((int) time, (int) (vel * -40 + 100), #00FF00);
    set((int) time, (int) (acc * -40 + 100), #0000FF);
  }
}

class PathData {
  
  PathGenerator pathGenerator;
  
  PathData(float i_p, float i_v, float f_p, float f_v, float m_v, float m_a) {
    pathGenerator = new PathGenerator(i_p, i_v, f_p, f_v, m_v, m_a);
    pathGenerator.update();
  }
  
  PathState getAtTime(float time) {
    return pathGenerator.getAtTime(time);
  }
  
  void show() {
    for (float time = 0; !pathGenerator.isDone(time); time += .1) {
      pathGenerator.getAtTime(time).show();
    }
  }
}
