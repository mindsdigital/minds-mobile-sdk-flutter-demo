import '../../domain/entites/flag_sdk.dart';

class FlagSdkMapper {
  FlagSDK fromObject(Map<String, dynamic> map) {
    return FlagSDK(
      id: map['id'],
      type: map['type'],
      description: map['description'],
      status: map['status'],
    );
  }
}
