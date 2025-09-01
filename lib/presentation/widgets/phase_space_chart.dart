import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:rk4_solver/domain/services/simulation_runner.dart';

class PhaseSpaceChart extends StatelessWidget {
  final SimulationResult? result;
  const PhaseSpaceChart({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final points = result?.points ?? [];
    final spots = points.map((p) => FlSpot(p.theta, p.omega)).toList();

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: false,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
            color: Colors.red,
          ),
        ],
        titlesData: const FlTitlesData(show: true),
        gridData: const FlGridData(show: true),
      ),
    );
  }
}

