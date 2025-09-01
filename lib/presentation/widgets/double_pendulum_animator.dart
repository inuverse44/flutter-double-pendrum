import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rk4_solver/domain/models/double_pendulum_params.dart';
import 'package:rk4_solver/domain/models/double_pendulum_point.dart';

class DoublePendulumAnimator extends StatefulWidget {
  final List<DoublePendulumPoint> points;
  final DoublePendulumParams params;
  final bool autoPlay;
  final bool playing; // external play/pause control
  final double speed; // playback speed multiplier (0.5x–2x)
  final bool showTrail; // draw fading trail of bob2
  final int trailCount; // number of recent samples to show
  const DoublePendulumAnimator({
    super.key,
    required this.points,
    required this.params,
    this.autoPlay = true,
    this.playing = true,
    this.speed = 1.0,
    this.showTrail = false,
    this.trailCount = 120,
  });

  @override
  State<DoublePendulumAnimator> createState() => _DoublePendulumAnimatorState();
}

class _DoublePendulumAnimatorState extends State<DoublePendulumAnimator> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late int _durationMs;
  double _lastSpeed = 1.0;

  // Defensive accessors to tolerate hot-reload shape changes (old widget instances).
  bool get _isPlaying {
    try {
      final dyn = (widget as dynamic).playing;
      if (dyn is bool) return dyn;
      return true;
    } catch (_) {
      return true;
    }
  }

  double get _speedSafe {
    try {
      final dyn = (widget as dynamic).speed;
      if (dyn is num) return dyn.toDouble().clamp(0.1, 4.0);
      return 1.0;
    } catch (_) {
      return 1.0;
    }
  }

  bool get _showTrailSafe {
    try {
      final dyn = (widget as dynamic).showTrail;
      if (dyn is bool) return dyn;
      return false;
    } catch (_) {
      return false;
    }
  }

  int get _trailCountSafe {
    try {
      final dyn = (widget as dynamic).trailCount;
      if (dyn is int) return dyn.clamp(0, 2000);
      if (dyn is num) return dyn.toInt().clamp(0, 2000);
      return 120;
    } catch (_) {
      return 120;
    }
  }

  @override
  void initState() {
    super.initState();
    _durationMs = (widget.params.tEnd * 1000).clamp(200.0, 60000.0).toInt();
    _controller = AnimationController(vsync: this)
      ..addListener(() => setState(() {}));
    _lastSpeed = _speedSafe;
    _applyPlaybackState();
  }

  @override
  void didUpdateWidget(covariant DoublePendulumAnimator oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If simulation duration or params changed, update animation duration.
    final newDurationMs = (widget.params.tEnd * 1000).clamp(200.0, 60000.0).toInt();
    final sp = _speedSafe;
    if (newDurationMs != _durationMs || sp != _lastSpeed) {
      _durationMs = newDurationMs;
      _lastSpeed = sp;
      // duration is controlled via repeat(period: ...); re-apply state
      _applyPlaybackState();
    }
    // If points list instance changed (new simulation), restart animation according to playing.
    if (!identical(oldWidget.points, widget.points)) {
      _controller.reset();
      _applyPlaybackState();
    }
    // Ensure controller state matches current flags (robust to hot reload).
    _applyPlaybackState();
  }

  Duration _currentPeriod() {
    final ms = (_durationMs / _speedSafe).clamp(100.0, 120000.0).toInt();
    return Duration(milliseconds: ms);
  }

  void _applyPlaybackState() {
    final playing = _isPlaying;
    if (playing) {
      final period = _currentPeriod();
      // Restart repeat with new period to reflect speed changes immediately.
      _controller.repeat(period: period);
    } else {
      if (_controller.isAnimating) {
        _controller.stop(canceled: false);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final idx = ((widget.points.length - 1) * _controller.value)
        .clamp(0.0, (widget.points.length - 1).toDouble())
        .round();
    final p = widget.points.isEmpty ? null : widget.points[idx];

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: CustomPaint(
        // Draw gradient background as the child; draw pendulum above it.
        foregroundPainter: _DoublePendulumPainter(
          point: p,
          L1: widget.params.L1,
          L2: widget.params.L2,
          points: widget.points,
          currentIndex: idx,
          showTrail: _showTrailSafe,
          trailCount: _trailCountSafe,
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFFFFF), // white
                Color(0xFFE6FAFF), // very light cyan
                Color(0xFFD1F6FF), // soft cyan
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DoublePendulumPainter extends CustomPainter {
  final DoublePendulumPoint? point;
  final double L1;
  final double L2;
  final List<DoublePendulumPoint> points;
  final int currentIndex;
  final bool showTrail;
  final int trailCount;
  const _DoublePendulumPainter({
    required this.point,
    required this.L1,
    required this.L2,
    required this.points,
    required this.currentIndex,
    required this.showTrail,
    required this.trailCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.2);
    final totalLen = L1 + L2;
    final scale = min(size.width, size.height) * 0.35 / max(totalLen, 0.0001);

    final paintRod = Paint()
      ..color = Colors.black.withOpacity(0.35)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final paintBob1 = Paint()..color = Colors.cyan.shade400;
    final paintBob2 = Paint()..color = Colors.cyan.shade700;

    // mount point glow
    canvas.drawCircle(center, 4, Paint()..color = Colors.black38);

    if (point == null) return;

    final th1 = point!.theta1;
    final th2 = point!.theta2;

    final p1 = center + Offset(L1 * sin(th1) * scale, L1 * cos(th1) * scale);
    final p2 = p1 + Offset(L2 * sin(th2) * scale, L2 * cos(th2) * scale);

    // rods
    canvas.drawLine(center, p1, paintRod);
    canvas.drawLine(p1, p2, paintRod);

    // bobs with shadow
    final shadow = Paint()
      ..color = Colors.black26
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(p1 + const Offset(2, 2), 10, shadow);
    canvas.drawCircle(p2 + const Offset(2, 2), 10, shadow);

    // optional trail for bob2
    if (showTrail && points.isNotEmpty) {
      final start = max(0, currentIndex - trailCount);
      final end = currentIndex;
      final segs = max(1, end - start);
      // limit number of drawn segments for performance
      final stride = max(1, segs ~/ 120);
      Offset? prev;
      for (int i = start; i <= end; i += stride) {
        final th1t = points[i].theta1;
        final th2t = points[i].theta2;
        final p1t = center + Offset(L1 * sin(th1t) * scale, L1 * cos(th1t) * scale);
        final p2t = p1t + Offset(L2 * sin(th2t) * scale, L2 * cos(th2t) * scale);
        if (prev != null) {
          final t = (i - start) / max(1, (end - start));
          final alpha = (t * 180).clamp(10, 180).toInt();
          final trailPaint = Paint()
            ..color = Colors.cyan.shade700.withAlpha(alpha)
            ..strokeWidth = 2.0
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round;
          canvas.drawLine(prev, p2t, trailPaint);
        }
        prev = p2t;
      }
    }

    canvas.drawCircle(p1, 10, paintBob1);
    canvas.drawCircle(p2, 10, paintBob2);
  }

  @override
  bool shouldRepaint(covariant _DoublePendulumPainter oldDelegate) {
    return oldDelegate.point != point ||
        oldDelegate.L1 != L1 ||
        oldDelegate.L2 != L2 ||
        oldDelegate.currentIndex != currentIndex ||
        oldDelegate.showTrail != showTrail ||
        oldDelegate.trailCount != trailCount ||
        !identical(oldDelegate.points, points);
  }
}
