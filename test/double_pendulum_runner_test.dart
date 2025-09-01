import 'package:flutter_test/flutter_test.dart';
import 'package:rk4_solver/domain/models/double_pendulum_params.dart';
import 'package:rk4_solver/domain/services/double_pendulum_runner.dart';

void main() {
  group('DoublePendulumRunner', () {
    test('出力点数・初期条件の検証', () {
      final params = const DoublePendulumParams(
        theta1: 1.0,
        omega1: 0.0,
        theta2: -0.5,
        omega2: 0.0,
        m1: 1.0,
        m2: 1.0,
        L1: 1.0,
        L2: 1.0,
        g: 9.8,
        t0: 0.0,
        tEnd: 1.0,
        h: 0.1,
      );

      final result = DoublePendulumRunner.run(params);
      final points = result.points;

      // 0.0..1.0 を 0.1 刻み => 11 点
      expect(points.length, 11);

      // 先頭は初期条件と一致
      final first = points.first;
      expect(first.t, closeTo(params.t0, 1e-12));
      expect(first.theta1, closeTo(params.theta1, 1e-12));
      expect(first.omega1, closeTo(params.omega1, 1e-12));
      expect(first.theta2, closeTo(params.theta2, 1e-12));
      expect(first.omega2, closeTo(params.omega2, 1e-12));

      // 時刻は単調増加
      for (int i = 1; i < points.length; i++) {
        expect(points[i].t, greaterThan(points[i - 1].t));
      }
    });
  });
}

