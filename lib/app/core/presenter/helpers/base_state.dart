import 'package:equatable/equatable.dart';

abstract class BaseState extends Equatable {
  const BaseState();
}

class SuccessState extends BaseState {
  const SuccessState();

  @override
  List<Object?> get props => [];
}

class FailureState extends BaseState {
  final String message;

  const FailureState(this.message);

  @override
  List<Object?> get props => [message];
}

class LoadingState extends BaseState {
  const LoadingState();

  @override
  List<Object?> get props => [];
}

class InitialState extends BaseState {
  const InitialState();

  @override
  List<Object?> get props => [];
}

class UpdateState extends BaseState {
  const UpdateState();

  @override
  List<Object?> get props => [];
}
