class PathGenerator {
  float initial_position;
  float initial_velocity;
  float target_position;
  float target_velocity;
  float maximum_velocity;
  float maximum_acceleration;

  float seg1_acceleration;
  float seg1_start_speed;

  float seg2_slope;
  float seg2_start_time;
  float seg2_start_pos;

  float seg3_square_coef;

  float seg3_decceleration_time;
  float seg3_decceleration_dist;
  float seg3_vertex_pos;
  float seg3_stop_time;
  float seg3_stop_distance;
  float seg3_vertex_time;
  float seg2_end_time;
  float seg3_end_time;

  PathGenerator(float p1, float p2, float p3, float p4, float p5, float p6) {
    this.initial_position = p1;
    this.initial_velocity = p2;
    this.target_position = p3;
    this.target_velocity = p4;
    this.maximum_velocity = p5;
    this.maximum_acceleration = p6;
  }

  void update() {
    seg1_acceleration = .5 * maximum_acceleration;
    seg1_start_speed = initial_velocity;

    seg2_slope = maximum_velocity;
    seg2_start_time = (maximum_velocity - initial_velocity) / maximum_acceleration;
    seg2_start_pos = f(seg2_start_time);

    seg3_square_coef = - maximum_acceleration / 2;

    seg3_decceleration_time = target_velocity / maximum_acceleration;
    seg3_decceleration_dist = maximum_acceleration / 2 * pow(seg3_decceleration_time, 2);
    seg3_vertex_pos = target_position + seg3_decceleration_dist;
    seg3_stop_time = maximum_velocity / maximum_acceleration;
    seg3_stop_distance = maximum_acceleration / 2 * pow(seg3_stop_time, 2);
    seg3_vertex_time = (seg3_vertex_pos - seg3_stop_distance - seg2_start_pos) / seg2_slope + seg3_stop_time + seg2_start_time;
    seg2_end_time = seg3_vertex_time - seg3_stop_time;
    seg3_end_time = seg3_vertex_time + seg3_decceleration_time;
  }

  // requres a1 and b1
  float f(float t) {
    return seg1_acceleration * pow(t, 2) + seg1_start_speed * t;
  }
  
  float f(float t, float a, float b) {
    return a * pow(t, 2) + b * t;
  }
  
  float df(float t) {
    return 2 * seg1_acceleration * t + seg1_start_speed;
  }
  
  float ddf(float t) {
    return 2 * seg1_acceleration;
  }

  float g(float t) {
    return seg2_slope * (t - seg2_start_time) + seg2_start_pos;
  }
  
  float dg(float t) {
    return seg2_slope;
  }
  
  float ddg(float t) {
    return 0;
  }

  float h(float t) {
    return seg3_square_coef * (t - seg3_vertex_time) * (t - seg3_vertex_time) + seg3_vertex_pos;
  }
  
  float dh(float t) {
    return seg3_square_coef * 2 * t + seg3_square_coef * 2 * -seg3_vertex_time;
  }
  
  float ddh(float t) {
    return seg3_square_coef * 2;
  }
  
  PathState getAtTime(float time) {
    boolean cannot_reach_max_vel = seg2_start_time > seg2_end_time;
    
    float pos = 0;
    float vel = 0;
    float acc = 0;
    if (cannot_reach_max_vel) {
      float midpoint = quadratic_zero(seg1_acceleration, seg1_start_speed, -pos_midpoint(seg1_acceleration, seg1_start_speed, seg3_vertex_time, seg3_vertex_pos), 1);
      if (time < midpoint) {
        pos = f(time);
        vel = df(time);
        acc = ddf(time);
      } else {
        float o = parabolaOffset(seg1_acceleration, seg1_start_speed, seg3_vertex_time, seg3_vertex_pos);
        pos = h(time - o);
        vel = dh(time - o);
        acc = ddh(time - o);
      }
    } else {
      if (time < seg2_start_time) {
        pos = f(time);
        vel = df(time);
        acc = ddf(time);
      } else if (seg2_start_time <= time && time < seg2_end_time) {
        pos = g(time);
        vel = dg(time);
        acc = ddg(time);
      } else if (seg2_end_time <= time && time < seg3_end_time) {
        pos = h(time);
        vel = dh(time);
        acc = ddh(time);
      }
    }
    return new PathState(time, pos, vel, acc);
  }
  
  float pos_midpoint(float acceleration, float p1_initvel, float p2_vertex_time, float p2_vertex_pos) {
    return (p2_vertex_pos + f(-p1_initvel / (2 * acceleration), acceleration, p1_initvel)) / 2;
  }
  
  float parabolaOffset(float acceleration, float p1_initvel, float p2_vertex_time, float p2_vertex_pos) {
    float pos_midpoint = pos_midpoint(acceleration, p1_initvel, p2_vertex_time, p2_vertex_pos);
    float p1_end = quadratic_zero(acceleration, p1_initvel, -pos_midpoint, 1);
    float p2_start = quadratic_zero(-acceleration, 2 * acceleration * p2_vertex_time, -acceleration * pow(p2_vertex_time, 2) + p2_vertex_pos - pos_midpoint, 1);
    return p1_end - p2_start;
  }
  
  float endTime() {
    float end = seg3_vertex_time + seg3_decceleration_time;
    if (seg2_start_time > seg2_end_time)  // TODO: figure out why this works
      end = (-target_velocity - seg3_square_coef * 2 * -seg3_vertex_time) / (seg3_square_coef * 2) + parabolaOffset(seg1_acceleration, seg1_start_speed, seg3_vertex_time, seg3_vertex_pos);
    return end;
  }
  
  boolean isDone(float time) {
    return time > endTime();
  }
}

float quadratic_zero(float a, float b, float c, float sign) {
  return (-b + sign * sqrt(pow(b, 2) - 4 * a * c)) / (2 * a);
}
