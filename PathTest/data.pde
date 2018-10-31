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
    set((int) time, (int) pos, #FF0000);
    set((int) time, (int) pos, #00FF00);
    set((int) time, (int) pos, #0000FF);
  }
}

class PathData {
  ArrayList<PathState> states;
  PathData() {
    this(new ArrayList<PathState>());
  }
  PathData(ArrayList<PathState> states) {
    this.states = states;
  }
  void show() {
    for (PathState state : states) {
      state.show();
    }
  }
}
