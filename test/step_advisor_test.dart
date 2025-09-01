import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:rk4_solver/domain/models/double_pendulum_params.dart';
import 'package:rk4_solver/domain/utils/step_advisor.dart';

void main() {
  group('StepAdvisor 正常系', () {
    const base = DoublePendulumParams(
      theta1: 0.0,
      omega1: 0.0,
      theta2: 0.0,
      omega2: 0.0,
      m1: 1.0,
      m2: 1.0,
      L1: 1.0,
      L2: 1.0,
      g: 9.8,
      t0: 0.0,
      tEnd: 1.0,
      h: 0.01,
    );

    test('固有角振動数は非負で、最大>=最小', () {
      final w = StepAdvisor.normalModeFrequencies(base);
      expect(w.length, 2);
      expect(w[0], greaterThanOrEqualTo(0));
      expect(w[1], greaterThanOrEqualTo(0));
      expect(w[0], greaterThanOrEqualTo(w[1]));
    });

    test('推奨刻みは最短周期/50', () {
      final w = StepAdvisor.normalModeFrequencies(base);
      final wMax = w[0];
      final hRec = StepAdvisor.recommendedMaxStep(base, cyclesPerPeriod: 50);
      if (wMax > 0) {
        final expected = 2 * math.pi / wMax / 50.0;
        expect(hRec, closeTo(expected, expected * 1e-12 + 1e-12));
      } else {
        expect(hRec, equals(double.infinity));
      }
    });
  });

  group('StepAdvisor 境界', () {
    test('g=0 → 周期無限大 → hRec=inf', () {
      const p = DoublePendulumParams(
        theta1: 0,
        omega1: 0,
        theta2: 0,
        omega2: 0,
        m1: 1,
        m2: 1,
        L1: 1,
        L2: 1,
        g: 0,
      );
      final hRec = StepAdvisor.recommendedMaxStep(p);
      expect(hRec, double.infinity);
    });

    test('L1 を小さくすると推奨刻みは小さくなる（速いモード）', () {
      const p1 = DoublePendulumParams(theta1: 0, omega1: 0, theta2: 0, omega2: 0, m1: 1, m2: 1, L1: 1, L2: 1, g: 9.8);
      const p2 = DoublePendulumParams(theta1: 0, omega1: 0, theta2: 0, omega2: 0, m1: 1, m2: 1, L1: 0.5, L2: 1, g: 9.8);
      final h1 = StepAdvisor.recommendedMaxStep(p1);
      final h2 = StepAdvisor.recommendedMaxStep(p2);
      expect(h2, lessThan(h1));
    });

    test('L を大きくすると推奨刻みは大きくなる（遅いモード）', () {
      const p1 = DoublePendulumParams(theta1: 0, omega1: 0, theta2: 0, omega2: 0, m1: 1, m2: 1, L1: 1, L2: 1, g: 9.8);
      const p2 = DoublePendulumParams(theta1: 0, omega1: 0, theta2: 0, omega2: 0, m1: 1, m2: 1, L1: 2, L2: 2, g: 9.8);
      final h1 = StepAdvisor.recommendedMaxStep(p1);
      final h2 = StepAdvisor.recommendedMaxStep(p2);
      expect(h2, greaterThan(h1));
    });
  });
}

