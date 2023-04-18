import '../../domain/entites/minds_method_channel_request.dart';
import '../../domain/entites/minds_response.dart';
import '../../domain/enums/process_type.dart';

abstract class MindsSDKDatasource {
  Future<MindsResponse> callSDK(
      MindsMethodChannelRequest data, ProcessType processType);
}
