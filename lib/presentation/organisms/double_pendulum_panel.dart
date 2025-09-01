import 'package:flutter/material.dart';
import 'package:rk4_solver/domain/models/double_pendulum_params.dart';
import 'package:rk4_solver/domain/models/double_pendulum_point.dart';
import 'package:rk4_solver/presentation/organisms/double_pendulum_animator.dart';

class DoublePendulumPanel extends StatelessWidget {
  final List<DoublePendulumPoint>? points;
  final DoublePendulumParams params;
  final bool playing;
  final double speed;
  final bool showTrail;
  final int trailCount;
  const DoublePendulumPanel({
    super.key,
    required this.points,
    required this.params,
    required this.playing,
    required this.speed,
    required this.showTrail,
    required this.trailCount,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: points == null
              ? const Center(child: CircularProgressIndicator())
              : DoublePendulumAnimator(
                  points: points!,
                  params: params,
                  autoPlay: false,
                  playing: playing,
                  speed: speed,
                  showTrail: showTrail,
                  trailCount: trailCount,
                ),
        ),
      ),
    );
  }
}

