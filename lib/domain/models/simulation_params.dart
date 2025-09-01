class SimulationParams {
  final double theta0; // initial angle [rad]
  final double omega0; // initial angular velocity [rad/s]
  final double t0;     // start time [s]
  final double tEnd;   // end time [s]
  final double h;      // step size [s]
  final double g;      // gravity [m/s^2]
  final double L;      // pendulum length [m]

  const SimulationParams({
    required this.theta0,
    required this.omega0,
    required this.t0,
    required this.tEnd,
    required this.h,
    this.g = 9.8,
    this.L = 1.0,
  });

  factory SimulationParams.defaults() => const SimulationParams(
        theta0: 0.5,
        omega0: 0.0,
        t0: 0.0,
        tEnd: 5.0,
        h: 0.1,
      );

  SimulationParams copyWith({
    double? theta0,
    double? omega0,
    double? t0,
    double? tEnd,
    double? h,
    double? g,
    double? L,
  }) {
    return SimulationParams(
      theta0: theta0 ?? this.theta0,
      omega0: omega0 ?? this.omega0,
      t0: t0 ?? this.t0,
      tEnd: tEnd ?? this.tEnd,
      h: h ?? this.h,
      g: g ?? this.g,
      L: L ?? this.L,
    );
  }
}

