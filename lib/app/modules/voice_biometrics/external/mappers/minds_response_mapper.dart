import 'dart:convert';
import '../../domain/entites/minds_response.dart';
import 'details_sdk_mapper.dart';
import 'error_sdk_mapper.dart';
import 'result_sdk_mappe.dart';

class MindsResponseMapper {
  MindsResponse from(String rawResponse) {
    Map<String, dynamic> map = jsonDecode(rawResponse);
    return MindsResponse(
      rawResponse: rawResponse,
      success: map['success'],
      error: ErrorSdkMapper().fromObject(map['error']),
      id: map['id'],
      cpf: map['cpf'],
      externalId: map['external_id'],
      createdAt: map['created_at'],
      result: ResultSdkMapper().fromObject(map['result']),
      details: DetailsSdkMapper().fromOnject(map['details']),
    );
  }
}
