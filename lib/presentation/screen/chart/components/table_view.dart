import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:googlemap/domain/model/chart/measure_data.dart';
import 'package:googlemap/domain/model/enum/wireless_type.dart';

import '../../../../domain/model/chart/base_data.dart';
import '../../../../domain/model/table_data.dart';

const List<String> heads5G = [
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

const List<String> headsLTE = [
  'PCI',
  'Neighbor\nPCI',
  'Neighbor\nTime',
  'Neighbor\nRSRP\nSUM(dBm)',
  'Interference\nIndex',
  'Serving\nTime',
  'FREQ',
  'CA Type',
  'RP',
  'CQI',
  'RI',
  'DL\nMCS',
  'DL\nRB',
  'DL\nT/P',
  '인근장비'
];

class TableView extends StatefulWidget {
  final WirelessType type;
  final List<MeasureData> measureDataList;
  final ValueChanged<int> onTapNId;
  final ValueChanged<bool> onTapToggle;
  final bool isCheck;
  final ValueChanged<int> onTapPci;
  final ValueChanged<int> onTapNPci;
  final ValueChanged<List<MeasureData>> onChangedMeasureList;

  const TableView({
    required this.type,
    required this.isCheck,
    required this.measureDataList,
    required this.onTapNId,
    required this.onTapToggle,
    required this.onTapPci,
    required this.onTapNPci,
    required this.onChangedMeasureList,
    super.key,
  });

  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  late List<MeasureData> measureDataList;
  late bool isNeighborCheck;

  @override
  void initState() {
    measureDataList = widget.measureDataList;
    isNeighborCheck = false;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TableView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.measureDataList != widget.measureDataList) {
      measureDataList = widget.measureDataList;
      isNeighborCheck = widget.measureDataList.every((element) {
        return element.baseList.every((baseData) => baseData.isChecked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('type > ${widget.type.toString()}');
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowHeight: 60,
        columns: getColumns(),
        horizontalMargin: 8.0,
        rows: getRows(),
        dataRowMinHeight: 10,
        dataRowMaxHeight: 68,
      ),
    );
  }

  List<DataRow> getRows() {
    return measureDataList.mapIndexed(
          (measureIndex, measureData) => getDataRow(
        measureIndex: measureIndex,
        measureData: measureData,
        onChangedMeasureData: (updatedMeasureData) {
          setState(() {
            measureDataList[measureIndex] = updatedMeasureData;
            isNeighborCheck = false;
            widget.onChangedMeasureList(measureDataList);
          });
        },
      ),
    ).toList();
  }

  DataRow getDataRow({
    required int measureIndex,
    required MeasureData measureData,
    required ValueChanged<MeasureData> onChangedMeasureData,
  }) {

    return DataRow(
      selected: measureData.nPci.isNotEmpty,
      color: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.blue.withOpacity(0.14);
          }
          return Colors.white;
        },
      ),
      cells: [
        DataCell(
          InkWell(
            onTap: () => widget.onTapPci(measureIndex),
            child: Text(
              measureData.pci,
              style: const TextStyle(
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        DataCell(
          InkWell(
            onTap: () => widget.onTapNPci(measureIndex),
            child: Text(
              measureData.nPci,
              style: const TextStyle(
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        ...measureData.getValues(widget.type).map(
              (e) => DataCell(Center(child: Text(e.toString()))),
        ),
        DataCell(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: BaseListCheckBox(
              baseList: measureData.baseList,
              onChanged: (baseDataList) {
                onChangedMeasureData(measureData.copyWith(baseList: baseDataList));
              },
            ),
          ),
        ),
      ],
    );
  }

  List<DataColumn> getColumns() {
    final titles = widget.type == WirelessType.wLte ? headsLTE : heads5G;
    return titles.mapIndexed((index, e) {
      return DataColumn(
        label: index == titles.length - 1
            ? Row(
          children: [
            Transform.scale(
              scale: 0.7,
              child: Checkbox(
                value: isNeighborCheck,
                onChanged: (value) {
                  setState(() {
                    isNeighborCheck = value!;
                    measureDataList = measureDataList.map((measureData) {
                      return measureData.copyWith(
                        baseList: measureData.baseList.map((baseData) {
                          return baseData.copyWith(isChecked: value);
                        }).toList(),
                      );
                    }).toList();
                    widget.onChangedMeasureList(measureDataList);
                  });
                },
              ),
            ),
            Text(
              e,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
            : Text(
          e,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }).toList();
  }
}

class BaseListCheckBox extends StatelessWidget {
  final List<BaseData> baseList;
  final ValueChanged<List<BaseData>> onChanged;

  const BaseListCheckBox({
    super.key,
    required this.baseList,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (baseList.isEmpty) {
      return const SizedBox();
    }
    final List<Widget> baseWidgets = baseList
        .mapIndexed((baseIndex, baseData) => Expanded(
              child: BaseCheckBox(
                baseData: baseData,
                onChanged: (value) {
                  baseList[baseIndex] = baseData.copyWith(
                    isChecked: value,
                  );
                  onChanged(baseList);
                },
              ),
            ))
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: baseWidgets,
    );
  }
}

class BaseCheckBox extends StatefulWidget {
  final BaseData baseData;
  final ValueChanged<bool> onChanged;

  const BaseCheckBox({
    super.key,
    required this.baseData,
    required this.onChanged,
  });

  @override
  State<BaseCheckBox> createState() => _BaseCheckBoxState();
}

class _BaseCheckBoxState extends State<BaseCheckBox> {
  late bool isChecked;

  @override
  void initState() {
    isChecked = widget.baseData.isChecked;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BaseCheckBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.baseData != widget.baseData) {
      setState(() {
        isChecked = widget.baseData.isChecked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.scale(
          scale: 0.7,
          child: Checkbox(
            value: isChecked,
            onChanged: (value) {
              setState(() {
                isChecked = value!;
                widget.onChanged(value);
              });
            },
          ),
        ),
        Text(
          widget.baseData.getDescription(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
