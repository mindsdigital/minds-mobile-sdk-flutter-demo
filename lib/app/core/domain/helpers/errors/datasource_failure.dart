import 'failure.dart';

class DatasourceFailure extends Failure {
  const DatasourceFailure(String message, StackTrace stackTrace)
      : super(message, stackTrace);
}
