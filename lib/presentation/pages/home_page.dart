import 'package:flutter/material.dart';
import 'package:rk4_solver/application/double_pendulum_controller.dart';
import 'package:rk4_solver/presentation/molecules/playback_controls.dart';
import 'package:rk4_solver/presentation/molecules/trail_controls.dart';
import 'package:rk4_solver/presentation/atoms/info_chip.dart';
import 'package:rk4_solver/presentation/molecules/double_params_form.dart';
import 'package:rk4_solver/presentation/organisms/double_pendulum_animator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final DoublePendulumController _controller;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _animKey = GlobalKey();
  bool _playing = true;
  double _speed = 1.0; // 0.5x – 2.0x
  bool _showTrail = true;
  int _trailCount = 150;

  @override
  void initState() {
    super.initState();
    _controller = DoublePendulumController(
      onUpdate: () => setState(() {}),
    );
    _controller.run();
  }

  @override
  Widget build(BuildContext context) {
    final result = _controller.result;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Double Pendulum'),
      ),
      body: SafeArea(
        child: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.all(12.0),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: DoubleParamsForm(
                  params: _controller.params,
                  onRun: (p) {
                    setState(() {
                      _controller.params = p;
                      _controller.run();
                    });
                    // 実行後にアニメ領域へスクロール
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      final ctx = _animKey.currentContext;
                      if (ctx != null) {
                        Scrollable.ensureVisible(
                          ctx,
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeOut,
                        );
                      }
                    });
                  },
                ),
              ),
            ),
            if (result != null) ...[
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  InfoChip(label: '計算点数', value: result.points.length.toString()),
                  InfoChip(label: 'シミュレーション時間 [秒]', value: _controller.params.tEnd.toStringAsFixed(2)),
                  InfoChip(label: '時間刻み [秒]', value: _controller.params.h.toStringAsFixed(4)),
                ],
              ),
            ],
            const SizedBox(height: 8),
            Container(
              key: _animKey,
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: result == null
                        ? const Center(child: CircularProgressIndicator())
                        : DoublePendulumAnimator(
                            points: result.points,
                            params: _controller.params,
                            autoPlay: false,
                            playing: _playing,
                            speed: _speed,
                            showTrail: _showTrail,
                            trailCount: _trailCount,
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            PlaybackControls(
              playing: _playing,
              speed: _speed,
              onToggle: () => setState(() => _playing = !_playing),
              onSpeedChanged: (v) => setState(() => _speed = v),
            ),
            const SizedBox(height: 8),
            TrailControls(
              showTrail: _showTrail,
              trailCount: _trailCount,
              onShowTrailChanged: (v) => setState(() => _showTrail = v),
              onTrailCountChanged: (v) => setState(() => _trailCount = v.round()),
            ),
          ],
        ),
      ),
    );
  }
}
 
