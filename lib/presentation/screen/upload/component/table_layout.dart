import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../../domain/model/upload/intf_tt_data.dart';

class TableLayout extends StatelessWidget {
  final List<IntfTtData> intfTtList;

  const TableLayout({
    required this.intfTtList,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columnSpacing: 62,
      dataRowMaxHeight: 30,
      dataRowMinHeight: 20,
      columns: _getColumns(),
      rows: _getRows(intfTtList),
      headingTextStyle: const TextStyle(
        fontSize: 12,
        height: 1.1,
      ),
      dataTextStyle: const TextStyle(
        fontSize: 12,
        height: 1.1,
      ),
      headingRowColor: MaterialStateProperty.resolveWith<Color?>(
            (states) => const Color(0x10000000),
      ),
      showBottomBorder: true,
    );
  }

  List<DataRow> _getRows(List<IntfTtData> intfTtList) {

    return intfTtList
        .mapIndexed((index, e) => DataRow(cells: [
      DataCell(Text((index + 1).toString())),
      DataCell(Text(e.lat.toString())),
      DataCell(Text(e.lng.toString())),

      DataCell(Text(e.cells5 ?? '')),
      DataCell(Text(e.pci5 ?? '')),
      DataCell(Text(e.rp5.toString())),

      DataCell(Text(e.cells ?? '')),
      DataCell(Text(e.pci ?? '')),
      DataCell(Text(e.rp.toString())),

      DataCell(Text(e.cqi5.toString())),
      DataCell(Text(e.ri5.toString())),
      DataCell(Text(e.dlmcs5.toString())),
      DataCell(Text(e.dll5.toString())),
      DataCell(Text(e.dlrb5.toString())),
      DataCell(Text(e.dltp5.toString())),

      DataCell(Text(e.ear.toString())),
      DataCell(Text(e.ca.toString())),
      DataCell(Text(e.cqi.toString())),

      DataCell(Text(e.ri.toString())),
      DataCell(Text(e.dlmcs.toString())),
      DataCell(Text(e.dlrb.toString())),
      DataCell(Text(e.dltp.toString())),
    ]))
        .toList();
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