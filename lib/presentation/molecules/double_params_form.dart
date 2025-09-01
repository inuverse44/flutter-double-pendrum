import 'package:flutter/material.dart';
import 'package:rk4_solver/domain/models/double_pendulum_params.dart';
import 'package:rk4_solver/domain/utils/step_advisor.dart';

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

    // Listen to value changes to update recommended step and warnings live.
    for (final c in [_m1, _m2, _L1, _L2, _h]) {
      c.addListener(() => setState(() {}));
    }
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
    final m1 = parse(_m1, widget.params.m1);
    final m2 = parse(_m2, widget.params.m2);
    final L1 = parse(_L1, widget.params.L1);
    final L2 = parse(_L2, widget.params.L2);

    // Validate masses/lengths strictly: must be positive finite values.
    final invalidMassLen = !m1.isFinite || !m2.isFinite || !L1.isFinite || !L2.isFinite || m1 <= 0 || m2 <= 0 || L1 <= 0 || L2 <= 0;
    if (invalidMassLen) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('質量と長さは正の値を入力してください'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      setState(() {});
      return;
    }
    // Validate time step strictly: must be positive.
    if (!(h.isFinite) || h <= 0) {
      // Show inline error via errorText and block submission by simply returning.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('時間刻みは正の値を入力してください'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      setState(() {});
      return;
    }
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
    double parse(TextEditingController c, double fallback) => double.tryParse(c.text) ?? fallback;

    // Build-time recommended max step (50 divisions of fastest mode)
    final m1 = parse(_m1, widget.params.m1);
    final m2 = parse(_m2, widget.params.m2);
    final L1 = parse(_L1, widget.params.L1);
    final L2 = parse(_L2, widget.params.L2);
    final hCur = parse(_h, widget.params.h);
    final forRec = widget.params.copyWith(m1: m1, m2: m2, L1: L1, L2: L2);
    final hRec = StepAdvisor.recommendedMaxStep(forRec, cyclesPerPeriod: 50);
    final exceeds = hRec.isFinite && hCur > hRec;
    final invalidM1 = !m1.isFinite || m1 <= 0;
    final invalidM2 = !m2.isFinite || m2 <= 0;
    final invalidL1 = !L1.isFinite || L1 <= 0;
    final invalidL2 = !L2.isFinite || L2 <= 0;

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
                _numField('m1 [kg]', _m1, helper: '正の値のみ', error: invalidM1 ? '正の値を入力してください' : null),
                _numField('m2 [kg]', _m2, helper: '正の値のみ', error: invalidM2 ? '正の値を入力してください' : null),
                _numField('L1 [m]', _L1, helper: '正の値のみ', error: invalidL1 ? '正の値を入力してください' : null),
                _numField('L2 [m]', _L2, helper: '正の値のみ', error: invalidL2 ? '正の値を入力してください' : null),
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
                _numField(
                  '時間刻み [秒]',
                  _h,
                  hint: '例: 0.01 → 100分割',
                  helper: '時間分解能（小さいほど滑らか）',
                  error: (!hCur.isFinite || hCur <= 0) ? '正の値を入力してください' : null,
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (hRec.isFinite)
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Chip(
                      label: Text('推奨最大刻み ≲ ${hRec.toStringAsPrecision(3)} 秒（50分割）'),
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                      side: BorderSide.none,
                    ),
                    if (exceeds)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                          const SizedBox(width: 4),
                          Text(
                            '刻みが推奨より大きいです',
                            style: TextStyle(color: Colors.orange.shade800),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: (!hCur.isFinite || hCur <= 0 || invalidM1 || invalidM2 || invalidL1 || invalidL2) ? null : _submit,
          icon: const Icon(Icons.play_circle_fill),
          label: const Text('シミュレーション実行'),
        ),
      ],
    );
  }

  Widget _numField(String label, TextEditingController c, {bool readOnly = false, String? hint, String? helper, String? error}) {
    return SizedBox(
      width: 200,
      child: TextField(
        controller: c,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          helperText: helper,
          errorText: error,
          helperMaxLines: 2,
          border: const OutlineInputBorder(),
        ),
        keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
      ),
    );
  }

  // sectionTitle は ExpansionTile に置き換えたため未使用
}
