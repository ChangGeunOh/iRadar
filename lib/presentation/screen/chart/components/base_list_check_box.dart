import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../../domain/model/chart/base_data.dart';

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
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}