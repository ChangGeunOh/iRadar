import 'package:flutter/material.dart';
import 'package:googlemap/domain/bloc/bloc_layout.dart';
import 'package:googlemap/domain/model/place_data.dart';
import 'package:googlemap/presentation/screen/chart/components/expanded_search.dart';

import '../../../domain/bloc/bloc_event.dart';
import 'components/chart_view.dart';
import 'components/table_view.dart';
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
          return ListView(
            children: [
              if (state.placeData != null)
                AppBar(
                  centerTitle: true,
                  title: Text(placeData!.name),
                  actions: [
                    ExpandedSearch(
                      onSearchValue: (value) {
                        print("value>$value");
                      },
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.web,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.file_download,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              const SizedBox(height: 24),
              if (state.chartTableData != null)
                SizedBox(
                  height: 350,
                  child: ChartView(
                    charList: state.chartTableData!.chartList,
                  ),
                ),
              const SizedBox(height: 24),
              if (state.chartTableData != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Center(
                    child: TableView(
                      isCheck: state.isCheck,
                      tableData: state.chartTableData!.tableList,
                      onTapNId: (tableData) => bloc.add(
                          BlocEvent(ChartEvent.onTapNId, extra: tableData)),
                      onTapToggle: () =>
                          bloc.add(BlocEvent(ChartEvent.onTapToggle)),
                      onTapPci: (tableData) => bloc.add(
                          BlocEvent(ChartEvent.onTapPci, extra: tableData)),
                      onTapNPci: (tableData) => bloc.add(
                          BlocEvent(ChartEvent.onTapNPci, extra: tableData)),
                    ),
                  ),
                ),
            ],
          );
        });
  }
}
