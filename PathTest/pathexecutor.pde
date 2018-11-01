class PathExecutor {
  final float kP = 1;
  
  PathData pathData;
  Actuator actuator;
  
  float errorP;
  
  PathExecutor(PathData pathData, Actuator actuator) {
    this.pathData = pathData;
    this.actuator = actuator;
  }
  
  void update(float time) {
    PathState currentState = pathData.getAtTime(time);
    errorP = kP * (currentState.pos - actuator.pos);
    actuator.setVelocity(currentState.vel + errorP);
  }
}
