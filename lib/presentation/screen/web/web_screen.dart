import 'package:flutter/material.dart';
import 'package:googlemap/domain/bloc/bloc_scaffold.dart';
import 'package:googlemap/domain/model/excel_request_data.dart';

import '../../../common/const/constants.dart';
import '../../../domain/bloc/bloc_event.dart';
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
    print(excelRequestData.toJson());
    return BlocScaffold<WebBloc, WebState>(
      appBarBuilder: (context, bloc, state) {
        return AppBar(
          centerTitle: true,
          title: Text(
            excelRequestData.areaData.name,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => bloc.add(
                BlocEvent(
                  WebEvent.onTapDownload,
                ),
              ),
              icon: const Icon(
                Icons.file_download,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 20),
          ],
        );
      },
      create: (context) =>
          WebBloc(context, WebState(excelRequestData: excelRequestData)),
      builder: (context, bloc, state) {
        return Stack(
          children: [
            SingleChildScrollView(
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
                    ..._getTableRow(state.excelResponseList),
                  ],
                ),
              ),
            ),
            if (state.isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
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
    return excelList.map((e) {
      return TableRow(children: [
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
      ]);
    }).toList();
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
