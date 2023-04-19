import 'package:bloc/bloc.dart';
import '../../../../core/presenter/helpers/base_state.dart';
import '../../domain/entites/minds_response.dart';
import '../../domain/enums/process_type.dart';
import '../../domain/usecases/call_voice_process_sdk_usecase.dart';
import 'voice_biometrics_state.dart';

class VoiceBiometricsStore extends Cubit<VoiceBiometricsState> {
  final CallVoiceProcessSDKUsecase _callVoiceProcessSDKUsecase;

  VoiceBiometricsStore(this._callVoiceProcessSDKUsecase)
      : super(const VoiceBiometricsState());

  Future<void> callSDK(ProcessType processType) async {
    emit(state.copyWith(
      state: const LoadingState(),
      mindsResponse: const MindsResponse.empty(),
    ));
    final response = await _callVoiceProcessSDKUsecase(
      data: state.request,
      processType: processType,
    );
    response.fold(
      (failure) {
        emit(state.copyWith(state: FailureState(failure.message)));
      },
      (result) {
        emit(
            state.copyWith(state: const SuccessState(), mindsResponse: result));
      },
    );
  }

  void onChangePhoneNumber(String value) {
    emit(state.copyWith(phoneNumber: value, state: const UpdateState()));
  }

  void onChangeCpf(String value) {
    emit(state.copyWith(cpf: value, state: const UpdateState()));
  }
}
