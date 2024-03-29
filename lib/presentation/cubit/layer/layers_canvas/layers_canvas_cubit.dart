import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../domain/model/enum/rephrase_language.dart';
import '../../../../domain/model/result/check/check_result.dart';
import '../../../model/layer/text_input_layer/editing_change_details.dart';
import '../../../model/layer/text_input_layer/text_change_details.dart';
import '../../../ui/body/body_properties.dart';
import '../../../ui/layer/layer_properties.dart';
import '../operation_layer/operation_layer.dart';
import '../text_input_layer/text_input_layer_cubit.dart';

part 'layers_canvas_state.dart';

enum OperationLayerType { check, secondCheck, rephrase }

class LayersCanvasCubit extends Cubit<LayersCanvasState> {
  static const double _minHeight = LayerProperties.headerContactHeight * 2;

  final StreamController _workDoneLayerController =
      StreamController.broadcast();

  final Map<OperationLayerCubit, StreamSubscription> _workDoneSubscriptions =
      {};

  final StreamController _removeLayerController = StreamController.broadcast();

  final Size _size;

  late final TextInputLayerCubit _inputLayerCubit;

  final List<OperationLayerCubit> _layersCubits = [];

  bool _isAnimationActive = false;

  Stream get removeLayer => _removeLayerController.stream;

  Stream get workDoneLayer => _workDoneLayerController.stream;

  Stream<TextChangeDetails> get textChanges => _inputLayerCubit.textChanges;

  Stream<EditingChangeDetails> get editingChanges =>
      _inputLayerCubit.editingChanges;

  String get text => _inputLayerCubit.text;

  bool get isInitialTextEditing => _inputLayerCubit.isEditing;

  CheckResult? get initialTextCheckResult {
    var checkLayersCubits = _layersCubits.whereType<CheckLayerCubit>();

    if (checkLayersCubits.isNotEmpty) {
      return checkLayersCubits.first.result;
    } else {
      return null;
    }
  }

  String? get rephrasedText {
    var rephrasedLayersCubits = _layersCubits.whereType<RephraseLayerCubit>();

    if (rephrasedLayersCubits.isNotEmpty) {
      return rephrasedLayersCubits.first.rephrasedText;
    } else {
      return null;
    }
  }

  RephraseLanguage get rephraseLanguage => _inputLayerCubit.rephraseLanguage;

  List<OperationLayerType> get currentLayers => _layersCubits.map((e) {
        if (e is RephraseLayerCubit) {
          return OperationLayerType.rephrase;
        } else if (e is CheckLayerCubit) {
          return OperationLayerType.check;
        } else {
          return OperationLayerType.secondCheck;
        }
      }).toList();

  int get operationLayersLength => _layersCubits.length;

  bool get isOperationLayersNotShow => _layersCubits.isEmpty;

  LayersCanvasCubit(Size size, TextInputLayerCubit inputLayerCubit)
      : _size = size,
        _inputLayerCubit = inputLayerCubit,
        super(LayersCanvasInitial()) {
    _initialize();
  }

  void _initialize() {
    _show();
  }

  void addCheckLayer() {
    var offset = _getNewLayerOffset();

    var size = _getNewLayerSize();

    late OperationLayerCubit layerCubit;

    layerCubit = CheckLayerCubit(offset, size, onClose: () {
      _workDoneSubscriptions[layerCubit]!.cancel();
      _workDoneSubscriptions.remove(layerCubit);

      _removeLayer(layerCubit);
    });

    _workDoneSubscriptions[layerCubit] = layerCubit.workDone.listen((_) {
      _workDoneLayerController.sink.add(null);
    });

    layerCubit.verticalDragUpdate.listen((event) {
      _handleVerticalDragUpdate(layerCubit, event);
    });

    layerCubit.verticalDragEnd.listen((event) {
      _handleVerticalDragEnd(layerCubit, event);
    });

    layerCubit.work();

    _addLayer(layerCubit);
  }

  void addSecondCheckLayer() {
    var offset = _getNewLayerOffset();

    var size = _getNewLayerSize();

    late OperationLayerCubit layerCubit;

    layerCubit = SecondCheckLayerCubit(offset, size, onClose: () {
      _workDoneSubscriptions[layerCubit]!.cancel();
      _workDoneSubscriptions.remove(layerCubit);

      _removeLayer(layerCubit);
    });

    _workDoneSubscriptions[layerCubit] = layerCubit.workDone.listen((_) {
      _workDoneLayerController.sink.add(null);
    });

    layerCubit.verticalDragUpdate.listen((event) {
      _handleVerticalDragUpdate(layerCubit, event);
    });

    layerCubit.verticalDragEnd.listen((event) {
      _handleVerticalDragEnd(layerCubit, event);
    });

    layerCubit.work();

    _addLayer(layerCubit);
  }

  Future<void> addRephraseLayer() async {
    var offset = _getNewLayerOffset();

    var size = _getNewLayerSize();

    late OperationLayerCubit layerCubit;

    layerCubit = RephraseLayerCubit(offset, size, onClose: () {
      _workDoneSubscriptions[layerCubit]!.cancel();
      _workDoneSubscriptions.remove(layerCubit);

      _removeLayer(layerCubit);
    });

    _workDoneSubscriptions[layerCubit] = layerCubit.workDone.listen((_) {
      _workDoneLayerController.sink.add(null);
    });

    layerCubit.verticalDragUpdate.listen((event) {
      _handleVerticalDragUpdate(layerCubit, event);
    });

    layerCubit.verticalDragEnd.listen((event) {
      _handleVerticalDragEnd(layerCubit, event);
    });

    await layerCubit.initialize();

    _addLayer(layerCubit);
  }

  Offset _getNewLayerOffset() {
    return Offset(
        0, (_layersCubits.length + 1) * LayerProperties.headerContactHeight);
  }

  Size _getNewLayerSize() {
    return Size(
        _size.width,
        _size.height -
            ((_layersCubits.length + 1) * LayerProperties.headerContactHeight));
  }

  void _removeLayer(OperationLayerCubit layerCubit) {
    _layersCubits.remove(layerCubit);

    if (_layersCubits.isEmpty) {
      _inputLayerCubit.toForeground();
    } else {
      _layersCubits.last.toForeground();
    }

    _removeLayerController.sink.add(null);

    _show();
  }

  void _addLayer(OperationLayerCubit layerCubit) {
    if (_layersCubits.isEmpty) {
      _inputLayerCubit.toBackground();
    } else {
      _layersCubits.last.toBackground();
    }

    _layersCubits.add(layerCubit);

    _show();
  }

  Future<void> animateLayersToTop() async {
    for (var layerCubit in _layersCubits) {
      var border = _getTopBorder(layerCubit);

      var offset = Offset(layerCubit.offset.dx, border);

      _animateTo(layerCubit, offset);
    }
  }

  void _handleVerticalDragUpdate(OperationLayerCubit layerCubit, Offset delta) {
    if (!_isAnimationActive) {
      _move(layerCubit, delta);
    }
  }

  void _handleVerticalDragEnd(
      OperationLayerCubit layerCubit, double primaryVelocity) {
    if (!_isAnimationActive) {
      if (primaryVelocity > 0) {
        var border = _getBottomBorder(layerCubit);

        var offset = Offset(layerCubit.offset.dx, border);

        _animateTo(layerCubit, offset);
      } else if (primaryVelocity < 0) {
        var border = _getTopBorder(layerCubit);

        var offset = Offset(layerCubit.offset.dx, border);

        _animateTo(layerCubit, offset);
      }
    }
  }

  double _getTopBorder(OperationLayerCubit layerCubit) {
    var layerIndex = _layersCubits.indexOf(layerCubit);

    late double border;

    if (layerIndex == 0) {
      border = LayerProperties.headerContactHeight;
    } else {
      border = _layersCubits[layerIndex - 1].offset.dy +
          LayerProperties.headerContactHeight;
    }

    return border;
  }

  double _getBottomBorder(OperationLayerCubit layerCubit) {
    var layerIndex = _layersCubits.indexOf(layerCubit);

    late double border;

    if (layerIndex == _layersCubits.length - 1) {
      border = _size.height -
          LayerProperties.headerContactHeight -
          (BodyProperties.appbarHeight -
              LayerProperties.marginTop -
              LayerProperties.marginBottom);
    } else {
      border = _layersCubits[layerIndex + 1].offset.dy -
          LayerProperties.headerContactHeight;
    }

    return border;
  }

  void _move(OperationLayerCubit layerCubit, Offset delta) {
    var isOffsetChangeNeeded = true, isResizeNeeded = true;

    var offset = Offset(layerCubit.offset.dx, layerCubit.offset.dy + delta.dy);

    if (delta.dy.isNegative) {
      var topBorder = _getTopBorder(layerCubit);

      if (offset.dy < topBorder) {
        offset = Offset(offset.dx, topBorder);

        isResizeNeeded = false;
      } else if (offset.dy == topBorder) {
        isOffsetChangeNeeded = false;
      }
    } else {
      var bottomBorder = _getBottomBorder(layerCubit);

      if (offset.dy > bottomBorder) {
        offset = Offset(offset.dx, bottomBorder);
      } else if (offset.dy == bottomBorder) {
        isOffsetChangeNeeded = false;
      }
    }

    var layerSize = layerCubit.size;

    var size = Size(layerSize.width, layerSize.height - delta.dy);

    if (size.height < _minHeight) {
      size = Size(_size.width, _minHeight);
    }

    if (isOffsetChangeNeeded) {
      layerCubit.setOffset(offset);
    }

    if (isResizeNeeded) {
      layerCubit.setSize(size);
    }

    layerCubit.update();
  }

  void _animateTo(OperationLayerCubit layerCubit, Offset offset) async {
    _isAnimationActive = true;

    if (layerCubit.offset.dy != offset.dy) {
      layerCubit.setAnimationDuration();

      layerCubit.update();

      var size = _getNewSize(layerCubit, offset);

      layerCubit.setSize(size);

      layerCubit.setOffset(offset);

      layerCubit.update();

      await layerCubit.onAnimationEnd.first;

      layerCubit.setMoveDuration();

      layerCubit.update();
    }

    _isAnimationActive = false;
  }

  Size _getNewSize(OperationLayerCubit layerCubit, Offset offset) {
    var difference = layerCubit.offset.dy - offset.dy;

    var size = Size(layerCubit.size.width, layerCubit.size.height + difference);

    return size;
  }

  void _show() {
    emit(LayersCanvasShow(_size, _inputLayerCubit, _layersCubits));
  }

  void pasteText(String text) {
    _inputLayerCubit.pasteText(text);
  }

  @override
  Future<void> close() async {
    await _removeLayerController.close();

    for (var cubit in _layersCubits) {
      await cubit.close();
    }

    await _inputLayerCubit.close();

    return super.close();
  }
}
