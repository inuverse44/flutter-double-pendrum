import 'package:flutter/material.dart';
import 'package:rk4_solver/domain/models/simulation_params.dart';

class ParamsForm extends StatefulWidget {
  final SimulationParams params;
  final ValueChanged<SimulationParams> onRun;
  const ParamsForm({super.key, required this.params, required this.onRun});

  @override
  State<ParamsForm> createState() => _ParamsFormState();
}

class _ParamsFormState extends State<ParamsForm> {
  late final TextEditingController _theta0;
  late final TextEditingController _omega0;
  late final TextEditingController _tEnd;
  late final TextEditingController _h;

  @override
  void initState() {
    super.initState();
    _theta0 = TextEditingController(text: widget.params.theta0.toString());
    _omega0 = TextEditingController(text: widget.params.omega0.toString());
    _tEnd = TextEditingController(text: widget.params.tEnd.toString());
    _h = TextEditingController(text: widget.params.h.toString());
  }

  @override
  void dispose() {
    _theta0.dispose();
    _omega0.dispose();
    _tEnd.dispose();
    _h.dispose();
    super.dispose();
  }

  void _submit() {
    double parse(TextEditingController c, double fallback) => double.tryParse(c.text) ?? fallback;

    final updated = widget.params.copyWith(
      theta0: parse(_theta0, widget.params.theta0),
      omega0: parse(_omega0, widget.params.omega0),
      tEnd: parse(_tEnd, widget.params.tEnd),
      h: parse(_h, widget.params.h),
    );
    widget.onRun(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            _numField('θ0 [rad]', _theta0),
            _numField('ω0 [rad/s]', _omega0),
            _numField('T end [s]', _tEnd),
            _numField('Step h [s]', _h),
          ],
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: _submit,
          icon: const Icon(Icons.play_arrow),
          label: const Text('Run Simulation'),
        ),
      ],
    );
  }

  Widget _numField(String label, TextEditingController controller) {
    return SizedBox(
      width: 160,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
      ),
    );
  }
}

