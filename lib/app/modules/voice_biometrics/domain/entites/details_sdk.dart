import 'flag_sdk.dart';
import 'voice_match_sdk.dart';

class DetailsSDK {
  final FlagSDK? flag;
  final VoiceMatchSDK? voiceMatch;
  const DetailsSDK({
    required this.flag,
    required this.voiceMatch,
  });
}
