import 'package:rk4_solver/domain/models/simulation_params.dart';
import 'package:rk4_solver/domain/services/simulation_runner.dart';

class SimulationController {
  SimulationParams params;
  SimulationResult? _result;

  SimulationController({SimulationParams? initial}) : params = initial ?? SimulationParams.defaults();

  SimulationResult? get result => _result;

  void run() {
    _result = SimulationRunner.run(params);
  }
}

