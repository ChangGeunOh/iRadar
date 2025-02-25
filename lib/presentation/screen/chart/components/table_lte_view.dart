import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:googlemap/domain/model/enum/wireless_type.dart';

import '../../../../common/const/constants.dart';
import '../../../../domain/model/chart/measure_data.dart';
import 'base_list_check_box.dart';



class TableLteView extends StatefulWidget {
  final WirelessType type;
  final List<MeasureData> measureDataList;
  final Function(List<MeasureData>) onChange;
  final Function(String) onTapPci;
  final Function(String) onTapNPci;

  const TableLteView({
    super.key,
    required this.type,
    required this.measureDataList,
    required this.onChange,
    required this.onTapNPci,
    required this.onTapPci,
  });

  @override
  State<TableLteView> createState() => _TableLteViewState();
}

class _TableLteViewState extends State<TableLteView> {
  late List<MeasureData> measureDataList;
  late bool isNPciData;
  late Map<int, TableColumnWidth> headerWidth;
  late List<String> headerTitle;

  @override
  void initState() {
    measureDataList = widget.measureDataList;
    isNPciData = measureDataList.every((element) => element.nPci.isEmpty);
    headerWidth = widget.type == WirelessType.wLte ? headerLteWidth : header5gWidth;
    headerTitle = widget.type == WirelessType.wLte ? headerLteTitle : header5gTitle;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        border: TableBorder.all(
          color: Colors.grey,
        ),
        columnWidths: headerWidth,
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: Colors.grey[300],
            ),
            children: headerTitle.map((e) {
              final text = isNPciData ? 'PCI mW' : e;
              return TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: Center(
                    child: headerTitle.last == e
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Transform.scale(
                                scale: 0.7,
                                child: Checkbox(
                                  value: isNeighborCheck,
                                  onChanged: (value) {
                                    setState(() {
                                      measureDataList =
                                          measureDataList.map((measureData) {
                                        return measureData.copyWith(
                                          baseList: measureData.baseList
                                              .map((baseData) {
                                            return baseData.copyWith(
                                                isChecked: value);
                                          }).toList(),
                                        );
                                      }).toList();
                                      widget.onChange(
                                          measureDataList);
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                '인근장비',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              )
                            ],
                          )
                        : Text(
                            e == headerLteTitle[1] ? text : e,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                  ),
                ),
              );
            }).toList(),
          ),
          ...getMeasuredRows(),
        ],
      ),
    );
  }

  List<TableRow> getMeasuredRows() {
    return measureDataList.mapIndexed((measureIndex, measureData) {
      return TableRow(
        decoration: BoxDecoration(
          color: measureData.hasColor ? Colors.yellowAccent : Colors.white,
        ),
        children: [
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: InkWell(
                onTap: () => widget.onTapPci(measureData.pci),
                child: Center(
                  child: Text(
                    measureData.pci,
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Center(
                child: InkWell(
                  onTap: measureData.nPci.isEmpty
                      ? null
                      : () {
                          widget.onTapNPci(measureData.pci);
                        },
                  child: Text(
                    isNPciData
                        ? measureData.mw!.toStringAsFixed(15)
                        : measureData.nPci,
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ),
          ),
          ...measureData.getValues(widget.type).map(
                (e) => TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Center(child: Text(e.toString())),
                  ),
                ),
              ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: SizedBox(
                height: 20 * measureData.baseList.length.toDouble(),
                child: BaseListCheckBox(
                  baseList: measureData.baseList,
                  onChanged: (baseDataList) {
                    setState(() {
                      measureDataList[measureIndex] =
                          measureData.copyWith(baseList: baseDataList);
                      widget.onChange(measureDataList);
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  bool get isNeighborCheck {
    return measureDataList
        .map((measureData) => measureData.baseList)
        .expand((element) => element)
        .every((baseData) => baseData.isChecked);
  }
}
