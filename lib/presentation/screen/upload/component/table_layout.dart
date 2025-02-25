import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../domain/model/upload/intf_tt_data.dart';

class TableLayout extends StatefulWidget {
  final List<IntfTtData> intfTtList;

  const TableLayout({
    required this.intfTtList,
    super.key,
  });

  @override
  State<TableLayout> createState() => _TableLayoutState();
}

class _TableLayoutState extends State<TableLayout> {
  @override
  Widget build(BuildContext context) {
    print('widget.intfTtList.length>${widget.intfTtList.length}');
    return PaginatedDataTable(
      source: _DataSource(intfTtList: widget.intfTtList),
      columnSpacing: 62,
      dataRowMaxHeight: 30,
      dataRowMinHeight: 20,
      columns: _getColumns(),
      rowsPerPage: 30,
      // rows: _getRows(widget.intfTtList),
      // headingTextStyle: const TextStyle(
      //   fontSize: 12,
      //   height: 1.1,
      // ),
      // dataTextStyle: const TextStyle(
      //   fontSize: 12,
      //   height: 1.1,
      // ),
      headingRowColor: WidgetStateProperty.resolveWith<Color?>(
            (states) => const Color(0x10000000),
      ),
      // showBottomBorder: true,
    );
  }



  List<DataColumn> _getColumns() {
    final headers = [
      'idx',
      'lat',
      'lng',

      'cells5',
      'pci5',
      'rp5',

      'cells',
      'pci',
      'rp',

      'cqi5',
      'ri5',
      'dlmcs5',
      'dll5',
      'dlrb5',
      'dl5',

      'ear',
      'ca',
      'cqi',

      'ri',
      'mcs',
      'rb',
      'dl',
    ];
    return headers
        .map(
          (e) => DataColumn(
        label: Text(
          e,
          textAlign: TextAlign.center,
        ),
      ),
    )
        .toList();
  }

}


class _DataSource extends DataTableSource {
  final List<IntfTtData> intfTtList;

  _DataSource({
    required this.intfTtList,
  });

  @override
  DataRow? getRow(int index) {
    final data = intfTtList[index];
    return DataRow(cells: [
      DataCell(Text(_toText(index + 1))),
      DataCell(Text(_toText(data.lat))),
      DataCell(Text(_toText(data.lng))),

      DataCell(Text(_toText(data.cells5))),
      DataCell(Text(_toText(data.pci5))),
      DataCell(Text(_toText(data.rp5))),

      DataCell(Text(_toText(data.cells))),
      DataCell(Text(_toText(data.pci))),
      DataCell(Text(_toText(data.rp))),

      DataCell(Text(_toText(data.cqi5))),
      DataCell(Text(_toText(data.ri5))),
      DataCell(Text(_toText(data.dlmcs5))),
      DataCell(Text(_toText(data.dll5))),
      DataCell(Text(_toText(data.dlrb5))),
      DataCell(Text(_toText(data.dltp5))),

      DataCell(Text(_toText(data.ear))),
      DataCell(Text(_toText(data.ca))),
      DataCell(Text(_toText(data.cqi))),

      DataCell(Text(_toText(data.ri))),
      DataCell(Text(_toText(data.dlmcs))),
      DataCell(Text(_toText(data.dlrb))),
      DataCell(Text(_toText(data.dltp))),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => intfTtList.length;

  @override
  int get selectedRowCount => 0;
  
  String _toText(dynamic value) {
    if (value == null) {
      return '';
    }
    return value.toString();
  }

}