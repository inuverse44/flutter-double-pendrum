import 'package:flutter/material.dart';
import 'package:rk4_solver/domain/models/double_pendulum_params.dart';

class DoubleParamsForm extends StatefulWidget {
  final DoublePendulumParams params;
  final ValueChanged<DoublePendulumParams> onRun;
  const DoubleParamsForm({super.key, required this.params, required this.onRun});

  @override
  State<DoubleParamsForm> createState() => _DoubleParamsFormState();
}

class _DoubleParamsFormState extends State<DoubleParamsForm> {
  late final TextEditingController _theta1;
  late final TextEditingController _omega1;
  late final TextEditingController _theta2;
  late final TextEditingController _omega2;
  late final TextEditingController _m1;
  late final TextEditingController _m2;
  late final TextEditingController _L1;
  late final TextEditingController _L2;
  late final TextEditingController _tEnd;
  late final TextEditingController _h;
  bool _expInitial = true;
  bool _expPhysical = false;
  bool _expSim = true;

  @override
  void initState() {
    super.initState();
    final p = widget.params;
    _theta1 = TextEditingController(text: p.theta1.toString());
    _omega1 = TextEditingController(text: p.omega1.toString());
    _theta2 = TextEditingController(text: p.theta2.toString());
    _omega2 = TextEditingController(text: p.omega2.toString());
    _m1 = TextEditingController(text: p.m1.toString());
    _m2 = TextEditingController(text: p.m2.toString());
    _L1 = TextEditingController(text: p.L1.toString());
    _L2 = TextEditingController(text: p.L2.toString());
    _tEnd = TextEditingController(text: p.tEnd.toString());
    _h = TextEditingController(text: p.h.toString());
  }

  @override
  void dispose() {
    _theta1.dispose();
    _omega1.dispose();
    _theta2.dispose();
    _omega2.dispose();
    _m1.dispose();
    _m2.dispose();
    _L1.dispose();
    _L2.dispose();
    _tEnd.dispose();
    _h.dispose();
    super.dispose();
  }

  void _submit() {
    double parse(TextEditingController c, double fallback) => double.tryParse(c.text) ?? fallback;
    var tEnd = parse(_tEnd, widget.params.tEnd);
    var h = parse(_h, widget.params.h);
    // Basic guardrails to avoid empty/invalid simulations.
    if (!(h.isFinite) || h <= 0) h = widget.params.h;
    if (!(tEnd.isFinite)) tEnd = widget.params.tEnd;
    if (tEnd <= widget.params.t0) tEnd = widget.params.t0 + 1.0; // ensure forward integration

    final p = widget.params.copyWith(
      theta1: parse(_theta1, widget.params.theta1),
      omega1: parse(_omega1, widget.params.omega1),
      theta2: parse(_theta2, widget.params.theta2),
      omega2: parse(_omega2, widget.params.omega2),
      m1: parse(_m1, widget.params.m1),
      m2: parse(_m2, widget.params.m2),
      L1: parse(_L1, widget.params.L1),
      L2: parse(_L2, widget.params.L2),
      tEnd: tEnd,
      h: h,
    );
    widget.onRun(p);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ExpansionTile(
          initiallyExpanded: _expInitial,
          onExpansionChanged: (v) => setState(() => _expInitial = v),
          title: const Text('初期条件'),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _numField('θ1 [rad]', _theta1),
                _numField('ω1 [rad/s]', _omega1),
                _numField('θ2 [rad]', _theta2),
                _numField('ω2 [rad/s]', _omega2),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        ExpansionTile(
          initiallyExpanded: _expPhysical,
          onExpansionChanged: (v) => setState(() => _expPhysical = v),
          title: const Text('物理パラメータ'),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _numField('m1 [kg]', _m1),
                _numField('m2 [kg]', _m2),
                _numField('L1 [m]', _L1),
                _numField('L2 [m]', _L2),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        ExpansionTile(
          initiallyExpanded: _expSim,
          onExpansionChanged: (v) => setState(() => _expSim = v),
          title: const Text('シミュレーション設定'),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _numField('時間 [秒]', _tEnd, hint: '例: 1.0 → 1秒まで再生', helper: 'シミュレーション時間'),
                _numField('時間刻み [秒]', _h, hint: '例: 0.01 → 100分割', helper: '時間分解能（小さいほど滑らか）'),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: _submit,
          icon: const Icon(Icons.play_circle_fill),
          label: const Text('シミュレーション実行'),
        ),
      ],
    );
  }

  Widget _numField(String label, TextEditingController c, {bool readOnly = false, String? hint, String? helper}) {
    return SizedBox(
      width: 200,
      child: TextField(
        controller: c,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          helperText: helper,
          helperMaxLines: 2,
          border: const OutlineInputBorder(),
        ),
        keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
      ),
    );
  }

  // sectionTitle は ExpansionTile に置き換えたため未使用
}
