class DoublePendulumParams {
  final double theta1;
  final double omega1;
  final double theta2;
  final double omega2;
  final double m1;
  final double m2;
  final double L1;
  final double L2;
  final double g;
  final double t0;
  final double tEnd;
  final double h;

  const DoublePendulumParams({
    required this.theta1,
    required this.omega1,
    required this.theta2,
    required this.omega2,
    this.m1 = 1.0,
    this.m2 = 1.0,
    this.L1 = 1.0,
    this.L2 = 1.0,
    this.g = 9.8,
    this.t0 = 0.0,
    this.tEnd = 10.0,
    this.h = 0.01,
  });

  factory DoublePendulumParams.defaults() => const DoublePendulumParams(
        theta1: 1.0,
        omega1: 0.0,
        theta2: -0.5,
        omega2: 0.0,
      );

  DoublePendulumParams copyWith({
    double? theta1,
    double? omega1,
    double? theta2,
    double? omega2,
    double? m1,
    double? m2,
    double? L1,
    double? L2,
    double? g,
    double? t0,
    double? tEnd,
    double? h,
  }) {
    return DoublePendulumParams(
      theta1: theta1 ?? this.theta1,
      omega1: omega1 ?? this.omega1,
      theta2: theta2 ?? this.theta2,
      omega2: omega2 ?? this.omega2,
      m1: m1 ?? this.m1,
      m2: m2 ?? this.m2,
      L1: L1 ?? this.L1,
      L2: L2 ?? this.L2,
      g: g ?? this.g,
      t0: t0 ?? this.t0,
      tEnd: tEnd ?? this.tEnd,
      h: h ?? this.h,
    );
  }
}

