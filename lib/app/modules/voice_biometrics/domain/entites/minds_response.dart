import 'details_sdk.dart';
import 'error_sdk.dart';
import 'result_sdk.dart';

class MindsResponse {
  final String rawResponse;
  final bool? success;
  final ErrorSDK? error;
  final int? id;
  final String? cpf;
  final String? externalId;
  final String? createdAt;
  final ResultSDK? result;
  final DetailsSDK? details;

  const MindsResponse({
    required this.rawResponse,
    required this.success,
    required this.error,
    required this.id,
    required this.cpf,
    required this.externalId,
    required this.createdAt,
    required this.result,
    required this.details,
  });

  const MindsResponse.empty()
      : this(
          rawResponse: '',
          success: false,
          error: null,
          id: 0,
          cpf: "",
          externalId: "",
          result: null,
          details: null,
          createdAt: "",
        );

  @override
  String toString() {
    return 'MindsResponse(success: $success, error: $error, id: $id, cpf: $cpf, externalId: $externalId, createdAt: $createdAt, result: $result, details: $details)';
  }
}
