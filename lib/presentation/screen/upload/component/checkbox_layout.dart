import 'package:flutter/material.dart';

import '../../../component/check_text_box.dart';

class CheckBoxLayout extends StatelessWidget {
  final bool isNoLocation;
  final bool isLteOnly;
  final bool isWideArea;
  final bool isAddData;
  final ValueChanged onChangedLocation;
  final ValueChanged onChangedLteOnly;
  final ValueChanged onChangedWideArea;
  final ValueChanged onChangedAddData;

  const CheckBoxLayout({
    required this.isNoLocation,
    required this.isLteOnly,
    required this.isWideArea,
    required this.isAddData,
    required this.onChangedLocation,
    required this.onChangedLteOnly,
    required this.onChangedWideArea,
    required this.onChangedAddData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CheckTextBox(
          onChanged: onChangedLocation,
          text: '위치정보없음',
          value: isNoLocation,
        ),
        const SizedBox(width: 16),
        CheckTextBox(
          onChanged: onChangedLteOnly,
          text: 'LTE Only',
          value: isLteOnly ?? false,
        ),
        const SizedBox(width: 16),
        CheckTextBox(
          onChanged: onChangedWideArea,
          text: '넓은 지역 (고속도로 등)',
          value: isWideArea,
        ),
        const SizedBox(width: 100),
        const Spacer(),
        CheckTextBox(
          onChanged: onChangedAddData,
          text: '기존자료에 추가',
          checkColor: Colors.red,
          value: isAddData,
        ),
        const SizedBox(width: 180),
      ],
    );
  }
}