import 'package:dartz/dartz.dart';
import '../../../../core/domain/helpers/errors/failure.dart';
import '../entites/minds_method_channel_request.dart';
import '../entites/minds_response.dart';
import '../enums/process_type.dart';
import '../repositories/minds_sdk_repository.dart';
import 'call_voice_process_sdk_usecase.dart';

class CallVoiceProcessSDKUsecaseImpl implements CallVoiceProcessSDKUsecase {
  final MindsSDKRepository _repository;

  const CallVoiceProcessSDKUsecaseImpl(this._repository);

  @override
  Future<Either<Failure, MindsResponse>> call({
    required MindsMethodChannelRequest data,
    required ProcessType processType,
  }) async {
    final response = await _repository.callSDK(data, processType);
    return response;
  }
}
