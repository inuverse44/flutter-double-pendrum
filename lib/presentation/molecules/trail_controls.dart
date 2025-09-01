import 'package:flutter/material.dart';

class TrailControls extends StatelessWidget {
  final bool showTrail;
  final int trailCount;
  final ValueChanged<bool> onShowTrailChanged;
  final ValueChanged<double> onTrailCountChanged;
  const TrailControls({
    super.key,
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

