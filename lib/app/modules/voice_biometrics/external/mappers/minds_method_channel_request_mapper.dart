import '../../domain/entites/minds_method_channel_request.dart';

class MindsMethodChannelRequestMapper {
  Map<String, dynamic> fromMap(MindsMethodChannelRequest request) {
    return {
      "token": request.token,
      "cpf": request.cpf,
      "telephone": request.telephone,
    };
  }
}
