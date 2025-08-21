import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:googlemap/domain/model/chart/measure_data.dart';
import 'package:googlemap/domain/model/enum/wireless_type.dart';

import '../../../../common/const/constants.dart';
import 'base_list_check_box.dart';

class TableView extends StatefulWidget {
  final WirelessType type;
  final List<MeasureData> measureDataList;
  final ValueChanged<int> onTapNId;
  final ValueChanged<String> onTapPci;
  final ValueChanged<String> onTapNPci;
  final ValueChanged<List<MeasureData>> onChange;
  final bool isNpci;

  const TableView({
    required this.type,
    required this.measureDataList,
    required this.onTapNId,
    required this.onTapPci,
    required this.onTapNPci,
    required this.onChange,
    this.isNpci = false,
    super.key,
  });

  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  late List<MeasureData> _measureDataList;
  late Map<int, TableColumnWidth> _headerWidth;
  late List<String> _headerTitle;
  var _servingTime = "6";
  String _distanceLimit = "2";

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() {
    print('TableView init ----> ${widget.measureDataList.length}');
    _measureDataList = widget.measureDataList;
    _headerWidth =
        widget.type == WirelessType.wLte ? headerLteWidth : header5gWidth;
    _headerTitle =
        widget.type == WirelessType.wLte ? headerLteTitle : header5gTitle;
  }

  void onChangeDistanceLimit(String distanceLimit) {
    _distanceLimit = distanceLimit;
    _measureDataList = widget.measureDataList.map((measureData) {
      return measureData.copyWith(
        baseList: measureData.baseList.where((baseData) {
          return baseData.distance <= double.parse(distanceLimit);
        }).toList(),
      );
    }).toList();
    widget.onChange(_measureDataList);
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant TableView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.measureDataList != widget.measureDataList) {
      init();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_measureDataList.isEmpty) {
      return const SizedBox();
    }
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: constraints.maxWidth),
          child: Table(
            border: TableBorder.all(
              color: Colors.grey,
            ),
            columnWidths: _headerWidth,
            children: [
              buildTableTitle(),
              ...getMeasuredRows(widget.isNpci),
            ],
          ),
        ),
      );
    });
  }

  TableRow buildTableTitle() {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.grey[300],
      ),
      children: _headerTitle.map((e) {
        final text = widget.isNpci ? 'PCI mW' : e;
        return TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 4.0,
            ),
            child: Center(
              child: _headerTitle.last == e
                  ? Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform.scale(
                              scale: 0.7,
                              child: Checkbox(
                                value: isNeighborCheck,
                                onChanged: (value) {
                                  if (value != null) {
                                    onChangeSelected(value ? 99999 : -1);
                                    _servingTime = "-";
                                  }
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
                        ),
                        Positioned(
                          right: 8,
                          top: 0,
                          bottom: 0,
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    'Distance Limit',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        color: Colors.black54),
                                  ),
                                  SizedBox(
                                    height: 24,
                                    child: DropdownButton<String>(
                                      value: _distanceLimit,
                                      onChanged: (String? newValue) {
                                        if (newValue != null) {
                                          onChangeDistanceLimit(newValue);
                                        }
                                        setState(() {});
                                      },
                                      items: List.generate(
                                        9,
                                        (index) =>
                                            (1.0 + index * 0.5).toString(),
                                      ).map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Center(
                                            child: Text(
                                              value,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      icon: const Icon(
                                          Icons.arrow_drop_down_rounded),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Serving Time',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        color: Colors.black54),
                                  ),
                                  SizedBox(
                                    height: 26,
                                    child: DropdownButton<String>(
                                      value: _servingTime,
                                      onChanged: (String? newValue) {
                                        if (newValue != null) {
                                          _servingTime = newValue;
                                          onChangeSelected(
                                              int.parse(_servingTime));
                                        }
                                        setState(() {});
                                      },
                                      items: List.generate(
                                              11,
                                              (index) => index == 0
                                                  ? "-"
                                                  : index.toString())
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Center(
                                            child: Text(
                                              value,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      icon: Icon(Icons.arrow_drop_down_rounded),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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
    );
  }

  void onChangeSelected(int servingTime) {
    _measureDataList = _measureDataList.map((measureData) {
      return measureData.copyWith(
        baseList: measureData.baseList.map((baseData) {
          return baseData.copyWith(
              isChecked: measureData.sTime == null ||
                  measureData.sTime! <= servingTime);
        }).toList(),
      );
    }).toList();
    widget.onChange(_measureDataList);
    setState(() {});
  }

  List<TableRow> getMeasuredRows(bool isNpci) {
    return _measureDataList.mapIndexed((measureIndex, measureData) {
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
                    style: TextStyle(
                      decoration: isNpci
                          ? TextDecoration.none
                          : TextDecoration.underline,
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
                    widget.isNpci
                        ? measureData.mw?.toStringAsFixed(15) ?? ''
                        : measureData.nPci,
                    style: TextStyle(
                      decoration: isNpci
                          ? TextDecoration.none
                          : TextDecoration.underline,
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
                      _measureDataList[measureIndex] =
                          measureData.copyWith(baseList: baseDataList);
                      widget.onChange(_measureDataList);
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
    return _measureDataList
        .map((measureData) => measureData.baseList)
        .expand((element) => element)
        .every((baseData) => baseData.isChecked);
  }
}
