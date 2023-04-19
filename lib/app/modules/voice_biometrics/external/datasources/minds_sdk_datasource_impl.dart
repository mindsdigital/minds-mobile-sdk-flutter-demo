import 'package:flutter/services.dart';
import '../../../../core/enternal/constants/method_channel_sdk.dart';
import '../../../../core/domain/helpers/errors/datasource_failure.dart';
import '../../../../core/domain/helpers/errors/failure.dart';
import '../../domain/entites/minds_method_channel_request.dart';
import '../../domain/entites/minds_response.dart';
import '../../domain/enums/process_type.dart';
import '../../infra/datasources/minds_sdk_datasource.dart';
import '../mappers/minds_method_channel_request_mapper.dart';
import '../mappers/minds_response_mapper.dart';

class MindsSDKDatasourceImpl implements MindsSDKDatasource {
  @override
  Future<MindsResponse> callSDK(
      MindsMethodChannelRequest data, ProcessType processType) async {
    try {
      final response =
          await MethodChannel(MethodChannelSDK.method).invokeMethod(
        processType.name,
        MindsMethodChannelRequestMapper().fromMap(data),
      );
      return MindsResponseMapper().from(response);
    } on Failure {
      rethrow;
    } catch (error, stackTrace) {
      throw DatasourceFailure(error.toString(), stackTrace);
    }
  }
}
