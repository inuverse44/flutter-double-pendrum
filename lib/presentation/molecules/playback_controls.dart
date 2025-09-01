import 'package:flutter/material.dart';

class PlaybackControls extends StatelessWidget {
  final bool playing;
  final double speed;
  final VoidCallback onToggle;
  final ValueChanged<double> onSpeedChanged;
  const PlaybackControls({
    super.key,
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

