import 'package:dartz/dartz.dart';
import '../../../../core/domain/helpers/errors/failure.dart';
import '../entites/minds_method_channel_request.dart';
import '../entites/minds_response.dart';
import '../enums/process_type.dart';

abstract class MindsSDKRepository {
  Future<Either<Failure, MindsResponse>> callSDK(
      MindsMethodChannelRequest data, ProcessType processType);
}
