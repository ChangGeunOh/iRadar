import 'package:flutter/material.dart';

import '../../../component/check_text_box.dart';
import '../../../component/edit_text.dart';

class BottomLayout extends StatelessWidget {
  final bool isNoLocation;
  final bool isLteOnly;
  final bool isAddData;
  final bool isWideArea;
  final bool enabledSave;
  final ValueChanged onWideArea;
  final ValueChanged onAddData;
  final ValueChanged onChangedPassword;
  final VoidCallback onTapSave;

  const BottomLayout({
    required this.isNoLocation,
    required this.isLteOnly,
    required this.isAddData,
    required this.isWideArea,
    required this.onWideArea,
    required this.onAddData,
    required this.enabledSave,
    required this.onChangedPassword,
    required this.onTapSave,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CheckTextBox(
          onChanged: null,
          text: '위치정보없음',
          value: isNoLocation,
        ),
        const SizedBox(width: 24),
        CheckTextBox(
          onChanged: null,
          text: 'LTE Only',
          value: isLteOnly,
        ),
        const SizedBox(width: 24),
        CheckTextBox(
          onChanged: onWideArea,
          text: '넓은 지역 (고속도로 등)',
          value: isWideArea,
        ),
        const SizedBox(width: 24),
        CheckTextBox(
          onChanged: (value){
            print('isAddValue>${value}');
            onAddData(value);
          },
          text: '기존자료에 추가',
          checkColor: Colors.red,
          value: isAddData,
        ),
        const Spacer(),
        SizedBox(
          width: 150,
          child: TextField(
            obscureText: true,
            onChanged: onChangedPassword,
            maxLength: 10,
            decoration: InputDecoration(
              counterText: "",
              label: const Text(
                '비밀번호',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              hintText: '자료삭제시 사용',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    4.0), // Adjust the radius to your liking
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
            ),
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
        const SizedBox(width: 32),
        SizedBox(
          width: 150,
          child: ElevatedButton(
            onPressed: enabledSave ? onTapSave : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.only(top: 16, bottom: 18),
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(50), // Adjust the radius as needed
              ),
            ),
            child: const Text(
              '저장하기',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
