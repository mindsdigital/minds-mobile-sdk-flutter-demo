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

  Map<String, dynamic> to(MindsResponse entity) {
    return {
      "success": entity.success,
      "error": {
        "code": entity.error?.code,
        "description": entity.error?.description,
      },
      "id": entity.id,
      "cpf": entity.cpf,
      "external_id": entity.externalId,
      "created_at": entity.createdAt,
      "result": {
        "recommended_action": entity.result?.recommendedaAction,
        "reasons": entity.result?.reasons ?? [],
      },
      "details": {
        "flag": {
          "id": entity.details?.flag?.id,
          "type": entity.details?.flag?.type,
          "description": entity.details?.flag?.description,
          "status": entity.details?.flag?.status,
        },
        "voice_match": {
          "result": entity.details?.voiceMatch?.result,
          "confidence": entity.details?.voiceMatch?.confidence,
          "status": entity.details?.voiceMatch?.status,
        },
      },
    };
  }
}
