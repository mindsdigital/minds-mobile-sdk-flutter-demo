import '../../domain/entites/result_sdk.dart';

class ResultSdkMapper {
  ResultSDK fromObject(Map<String, dynamic> map) {
    return ResultSDK(
        recommendedaAction: map["recommended_action"] != null
            ? map['recommended_action']
            : null,
        reasons: map["reasons"] != null
            ? List.from(map['reasons'].map((e) => reasonsMapper(e)))
            : []);
  }

  String reasonsMapper(String value) {
    switch (value) {
      case 'voice_match':
        return "Voz similar à voz da biometria cadastrada.";

      case 'voice_different':
        return "Voz não se parece com a voz da biometria cadastrada.";

      case 'confidence_low':
        return "Confiança baixa da voz ser a mesma de biometria cadastrada.";

      case 'phone_flag':
        return "Telefone foi encontrado na Blocklist.";

      case 'voice_flag':
        return "Voz semelhante foi encontrada na Blocklist.";

      case 'error_anti_fraud':
        return "Ocorreu um erro inesperado no processo de anti-fraude.";

      case 'enrollment_success':
        return "Biometria cadastrada com sucesso.";

      default:
        return value;
    }
  }
}
