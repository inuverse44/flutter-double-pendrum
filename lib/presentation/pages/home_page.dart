import 'package:flutter/material.dart';
import 'package:rk4_solver/application/double_pendulum_controller.dart';
import 'package:rk4_solver/presentation/widgets/double_params_form.dart';
import 'package:rk4_solver/presentation/widgets/double_pendulum_animator.dart';

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
                  _InfoChip(label: '計算点数', value: result.points.length.toString()),
                  _InfoChip(label: 'シミュレーション時間 [秒]', value: _controller.params.tEnd.toStringAsFixed(2)),
                  _InfoChip(label: '時間刻み [秒]', value: _controller.params.h.toStringAsFixed(4)),
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
            _PlaybackControls(
              playing: _playing,
              speed: _speed,
              onToggle: () => setState(() => _playing = !_playing),
              onSpeedChanged: (v) => setState(() => _speed = v),
            ),
            const SizedBox(height: 8),
            _TrailControls(
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

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  const _InfoChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text('$label: $value'),
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.08),
      side: BorderSide.none,
    );
  }
}

class _PlaybackControls extends StatelessWidget {
  final bool playing;
  final double speed;
  final VoidCallback onToggle;
  final ValueChanged<double> onSpeedChanged;
  const _PlaybackControls({
    required this.playing,
    required this.speed,
    required this.onToggle,
    required this.onSpeedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  iconSize: 28,
                  onPressed: onToggle,
                  icon: Icon(playing ? Icons.pause_circle_filled : Icons.play_circle_fill),
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  playing ? '再生中' : '一時停止',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Text('${speed.toStringAsFixed(2)}x'),
              ],
            ),
            Row(
              children: [
                const Text('速度'),
                Expanded(
                  child: Slider(
                    value: speed,
                    min: 0.5,
                    max: 2.0,
                    divisions: 15,
                    label: '${speed.toStringAsFixed(2)}x',
                    onChanged: onSpeedChanged,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TrailControls extends StatelessWidget {
  final bool showTrail;
  final int trailCount;
  final ValueChanged<bool> onShowTrailChanged;
  final ValueChanged<double> onTrailCountChanged;
  const _TrailControls({
    required this.showTrail,
    required this.trailCount,
    required this.onShowTrailChanged,
    required this.onTrailCountChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('軌跡を表示'),
              value: showTrail,
              onChanged: onShowTrailChanged,
            ),
            if (showTrail)
              Row(
                children: [
                  const Text('軌跡長'),
                  Expanded(
                    child: Slider(
                      value: trailCount.toDouble().clamp(20, 500),
                      min: 20,
                      max: 500,
                      divisions: 24,
                      label: trailCount.toString(),
                      onChanged: onTrailCountChanged,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
