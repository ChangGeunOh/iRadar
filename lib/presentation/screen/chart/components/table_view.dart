import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../../domain/model/table_data.dart';

const List<String> headTitles = [
  'PCI',
  'Neighbor\nPCI',
  'Neighbor\nTime',
  'Neighbor\nRSRP\nSUM(dBm)',
  'Interference\nIndex',
  'Serving\nTime',
  'RP',
  'CQI',
  'RI',
  'DL\nMCS',
  'DL\nLayer',
  'DL\nRB',
  'DL\nT/P',
  '인근장비'
];

class TableView extends StatelessWidget {
  final List<TableData> tableData;
  final ValueChanged onTapNId;
  final VoidCallback onTapToggle;
  final bool isCheck;
  final ValueChanged onTapPci;
  final ValueChanged onTapNPci;

  const TableView({
    required this.isCheck,
    required this.tableData,
    required this.onTapNId,
    required this.onTapToggle,
    required this.onTapPci,
    required this.onTapNPci,
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
    return tableData
        .map(
          (e) => DataRow(
            selected: e.checked,
            color: MaterialStateProperty.resolveWith((states) {
              if (e.hasColor) {
                return Colors.yellow.withAlpha(64);
              }
            }),
            cells: [
              DataCell(
                InkWell(
                  onTap: () => onTapPci(e),
                  child: Text(
                    e.pci,
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              DataCell(
                InkWell(
                  onTap: () => onTapNPci(e),
                  child: Text(
                    e.nPci,
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              DataCell(Text(e.nTime.toString())),
              DataCell(Text(e.nRsrp.toString())),
              DataCell(Text(e.index.toString())),
              DataCell(Text(e.sTime.toString())),
              DataCell(Text(e.rp.toString())),
              DataCell(Text(e.cqi.toString())),
              DataCell(Text(e.ri.toString())),
              DataCell(Text(e.dlMcs.toString())),
              DataCell(Text(e.dlLayer.toString())),
              DataCell(Text(e.dlRb.toString())),
              DataCell(Text(e.dlTb.toString())),
              DataCell(
                Row(
                  children: [
                    Transform.scale(
                      scale: 0.7,
                      child: Checkbox(
                        value: e.checked,
                        onChanged: (value) => onTapNId(e),
                      ),
                    ),
                    Text(e.nearby().toString()),
                  ],
                ),
                onTap: () => onTapNId(e),
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
                        print('onChagned...');
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

/*
 [
        const DataColumn(
          label: Text(
            'PCI',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ),
        const DataColumn(
          label: Text(
            'Neighbor\nPCI',
            style: TextStyle(
              fontSize: 12,
              height: 1.1,
            ),
          ),
        ),
        const DataColumn(
          label: Text(
            'Neighbor\nTime',
            style: TextStyle(
              fontSize: 12,
              height: 1.1,
            ),
          ),
        ),
        const DataColumn(
          label: Text(
            'Neighbor\nRSRP\nSUM(dBm)',
            style: TextStyle(
              fontSize: 12,
              height: 1.1,
            ),
          ),
        ),
        const DataColumn(
          label: Text(
            'Interference\nIndex',
            style: TextStyle(
              fontSize: 12,
              height: 1.1,
            ),
          ),
        ),
        const DataColumn(
          label: Text(
            'Serving\nTime',
            style: TextStyle(
              fontSize: 12,
              height: 1.1,
            ),
          ),
        ),
        const DataColumn(
          label: Text(
            'RP',
            style: TextStyle(
              fontSize: 12,
              height: 1.1,
            ),
          ),
        ),
        const DataColumn(
          label: Text(
            'CQI',
            style: TextStyle(
              fontSize: 12,
              height: 1.1,
            ),
          ),
        ),
        const DataColumn(
          label: Text(
            'RI',
            style: TextStyle(
              fontSize: 12,
              height: 1.1,
            ),
          ),
        ),
        const DataColumn(
          label: Text(
            'DL\nMCS',
            style: TextStyle(
              fontSize: 12,
              height: 1.1,
            ),
          ),
        ),
        const DataColumn(
          label: Text(
            'DL\nLayer',
            style: TextStyle(
              fontSize: 12,
              height: 1.1,
            ),
          ),
        ),
        const DataColumn(
          label: Text(
            'DL\nRB',
            style: TextStyle(
              fontSize: 12,
              height: 1.1,
            ),
          ),
        ),
        const DataColumn(
          label: Text(
            'DL\nT/P',
            style: TextStyle(
              fontSize: 12,
              height: 1.1,
            ),
          ),
        ),
        DataColumn(
          label: Row(
            children: [
              Transform.scale(
                scale: 0.7,
                child: Checkbox(
                  value: false,
                  onChanged: (value) {},
                ),
              ),
              const Text(
                '인근장비',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ]
 */
