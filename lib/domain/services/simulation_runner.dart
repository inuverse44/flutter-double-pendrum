import 'package:rk4_solver/domain/models/simulation_params.dart';
import 'package:rk4_solver/domain/models/simulation_point.dart';
import 'package:rk4_solver/domain/ode/pendulum.dart' as ode;
import 'package:rk4_solver/domain/ode/rk4.dart';

class SimulationResult {
  final List<SimulationPoint> points;
  const SimulationResult(this.points);
}

class SimulationRunner {
  static SimulationResult run(SimulationParams params) {
    final rows = rungeKutta4System(
      (t, y) => ode.pendulum(t, y, g: params.g, L: params.L),
      [params.theta0, params.omega0],
      params.t0,
      params.tEnd,
      params.h,
    );

    final points = rows.map((r) => SimulationPoint(t: r[0], theta: r[1], omega: r[2])).toList();
    return SimulationResult(points);
  }
}

