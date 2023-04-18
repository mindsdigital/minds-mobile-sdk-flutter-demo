import '../../domain/entites/error_sdk.dart';

class ErrorSdkMapper {
  ErrorSDK fromObject(Map<String, dynamic> map) {
    return ErrorSDK(
      code: map['code'],
      description: map['description'],
    );
  }
}
