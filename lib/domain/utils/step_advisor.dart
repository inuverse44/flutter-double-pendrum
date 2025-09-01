import 'dart:math' as math;

import 'package:rk4_solver/domain/models/double_pendulum_params.dart';

class StepAdvisor {
  /// Small-angle linearization around (theta1, theta2) = (0, 0) yields
  /// M * theta_ddot + K * theta = 0, where
  ///   M = [[(m1+m2)L1^2, m2 L1 L2], [m2 L1 L2, m2 L2^2]]
  ///   K = [[(m1+m2) g L1, 0],       [0,        m2 g L2 ]]
  /// Solve det(K - λ M) = 0 for λ = ω^2 to obtain two modal frequencies ω.
  static List<double> normalModeFrequencies(DoublePendulumParams p) {
    final m1 = p.m1, m2 = p.m2, L1 = p.L1, L2 = p.L2, g = p.g;
    if (!(m1 > 0 && m2 > 0 && L1 > 0 && L2 > 0) || !g.isFinite || g < 0) {
      return const [0.0, 0.0];
    }

    final m11 = (m1 + m2) * L1 * L1;
    final m22 = m2 * L2 * L2;
    final m12 = m2 * L1 * L2;

    final a = (m1 + m2) * g * L1; // K11
    final b = m2 * g * L2;        // K22

    // Quadratic in λ: c2 λ^2 - c1 λ + c0 = 0
    final c2 = m11 * m22 - m12 * m12; // > 0 for positive masses/lengths
    final c1 = a * m22 + b * m11;
    final c0 = a * b;

    if (!(c2 > 0)) {
      return const [0.0, 0.0];
    }

    final disc = c1 * c1 - 4 * c2 * c0;
    final sqrtDisc = disc <= 0 ? 0.0 : math.sqrt(disc);
    final l1 = (c1 + sqrtDisc) / (2 * c2);
    final l2 = (c1 - sqrtDisc) / (2 * c2);

    double w1 = l1 <= 0 ? 0.0 : math.sqrt(l1);
    double w2 = l2 <= 0 ? 0.0 : math.sqrt(l2);

    // Return sorted descending by frequency (wMax first)
    if (w1 < w2) {
      final tmp = w1; w1 = w2; w2 = tmp;
    }
    return [w1, w2];
  }

  /// Recommend a maximum step h so that there are [cyclesPerPeriod] samples per
  /// period of the fastest (highest) mode. If g==0 or ω_max==0, returns +inf.
  static double recommendedMaxStep(DoublePendulumParams p, {int cyclesPerPeriod = 50}) {
    final freqs = normalModeFrequencies(p);
    final wMax = freqs[0];
    if (!(wMax > 0)) return double.infinity;
    final periodMin = 2 * math.pi / wMax;
    return periodMin / cyclesPerPeriod;
  }
}

