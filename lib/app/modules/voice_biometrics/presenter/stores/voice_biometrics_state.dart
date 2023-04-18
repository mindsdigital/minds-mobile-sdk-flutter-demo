import 'package:brasil_fields/brasil_fields.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/presenter/helpers/base_state.dart';
import '../../../../core/utils/minds_token_manager.dart';
import '../../domain/entites/minds_method_channel_request.dart';
import '../../domain/entites/minds_response.dart';

class VoiceBiometricsState extends Equatable {
  final BaseState state;
  final String cpf;
  final String phoneNumber;
  final MindsResponse mindsResponse;

  const VoiceBiometricsState({
    this.state = const InitialState(),
    this.cpf = "",
    this.phoneNumber = "",
    this.mindsResponse = const MindsResponse.empty(),
  });

  VoiceBiometricsState copyWith({
    BaseState? state,
    String? cpf,
    String? phoneNumber,
    MindsResponse? mindsResponse,
  }) {
    return VoiceBiometricsState(
      state: state ?? this.state,
      cpf: cpf ?? this.cpf,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      mindsResponse: mindsResponse ?? this.mindsResponse,
    );
  }

  MindsMethodChannelRequest get request => MindsMethodChannelRequest(
        token: MindsTokenManager.token,
        cpf: UtilBrasilFields.removeCaracteres(cpf),
        telephone: UtilBrasilFields.removeCaracteres(phoneNumber),
      );

  @override
  List<Object?> get props => [state, cpf, phoneNumber, mindsResponse];
}
