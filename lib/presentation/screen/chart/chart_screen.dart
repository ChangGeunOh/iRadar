import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:googlemap/common/const/color.dart';
import 'package:googlemap/domain/bloc/bloc_scaffold.dart';
import 'package:googlemap/domain/model/chart/measure_data.dart';
import 'package:googlemap/domain/model/chart_data.dart';
import 'package:googlemap/domain/model/map/area_data.dart';
import 'package:googlemap/presentation/screen/chart/components/expanded_search.dart';
import 'package:googlemap/presentation/screen/npci/npci_screen.dart';
import 'package:googlemap/presentation/screen/pci/pci_screen.dart';

import '../../../domain/bloc/bloc_event.dart';
import '../../../domain/model/enum/wireless_type.dart';
import 'components/chart_view.dart';
import 'components/table_view.dart';
import 'viewmodel/chart_bloc.dart';
import 'viewmodel/chart_event.dart';
import 'viewmodel/chart_state.dart';

class ChartScreen extends StatefulWidget {
  final AreaData areaData;
  final bool isNpci;

  const ChartScreen({
    required this.areaData,
    this.isNpci = false,
    super.key,
  });

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  var isUpdated = false;

  @override
  didUpdateWidget(ChartScreen oldWidget) {
    isUpdated = true;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    print('ChartScreen Build');
    return BlocScaffold<ChartBloc, ChartState>(create: (context) {
      print('ChartScreen Create');
      return ChartBloc(
        context,
        ChartState(
          areaData: widget.areaData,
        ),
      );
    }, appBarBuilder: (context, bloc, state) {
      return AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(widget.areaData.type == WirelessType.wLte
                ? 'assets/icons/ic_lte.svg'
                : 'assets/icons/ic_5g.svg'),
            const SizedBox(width: 16),
            Text(widget.areaData.name),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            bloc.add(BlocEvent(ChartEvent.onTapDeduplication));
          },
          icon: Icon(
            Icons.timer_outlined,
            color: state.isDeduplication ? Colors.black87 : Colors.grey,
          ),
        ),
        actions: [
          // ExpandedSearch(
          //   onSearchValue: (value) {
          //     print("value>$value");
          //   },
          // ),
          IconButton(
            onPressed: () => bloc.add(BlocEvent(ChartEvent.onTapWeb)),
            icon: const Icon(
              Icons.web,
              color: Colors.black87,
            ),
          ),
          IconButton(
              onPressed: () => bloc.add(BlocEvent(ChartEvent.onTapExcel)),
              icon: Image.asset(
                'assets/icons/ic_excel.png',
                width: 20,
                height: 20,
              )),
          IconButton(
            onPressed: () => bloc.add(BlocEvent(ChartEvent.onTapExcelDownload)),
            icon: const Icon(
              Icons.file_download,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 20),
        ],
      );
    }, builder: (context, bloc, state) {
      print('ChartScreen Build>${state.isDeduplication}');
      if (isUpdated) {
        bloc.add(BlocEvent(
          ChartEvent.onTapDeduplication,
          extra: false,
        ));
      }
      isUpdated = false;
      if (widget.areaData != state.areaData) {
        bloc.add(BlocEvent(
          ChartEvent.onChangedAreaData,
          extra: widget.areaData,
        ));
        return const SizedBox();
      }
      print('------------------>${state.measureDataList.length}');
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
                        measureDataList: state.measureDataList,
                        onChange: (measureDataList) => bloc.add(BlocEvent(
                              ChartEvent.onChangedMeasureList,
                              extra: measureDataList,
                            )),
                        onTapNId: (tableData) => bloc.add(
                            BlocEvent(ChartEvent.onTapNId, extra: tableData)),
                        onTapPci: (pci) {
                          _showDialog(
                            context: context,
                            type: widget.areaData.type!,
                            idx: widget.areaData.idx,
                            spci: pci,
                          );
                        },
                        onTapNPci: (npci) {
                          _showNpciDialog(
                            context: context,
                            type: widget.areaData.type!,
                            idx: widget.areaData.idx,
                            spci: npci,
                            measureDataList: state.measureDataList,
                          );
                        }),
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

  void _showDialog({
    required BuildContext context,
    required WirelessType type,
    required int idx,
    required String spci,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    right: 20.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 24.0,
                        right: 24,
                        top: 24,
                        bottom: 24,
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: PciScreen(
                          type: type,
                          idx: idx,
                          spci: spci,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    iconSize: 32,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.white),
                    ),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _showNpciDialog({
    required BuildContext context,
    required WirelessType type,
    required int idx,
    required String spci,
    required List<MeasureData> measureDataList,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: NpciScreen(
                        areaData: widget.areaData,
                        pci: spci,
                        measureDataList: measureDataList,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: IconButton(
                    iconSize: 32,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.white),
                    ),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
