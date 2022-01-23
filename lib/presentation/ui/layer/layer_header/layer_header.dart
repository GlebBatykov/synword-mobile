import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synword_flutter_cubit_application/presentation/cubit/layer/layer_header/layer_header_cubit.dart';

import 'layer_header_close_button.dart';

class LayerHeader extends StatelessWidget {
  const LayerHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayerHeaderCubit, LayerHeaderState>(
        builder: (context, state) {
      if (state is LayerHeaderForeground) {
        return LayoutBuilder(builder: (context, constraints) {
          return Row(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20),
                width: constraints.maxWidth * 0.2,
                child: state.isActionsVisible
                    ? Row(
                        children: state.actions,
                      )
                    : Container(),
              ),
              Expanded(
                  child: Center(
                child: Text(state.title,
                    style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Audrey',
                        fontStyle: FontStyle.normal)),
              )),
              Container(
                  padding: const EdgeInsets.only(right: 25),
                  alignment: Alignment.centerRight,
                  width: constraints.maxWidth * 0.20,
                  child: InkWell(
                      onTap: () {}, child: const LayerHeaderCloseButton()))
            ],
          );
        });
      } else if (state is LayerHeaderBackground) {
        return Container();
      } else {
        return Container();
      }
    });
  }
}