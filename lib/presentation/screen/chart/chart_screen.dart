import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:googlemap/common/const/color.dart';
import 'package:googlemap/domain/bloc/bloc_layout.dart';
import 'package:googlemap/domain/bloc/bloc_scaffold.dart';
import 'package:googlemap/domain/model/map/area_data.dart';
import 'package:googlemap/presentation/screen/chart/components/expanded_search.dart';

import '../../../domain/bloc/bloc_event.dart';
import '../../../domain/model/enum/wireless_type.dart';
import 'components/chart_view.dart';
import 'components/table_view.dart';
import 'viewmodel/chart_bloc.dart';
import 'viewmodel/chart_event.dart';
import 'viewmodel/chart_state.dart';

class ChartScreen extends StatelessWidget {
  final AreaData areaData;

  const ChartScreen({
    required this.areaData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocScaffold<ChartBloc, ChartState>(
        create: (context) => ChartBloc(
              context,
              ChartState(areaData: areaData),
            ),
        appBarBuilder: (context, bloc, state) {
          return AppBar(
            centerTitle: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(areaData.type == WirelessType.wLte
                    ? 'assets/icons/ic_lte.svg'
                    : 'assets/icons/ic_5g.svg'),
                const SizedBox(width: 16),
                Text(areaData.name),
              ],
            ),
            actions: [
              ExpandedSearch(
                onSearchValue: (value) {
                  print("value>$value");
                },
              ),
              IconButton(
                onPressed: () => bloc.add(BlocEvent(ChartEvent.onTapWeb)),
                icon: const Icon(
                  Icons.web,
                  color: Colors.black87,
                ),
              ),
              IconButton(
                onPressed: () => bloc.add(BlocEvent(ChartEvent.onTapExcel)),
                icon: const Icon(
                  Icons.file_download,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 20),
            ],
          );
        },
        builder: (context, bloc, state) {
          if (areaData != state.areaData) {
            bloc.add(BlocEvent(
              ChartEvent.onChangedAreaData,
              extra: areaData,
            ));
          }
          return Stack(
            children: [
              ListView(
                children: [
                  const SizedBox(height: 24),
                  if (state.measureDataList.isNotEmpty)
                    SizedBox(
                      height: 350,
                      child: ChartView(
                        measureDataList: state.measureDataList,
                      ),
                    ),
                  const SizedBox(height: 24),
                  if (state.measureDataList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Center(
                        child: TableView(
                          type: state.areaData.type!,
                          isCheck: state.isCheck,
                          measureDataList: state.measureDataList,
                          onChangedMeasureList: (measureDataList) =>
                              bloc.add(BlocEvent(
                            ChartEvent.onChangedMeasureList,
                            extra: measureDataList,
                          )),
                          onTapNId: (tableData) => bloc.add(
                              BlocEvent(ChartEvent.onTapNId, extra: tableData)),
                          onTapToggle: (value) => bloc.add(
                              BlocEvent(ChartEvent.onTapToggle, extra: value)),
                          onTapPci: (tableData) => bloc.add(
                              BlocEvent(ChartEvent.onTapPci, extra: tableData)),
                          onTapNPci: (tableData) => bloc.add(BlocEvent(
                              ChartEvent.onTapNPci,
                              extra: tableData)),
                        ),
                      ),
                    ),
                ],
              ),
              if (state.isLoading)
                Container(
                  color: Colors.black.withOpacity(0.2),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  ),
                ),
            ],
          );
        });
  }
}

/*
BlocLayout<ChartBloc, ChartState>(
        create: (context) => ChartBloc(
              context,
              ChartState(areaData: areaData),
            ),
        builder: (context, bloc, state) {
          if (areaData != state.areaData) {
            bloc.add(BlocEvent(
              ChartEvent.onChangedAreaData,
              extra: areaData,
            ));
          }
          return Stack(
            children: [
              ListView(
                children: [
                  AppBar(
                    centerTitle: true,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(areaData.type == WirelessType.wLte
                            ? 'assets/icons/ic_lte.svg'
                            : 'assets/icons/ic_5g.svg'),
                        const SizedBox(width: 16),
                        Text(areaData.name),
                      ],
                    ),
                    actions: [
                      ExpandedSearch(
                        onSearchValue: (value) {
                          print("value>$value");
                        },
                      ),
                      IconButton(
                        onPressed: () =>
                            bloc.add(BlocEvent(ChartEvent.onTapWeb)),
                        icon: const Icon(
                          Icons.web,
                          color: Colors.black87,
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            bloc.add(BlocEvent(ChartEvent.onTapExcel)),
                        icon: const Icon(
                          Icons.file_download,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (state.measureDataList.isNotEmpty)
                    SizedBox(
                      height: 350,
                      child: ChartView(
                        measureDataList: state.measureDataList,
                      ),
                    ),
                  const SizedBox(height: 24),
                  if (state.measureDataList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Center(
                        child: TableView(
                          type: state.areaData.type!,
                          isCheck: state.isCheck,
                          measureDataList: state.measureDataList,
                          onChangedMeasureList: (measureDataList) =>
                              bloc.add(BlocEvent(
                            ChartEvent.onChangedMeasureList,
                            extra: measureDataList,
                          )),
                          onTapNId: (tableData) => bloc.add(
                              BlocEvent(ChartEvent.onTapNId, extra: tableData)),
                          onTapToggle: (value) => bloc.add(
                              BlocEvent(ChartEvent.onTapToggle, extra: value)),
                          onTapPci: (tableData) => bloc.add(
                              BlocEvent(ChartEvent.onTapPci, extra: tableData)),
                          onTapNPci: (tableData) => bloc.add(BlocEvent(
                              ChartEvent.onTapNPci,
                              extra: tableData)),
                        ),
                      ),
                    ),
                ],
              ),
              if (state.isLoading)
                Container(
                  color: Colors.black.withOpacity(0.2),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  ),
                ),
            ],
          );
        });


 */
