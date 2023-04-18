import 'package:dartz/dartz.dart';
import '../../../../core/domain/helpers/errors/failure.dart';
import '../entites/minds_method_channel_request.dart';
import '../entites/minds_response.dart';
import '../enums/process_type.dart';

abstract class CallVoiceProcessSDKUsecase {
  Future<Either<Failure, MindsResponse>> call({
    required MindsMethodChannelRequest data,
    required ProcessType processType,
  });
}
