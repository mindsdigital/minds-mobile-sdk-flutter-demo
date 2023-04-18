import '../enums/minds_prediction_reponse.dart';

class VoiceMatchSDK {
  final MindsPredictionResponse? result;
  final String? confidence;
  final String? status;
  const VoiceMatchSDK({
    required this.result,
    required this.confidence,
    required this.status,
  });
}
