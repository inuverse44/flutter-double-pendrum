import 'package:flutter/material.dart';
import 'package:rk4_solver/domain/models/double_pendulum_params.dart';
import 'package:rk4_solver/domain/services/double_pendulum_runner.dart';

class DoublePendulumController {
  DoublePendulumParams params;
  DoublePendulumResult? _result;
  VoidCallback? onUpdate;

  DoublePendulumController({DoublePendulumParams? initial, this.onUpdate})
      : params = initial ?? DoublePendulumParams.defaults();

  DoublePendulumResult? get result => _result;

  void run() {
    _result = DoublePendulumRunner.run(params);
    onUpdate?.call();
  }
}

