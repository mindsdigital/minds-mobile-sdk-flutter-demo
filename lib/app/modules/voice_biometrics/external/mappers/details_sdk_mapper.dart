import '../../domain/entites/details_sdk.dart';
import 'flag_sdk_mapper.dart';
import 'voice_match_sdk_mapper.dart';

class DetailsSdkMapper {
  DetailsSDK fromOnject(Map<String, dynamic> map) {
    return DetailsSDK(
      flag:
          map['flag'] != null ? FlagSdkMapper().fromObject(map['flag']) : null,
      voiceMatch: map['voice_match'] != null
          ? VoiceMatchSDKMapper().fromObject(map['voice_match'])
          : null,
    );
  }
}
