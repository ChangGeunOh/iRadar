import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../../domain/model/table_data.dart';

class TableLayout extends StatelessWidget {
  final List<String> headTitles = [
    'PCI',
    'PCI_mW',
    'Neighbor\nTime',
    'Neighbor\nRSRP\nSUM(dBm)',
    'Interference\nIndex',
    'Serving\nTime',
    'CQI',
    'RI',
    'DL\nMCS',
    'DL\nLayer',
    'DL\nRB',
    'DL\nT/P',
    '인근장비'
  ];

  final List<TableData> tableList;
  final VoidCallback onTapToggle;
  final ValueChanged onTapNId;
  final bool isCheck;


  TableLayout({
    required this.tableList,
    required this.isCheck,
    required this.onTapToggle,
    required this.onTapNId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: getColumns(),
        horizontalMargin: 16.0,
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
        rows: getRows(),
      ),
    );
  }

  List<DataRow> getRows() {
    return tableList
        .map(
          (e) => DataRow(
            selected: e.checked,
            color: MaterialStateProperty.resolveWith((states) {
              if (e.hasColor) {
                return Colors.yellow.withAlpha(64);
              }
            }),
            cells: [
              DataCell(Text(e.pci)),
              DataCell(Text(e.pciMw)),
              DataCell(Text(e.nTime)),
              DataCell(Text(e.nRsrp)),
              DataCell(Text(e.index)),
              DataCell(Text(e.sTime)),
              DataCell(Text(e.cqi)),
              DataCell(Text(e.ri)),
              DataCell(Text(e.dlMcs)),
              DataCell(Text(e.dlLayer)),
              DataCell(Text(e.dlRb)),
              DataCell(Text(e.dlTb)),
              DataCell(
                Row(
                  children: [
                    Transform.scale(
                      scale: 0.7,
                      child: Checkbox(
                        value: e.checked,
                        onChanged: (value) =>
                            onTapNId(e),
                      ),
                    ),
                    Text(e.nearby()),
                  ],
                ),
              ),
            ],
          ),
        )
        .toList();
  }

  List<DataColumn> getColumns() {
    return headTitles.mapIndexed((index, e) {
      final dataColumn = index == headTitles.length - 1
          ? DataColumn(
        label: Row(
          children: [
            Transform.scale(
              scale: 0.7,
              child: Checkbox(
                value: isCheck,
                onChanged: (value) {
                  onTapToggle();
                },
              ),
            ),
            Text(
              e,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
          : DataColumn(
        label: Text(
          e,
          textAlign: TextAlign.center,
        ),
      );
      return dataColumn;
    }).toList();
  }
}
