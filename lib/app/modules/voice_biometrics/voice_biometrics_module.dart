import 'package:flutter_modular/flutter_modular.dart';
import 'presenter/stores/voice_biometrics_store.dart';
import 'domain/usecases/call_voice_process_sdk_usecase_impl.dart';
import 'external/datasources/minds_sdk_datasource_impl.dart';
import 'infra/repositories/minds_sdk_repository_impl.dart';
import 'presenter/pages/voice_biometrics_page.dart';

class VoiceBiometricsModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind((i) => MindsSDKDatasourceImpl()),
        Bind((i) => MindsSDKRepositoryImpl(i.get())),
        Bind((i) => CallVoiceProcessSDKUsecaseImpl(i.get())),
        Bind((i) => VoiceBiometricsStore(i.get()))
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(Modular.initialRoute,
            child: (context, args) =>
                VoiceBiometricsPage(store: context.read()))
      ];
}
