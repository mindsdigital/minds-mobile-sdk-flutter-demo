import '../../domain/entites/voice_match_sdk.dart';
import 'minds_prediction_reponse_mapper.dart';

class VoiceMatchSDKMapper {
  VoiceMatchSDK fromObject(Map<String, dynamic> map) {
    return VoiceMatchSDK(
      result: map['result'] != null
          ? MindsPredictionResponseMapper().fromEnum(map['result'])
          : null,
      confidence: map['confidence'],
      status: map['status'],
    );
  }
}
