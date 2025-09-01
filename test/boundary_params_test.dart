import 'package:flutter_test/flutter_test.dart';
import 'package:rk4_solver/domain/models/double_pendulum_params.dart';
import 'package:rk4_solver/domain/services/double_pendulum_runner.dart';

void main() {
  group('境界値テスト: 物理パラメータ 0/無効時の挙動', () {
    const base = DoublePendulumParams(
      theta1: 0.1,
      omega1: 0.0,
      theta2: -0.2,
      omega2: 0.0,
      m1: 1.0,
      m2: 1.0,
      L1: 1.0,
      L2: 1.0,
      g: 9.8,
      t0: 0.0,
      tEnd: 0.5,
      h: 0.01,
    );

    test('L1=0 → 結果は空', () {
      final p = base.copyWith(L1: 0.0);
      final r = DoublePendulumRunner.run(p);
      expect(r.points, isEmpty);
    });

    test('L2=0 → 結果は空', () {
      final p = base.copyWith(L2: 0.0);
      final r = DoublePendulumRunner.run(p);
      expect(r.points, isEmpty);
    });

    test('m1=0 → 結果は空', () {
      final p = base.copyWith(m1: 0.0);
      final r = DoublePendulumRunner.run(p);
      expect(r.points, isEmpty);
    });

    test('m2=0 → 結果は空', () {
      final p = base.copyWith(m2: 0.0);
      final r = DoublePendulumRunner.run(p);
      expect(r.points, isEmpty);
    });

    test('g=0（無重力）→ 計算は可能（空ではない）', () {
      final p = base.copyWith(g: 0.0);
      final r = DoublePendulumRunner.run(p);
      expect(r.points.length, greaterThan(1));
    });

    test('tEnd == t0 → 1点のみ', () {
      final p = base.copyWith(tEnd: base.t0);
      final r = DoublePendulumRunner.run(p);
      expect(r.points.length, 1);
      expect(r.points.first.t, equals(p.t0));
    });

    test('h<=0 → 結果は空（ランナーのガード/内部RK4の仕様）', () {
      final p = base.copyWith(h: 0.0);
      final r = DoublePendulumRunner.run(p);
      expect(r.points, isEmpty);
    });
  });
}

