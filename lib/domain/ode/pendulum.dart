import 'dart:math';

List<double> pendulum(double t, List<double> y, {double g = 9.8, double L = 1.0}) {
  final theta = y[0];
  final omega = y[1];
  final dtheta = omega;
  final domega = -(g / L) * sin(theta);
  return [dtheta, domega];
}

