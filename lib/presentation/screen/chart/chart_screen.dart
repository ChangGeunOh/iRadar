import 'package:flutter/material.dart';
import 'package:googlemap/domain/bloc/bloc_layout.dart';
import 'package:googlemap/domain/model/place_data.dart';

import '../../../domain/bloc/bloc_event.dart';
import 'viewmodel/chart_bloc.dart';
import 'viewmodel/chart_event.dart';
import 'viewmodel/chart_state.dart';

class ChartScreen extends StatelessWidget {
  final PlaceData? placeData;

  const ChartScreen({
    required this.placeData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocLayout<ChartBloc, ChartState>(
        create: (context) => ChartBloc(
              context,
              ChartState(),
            ),
        builder: (context, bloc, state) {
          if (placeData != null && placeData != state.placeData) {
            bloc.add(BlocEvent(ChartEvent.onPlaceData, extra: placeData));
          }
          if (state.chartTableData != null) {
            print("ChartData>${state.chartTableData!.chartList.length}");
            print("ChartData>${state.chartTableData!.tableList.length}");
          }
          return Scaffold(
            body: Center(
              child: Text('ChartScreen'),
            ),
          );
        });
  }
}
