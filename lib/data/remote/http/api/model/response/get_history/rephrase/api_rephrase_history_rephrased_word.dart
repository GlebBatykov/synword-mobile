import 'package:json_annotation/json_annotation.dart';

import 'api_rephrase_history_synonym.dart';

part 'api_rephrase_history_rephrased_word.g.dart';

@JsonSerializable(createToJson: false)
class ApiRephraseHistoryRephrasedWord {
  final String sourceWord;

  final int synonymWordStartIndex;

  final int synonymWordEndIndex;

  final List<ApiRephraseHistorySynonym> synonyms;

  ApiRephraseHistoryRephrasedWord(this.sourceWord, this.synonymWordStartIndex,
      this.synonymWordEndIndex, this.synonyms);

  factory ApiRephraseHistoryRephrasedWord.fromJson(Map<String, dynamic> json) =>
      _$ApiRephraseHistoryRephrasedWordFromJson(json);
}
