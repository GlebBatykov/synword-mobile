import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../model/layer/operation_layer/check/check_layer_body_content_data.dart';
import '../../../../model/page/history/result/check/check_result_link.dart';
import '../../../../ui/layer/operation_layer/check/check_layer_body.dart';
import '../../layer/layer_cubit.dart';

class CheckLayerCubit extends LayerCubit<CheckLayerBodyContentData> {
  CheckLayerCubit(Offset offset, Size size)
      : super('Plagiarism Checker', HexColor('DDC5A2'), offset, size,
            bodyBuilder: (data) => CheckLayerBody(data: data));

  @override
  void work() {
    var links = List.generate(
        15,
        (index) => CheckResultLink(
            'https://stackoverflow.com/questions/49638499/how-to-make-scrollable-text-in-flutter',
            Random().nextInt(101)))
      ..sort((a, b) => b.percentages.compareTo(a.percentages));

    show(CheckLayerBodyContentData(0.6, links));
  }
}
