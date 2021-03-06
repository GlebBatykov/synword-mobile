import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:poseidon/poseidon.dart';

import '../../../domain/model/result/rephrase/rephrase_result_rephrased_word.dart';
import '../../ui/dialog/word_replacement_dialog.dart';
import '../dialog/rephrased_text/word_replacement/word_replacement_dialog_cubit.dart';

part 'rephrased_text_state.dart';

class RephrasedTextCubit extends Cubit<RephrasedTextState> {
  String _text;

  final List<RephraseResultRephrasedWord> _rephrasedWords;

  String get text => _text;

  RephrasedTextCubit(
      String text, List<RephraseResultRephrasedWord> rephrasedWords)
      : _text = text,
        _rephrasedWords = rephrasedWords,
        super(RephrasedTextInitial()) {
    _initialize();
  }

  void _initialize() {
    _show();
  }

  List<InlineSpan> _buildSpans() {
    var textSpans = <InlineSpan>[];

    var start = 0;
    var text = '';

    void addCommonSpan() {
      textSpans.add(
          TextSpan(text: text, style: const TextStyle(color: Colors.black)));
    }

    void addRephrasedSpan(RephraseResultRephrasedWord word) {
      textSpans.add(WidgetSpan(
          child: GestureDetector(
        onTap: _onTap(word),
        child: Container(
            decoration: BoxDecoration(
                color: HexColor('#DDC5A2'),
                borderRadius: BorderRadius.circular(5)),
            padding:
                const EdgeInsets.only(left: 2, right: 2, top: 1, bottom: 1),
            child: Text(text, style: const TextStyle(fontSize: 15))),
      )));
    }

    if (_rephrasedWords.isNotEmpty && _rephrasedWords.first.startIndex > 0) {
      text = _text.substring(start, _rephrasedWords.first.startIndex);

      addCommonSpan();

      start = _rephrasedWords.first.startIndex;
    }

    for (var i = 0; i < _rephrasedWords.length; i++) {
      text = _text.substring(start, _rephrasedWords[i].endIndex + 1);

      addRephrasedSpan(_rephrasedWords[i]);

      start = _rephrasedWords[i].endIndex + 1;

      if (i + 1 < _rephrasedWords.length) {
        text = _text.substring(start, _rephrasedWords[i + 1].startIndex);

        addCommonSpan();

        start = _rephrasedWords[i + 1].startIndex;
      }
    }

    if (start != _text.length - 1) {
      text = _text.substring(start, _text.length);
      addCommonSpan();
    }

    return textSpans;
  }

  void Function() _onTap(RephraseResultRephrasedWord word) {
    return () {
      Poseidon.instance.callDialog((context) => BlocProvider(
          create: (context) => WordReplacementDialogCubit(
              word, _onSelectSynonym, _onSelectSource),
          child: const WordReplacementDialog()));
    };
  }

  void _onSelectSynonym(RephraseResultRephrasedWord word, int index) {
    var synonym = word.synonyms[index];

    _text = _text.replaceRange(word.startIndex, word.endIndex + 1, synonym);

    var oldEndIndex = word.endIndex;

    word.endIndex = word.startIndex + synonym.length - 1;

    var difference = oldEndIndex - word.endIndex;

    _makeDifference(difference, word);

    _show();
  }

  void _onSelectSource(RephraseResultRephrasedWord word) {
    _text =
        _text.replaceRange(word.startIndex, word.endIndex + 1, word.sourceWord);

    var oldEndIndex = word.endIndex;

    word.endIndex = word.startIndex + word.sourceWord.length - 1;

    var difference = oldEndIndex - word.endIndex;

    _makeDifference(difference, word);

    _show();
  }

  void _makeDifference(int difference, RephraseResultRephrasedWord word) {
    var wordIndex = _rephrasedWords.indexOf(word);

    var subsequent =
        _rephrasedWords.getRange(wordIndex + 1, _rephrasedWords.length);

    for (var word in subsequent) {
      word.startIndex -= difference;
      word.endIndex -= difference;
    }
  }

  void _show() {
    emit(RephrasedTextShow(_buildSpans()));
  }
}
