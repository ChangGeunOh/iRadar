import 'package:flutter/material.dart';
import 'package:googlemap/domain/bloc/bloc_event.dart';
import 'package:googlemap/domain/bloc/bloc_layout.dart';
import 'package:googlemap/domain/model/excel_request_data.dart';
import 'package:googlemap/presentation/screen/chart/components/table_view.dart';

import '../../../common/const/constants.dart';
import '../../../domain/model/excel_response_data.dart';
import 'viewmodel/web_bloc.dart';
import 'viewmodel/web_event.dart';
import 'viewmodel/web_state.dart';

class WebScreen extends StatelessWidget {
  static String get routeName => 'web_screen';

  final ExcelRequestData excelRequestData;

  const WebScreen({
    required this.excelRequestData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocLayout<WebBloc, WebState>(
      create: (context) => WebBloc(context, WebState()),
      builder: (context, bloc, state) {
        if (state.excelResponseList == null) {
          bloc.add(
            BlocEvent(
              WebEvent.onInit,
              extra: excelRequestData,
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(excelRequestData.placeData.name),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Table(
                border: TableBorder.all(width: 1),
                columnWidths: const {
                  0: FlexColumnWidth(0.4),
                  1: FlexColumnWidth(0.4),
                  2: FlexColumnWidth(0.4),
                  3: FlexColumnWidth(2.5),
                  4: FlexColumnWidth(0.2),
                  5: FlexColumnWidth(0.2),
                  6: FlexColumnWidth(0.5),
                  7: FlexColumnWidth(0.5),
                  8: FlexColumnWidth(1),
                  9: FlexColumnWidth(2),
                  10: FlexColumnWidth(0.5),
                  11: FlexColumnWidth(0.5),
                  12: FlexColumnWidth(0.5),
                  13: FlexColumnWidth(0.5),
                  14: FlexColumnWidth(0.5),
                  15: FlexColumnWidth(0.5),
                  16: FlexColumnWidth(0.8),
                  17: FlexColumnWidth(0.8),
                },
                children: [
                  _getTableHeader(),
                  if (state.excelResponseList != null)
                    ..._getTableRow(state.excelResponseList!),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  TableRow _getTableHeader() {
    return TableRow(
      children: kWebHeaders
          .map(
            (e) => Container(
              color: Colors.grey.withAlpha(100),
              height: 50,
              width: 150,
              child: Center(
                child: Text(
                  e,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  List<TableRow> _getTableRow(List<ExcelResponseData> excelList) {
    final tableList = excelList
        .map(
          (e) => TableRow(children: [
            _cell(e.division, e.hasColor),
            _cell(e.sido, e.hasColor),
            _cell(e.sigungu, e.hasColor),
            _cell(e.area, e.hasColor),
            _cell(e.team, e.hasColor),
            _cell(e.jo, e.hasColor),
            _cell(e.year, e.hasColor),
            _cell(e.type, e.hasColor),
            _cell(e.id, e.hasColor),
            _cell(e.rnm, e.hasColor),
            _cell(e.memo, e.hasColor),
            _cell(e.atten, e.hasColor),
            _cell(e.cellLock, e.hasColor),
            _cell(e.ruLock, e.hasColor),
            _cell(e.relayLock, e.hasColor),
            _cell(e.pci, e.hasColor),
            _cell(e.scenario, e.hasColor),
            _cell(e.regDate.split(' ').first, e.hasColor),
          ]),
        )
        .toList();

    return tableList;
  }

  Widget _cell(String text, bool hasColor) {
    return Container(
      color: hasColor ? Colors.yellow.withAlpha(128) : Colors.transparent,
      height: 45,
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
