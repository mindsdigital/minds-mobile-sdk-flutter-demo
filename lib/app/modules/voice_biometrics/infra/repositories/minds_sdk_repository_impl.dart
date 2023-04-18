import 'package:dartz/dartz.dart';
import '../../../../core/domain/helpers/errors/failure.dart';
import '../../domain/entites/minds_method_channel_request.dart';
import '../../domain/entites/minds_response.dart';
import '../../domain/enums/process_type.dart';
import '../../domain/repositories/minds_sdk_repository.dart';
import '../datasources/minds_sdk_datasource.dart';

class MindsSDKRepositoryImpl implements MindsSDKRepository {
  final MindsSDKDatasource _datasource;

  const MindsSDKRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, MindsResponse>> callSDK(
      MindsMethodChannelRequest data, ProcessType processType) async {
    try {
      final response = await _datasource.callSDK(data, processType);
      return Right(response);
    } on Failure catch (error) {
      return Left(error);
    }
  }
}
