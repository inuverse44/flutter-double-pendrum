typedef ODESystem = List<double> Function(double t, List<double> y);

List<List<double>> rungeKutta4System(
  ODESystem f,
  List<double> y0,
  double t0,
  double tEnd,
  double h,
) {
  // Ensure h is positive to avoid infinite loops.
  if (h <= 0) {
    return [];
  }

  final results = <List<double>>[];
  double t = t0;
  final y = List<double>.from(y0);

  while (t <= tEnd + 1e-12) {
    results.add([t, ...y]);

    final k1 = f(t, y).map((v) => h * v).toList();
    final k2 = f(
      t + h / 2,
      [for (int i = 0; i < y.length; i++) y[i] + k1[i] / 2],
    ).map((v) => h * v).toList();
    final k3 = f(
      t + h / 2,
      [for (int i = 0; i < y.length; i++) y[i] + k2[i] / 2],
    ).map((v) => h * v).toList();
    final k4 = f(
      t + h,
      [for (int i = 0; i < y.length; i++) y[i] + k3[i]],
    ).map((v) => h * v).toList();

    for (int i = 0; i < y.length; i++) {
      y[i] += (k1[i] + 2 * k2[i] + 2 * k3[i] + k4[i]) / 6;
    }

    t += h;
  }

  return results; // [[t, y0, y1, ...], ...]
}

