import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/layer/layers_canvas/layers_canvas_cubit.dart';
import '../../cubit/layer/operation_layer/operation_layer.dart';
import 'operation_layer/operation_layer.dart';
import 'text_input_layer/text_input_layer.dart';

class LayersCanvas extends StatelessWidget {
  const LayersCanvas({Key? key}) : super(key: key);

  List<Widget> _buildContent(LayersCanvasShow state) {
    var content = <Widget>[];

    content.add(BlocProvider.value(
        value: state.inputLayerCubit, child: const TextInputLayer()));

    content.addAll(_buildLayers(state.layersCubits));

    return content;
  }

  List<Widget> _buildLayers(List<OperationLayerCubit> layersCubits) {
    var layers = <Widget>[];

    for (var cubit in layersCubits) {
      layers
          .add(BlocProvider.value(value: cubit, child: const OperationLayer()));
    }

    return layers;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayersCanvasCubit, LayersCanvasState>(
        builder: (context, state) {
      if (state is LayersCanvasShow) {
        return Stack(
          children: _buildContent(state),
        );
      } else {
        return Container();
      }
    });
  }
}
