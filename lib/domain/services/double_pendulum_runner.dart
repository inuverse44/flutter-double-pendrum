import 'package:rk4_solver/domain/models/double_pendulum_params.dart';
import 'package:rk4_solver/domain/models/double_pendulum_point.dart';
import 'package:rk4_solver/domain/ode/double_pendulum.dart' as ode;
import 'package:rk4_solver/domain/ode/rk4.dart';

class DoublePendulumResult {
  final List<DoublePendulumPoint> points;
  const DoublePendulumResult(this.points);
}

class DoublePendulumRunner {
  static DoublePendulumResult run(DoublePendulumParams params) {
    final rows = rungeKutta4System(
      (t, y) => ode.doublePendulum(
        t,
        y,
        m1: params.m1,
        m2: params.m2,
        L1: params.L1,
        L2: params.L2,
        g: params.g,
      ),
      [params.theta1, params.omega1, params.theta2, params.omega2],
      params.t0,
      params.tEnd,
      params.h,
    );

    final points = rows
        .map((r) => DoublePendulumPoint(
              t: r[0],
              theta1: r[1],
              omega1: r[2],
              theta2: r[3],
              omega2: r[4],
            ))
        .toList();
    return DoublePendulumResult(points);
  }
}

