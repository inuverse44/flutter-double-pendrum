import 'dart:math';

// State y = [theta1, omega1, theta2, omega2]
List<double> doublePendulum(
  double t,
  List<double> y, {
  double m1 = 1.0,
  double m2 = 1.0,
  double L1 = 1.0,
  double L2 = 1.0,
  double g = 9.8,
}) {
  final th1 = y[0];
  final w1 = y[1];
  final th2 = y[2];
  final w2 = y[3];

  final dth1 = w1;
  final dth2 = w2;

  final delta = th1 - th2;

  final denom1 = L1 * (2 * m1 + m2 - m2 * cos(2 * th1 - 2 * th2));
  final denom2 = L2 * (2 * m1 + m2 - m2 * cos(2 * th1 - 2 * th2));

  final num1 = -g * (2 * m1 + m2) * sin(th1)
      - m2 * g * sin(th1 - 2 * th2)
      - 2 * sin(delta) * m2 * (w2 * w2 * L2 + w1 * w1 * L1 * cos(delta));

  final num2 = 2 * sin(delta) * (
    w1 * w1 * L1 * (m1 + m2)
    + g * (m1 + m2) * cos(th1)
    + w2 * w2 * L2 * m2 * cos(delta)
  );

  final dw1 = num1 / denom1;
  final dw2 = num2 / denom2;

  return [dth1, dw1, dth2, dw2];
}

