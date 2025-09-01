import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:rk4_solver/domain/ode/rk4.dart';

void main() {
  group('RK4 基本テスト', () {
    test('h <= 0 の場合は空配列を返す', () {
      final resZero = rungeKutta4System((t, y) => [0.0], [1.0], 0.0, 1.0, 0.0);
      final resNeg = rungeKutta4System((t, y) => [0.0], [1.0], 0.0, 1.0, -0.1);
      expect(resZero, isEmpty);
      expect(resNeg, isEmpty);
    });

    test('f(t,y)=0 の場合は常に一定（恒等）', () {
      final y0 = [3.14, -2.0];
      final res = rungeKutta4System((t, y) => [0.0, 0.0], y0, 0.0, 1.0, 0.1);
      // 0.0..1.0 を 0.1 で刻むので 11 点を期待
      expect(res.length, 11);
      for (final row in res) {
        // row = [t, y0, y1]
        expect(row[1], closeTo(y0[0], 1e-12));
        expect(row[2], closeTo(y0[1], 1e-12));
      }
    });

    test('一次方程式 dy/dt = y の近似精度（y(0)=1 => y(t)=e^t）', () {
      final res = rungeKutta4System((t, y) => [y[0]], [1.0], 0.0, 1.0, 0.01);
      // 最後の行
      final last = res.last;
      final t = last.first;
      final yNum = last[1];
      final yExact = math.exp(t);
      expect(yNum, closeTo(yExact, 1e-4));
    });
  });
}

