import 'package:flutter_test/flutter_test.dart';
import 'package:rk4_solver/domain/ode/double_pendulum.dart';

void main() {
  group('二重振り子 ODE', () {
    test('静止（角度・角速度すべて 0）では微分係数は 0', () {
      final dydt = doublePendulum(0.0, [0.0, 0.0, 0.0, 0.0],
          m1: 1.2, m2: 0.8, L1: 1.0, L2: 1.5, g: 9.8);

      expect(dydt.length, 4);
      expect(dydt[0], closeTo(0.0, 1e-12)); // dtheta1/dt = omega1 = 0
      expect(dydt[2], closeTo(0.0, 1e-12)); // dtheta2/dt = omega2 = 0
      expect(dydt[1], closeTo(0.0, 1e-12)); // domega1/dt = 0
      expect(dydt[3], closeTo(0.0, 1e-12)); // domega2/dt = 0
    });
  });
}

