// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_history_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetHistoryResponse _$GetHistoryResponseFromJson(Map<String, dynamic> json) =>
    GetHistoryResponse(
      (json['rephraseHistories'] as List<dynamic>)
          .map((e) => ApiRephraseHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['plagiarismCheckHistories'] as List<dynamic>)
          .map((e) => ApiCheckHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
