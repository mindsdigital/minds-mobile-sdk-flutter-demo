import 'package:flutter_modular/flutter_modular.dart';
import 'modules/voice_biometrics/voice_biometrics_module.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute('/', module: VoiceBiometricsModule()),
  ];
}
