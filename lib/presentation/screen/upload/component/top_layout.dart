import 'package:flutter/material.dart';
import 'package:googlemap/presentation/screen/upload/viewmodel/upload_event.dart';

import '../../../../common/const/constants.dart';
import '../../../component/dropdown_box.dart';
import '../../../component/edit_text.dart';

class TopLayout extends StatelessWidget {
  final VoidCallback onTapFile;
  final VoidCallback onTapSearch;
  final String group;
  final String division;
  final String fileName;
  final String area;
  final bool isDuplicate;
  final ValueChanged<dynamic> onChangedArea;
  final ValueChanged<dynamic> onChangedDivision;

  const TopLayout({
    required this.onTapFile,
    required this.group,
    required this.division,
    required this.area,
    required this.fileName,
    required this.isDuplicate,
    required this.onTapSearch,
    required this.onChangedArea,
    required this.onChangedDivision,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // print('fileName>$fileName');
    print('division>$division');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // SizedBox(
        //   width: 150,
        //   child: EditText(
        //     onChanged: (value) {},
        //     label: '지역',
        //     value: group,
        //     enabled: false,
        //   ),
        // ),
        // const SizedBox(width: 16),
        SizedBox(
          width: 200,
          child: DropdownBox(
            onChanged: onChangedDivision,
            hint: '구분선택',
            label: '구분',
            items: divisionList,
            value: division.isEmpty ? null : division,
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 400,
          child: EditText(
            label: '파일명',
            value: fileName,
            onChanged: (value) {},
            suffixIcon: IconButton(
              onPressed: () {
                // FocusScope.of(context).nextFocus();
                // FocusScope.of(context).nextFocus();
                onTapFile();
              },
              icon: const Icon(
                Icons.attach_file_rounded,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: EditText(
            onChanged: (value) => onChangedArea(value),
            label: '측정장소',
            value: area,
            suffixIcon: IconButton(
              onPressed: onTapSearch,
              icon: const Icon(
                Icons.search_rounded,
              ),
            ),
          ),
        ),
        // const SizedBox(width: 16),
        // SizedBox(
        //   width: 400,
        //   child: EditText(
        //     onChanged: (value) => onChanged(
        //       UploadChangedType.onFile,
        //       value,
        //     ),
        //     label: '파일명',
        //     enabled: false,
        //     value: fileName,
        //   ),
        // ),
        // const SizedBox(width: 16),
        // SizedBox(
        //   width: 150,
        //   child: ElevatedButton(
        //     onPressed: onTapFile,
        //     style: ElevatedButton.styleFrom(
        //       padding: const EdgeInsets.only(top: 16, bottom: 18),
        //       foregroundColor: Colors.white,
        //       backgroundColor: Colors.blue,
        //       shape: RoundedRectangleBorder(
        //         borderRadius:
        //             BorderRadius.circular(50), // Adjust the radius as needed
        //       ),
        //     ),
        //     child: const Text(
        //       '파일선택',
        //       style: TextStyle(
        //         fontSize: 16,
        //         fontWeight: FontWeight.w500,
        //         color: Colors.white,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
