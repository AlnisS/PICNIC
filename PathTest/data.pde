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
    set((int) time, (int) pos + 100, #FF0000);
    set((int) time, (int) (vel * 40 + 100), #00FF00);
    set((int) time, (int) (acc * 40 + 100), #0000FF);
  }
}

class PathData {
  ArrayList<PathState> states;
  float timestep;
  
  PathData() {
    this(new ArrayList<PathState>());
  }
  
  PathData(ArrayList<PathState> states) {
    this.states = states;
  }
  
  PathState getAtTime(float time) {
    int index = (int) (time / timestep);
    println(time, timestep);
    if (states.size() == 0) return new PathState(0, 0, 0, 0);
    return index >= states.size() ? states.get(states.size() - 1) : states.get(index);
  }
  
  void show() {
    for (PathState state : states) {
      state.show();
    }
  }
}
