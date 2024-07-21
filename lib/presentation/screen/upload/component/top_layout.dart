import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:googlemap/domain/model/map/area_data.dart';
import 'package:googlemap/presentation/screen/upload/component/measure_edit_text.dart';

import '../../../../common/const/constants.dart';
import '../../../../domain/model/excel_file.dart';
import '../../../../domain/model/upload/measure_upload_data.dart';
import '../../../component/check_text_box.dart';
import '../../../component/dropdown_box.dart';
import '../../../component/edit_text.dart';
import 'area_dialog.dart';

class TopLayout extends StatefulWidget {
  final ValueChanged<MeasureUploadData> onTapUpload;
  final ValueChanged<ExcelFile> onChangedData;
  final ValueChanged<bool> onChangeLoading;

  const TopLayout({
    required this.onTapUpload,
    required this.onChangedData,
    required this.onChangeLoading,
    super.key,
  });

  @override
  State<TopLayout> createState() => _TopLayoutState();
}

class _TopLayoutState extends State<TopLayout> {
  var division = '';
  var fileName = '';
  var area = '';
  var isNoLocation = false;
  var isLteOnly = false;
  var isAddData = false;
  var isWideArea = false;

  ExcelFile? excelFile;
  AreaData? areaData;

  @override
  Widget build(BuildContext context) {
    final isEnableUpload =
        division.isNotEmpty && fileName.isNotEmpty && area.isNotEmpty;
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: 200,
              child: DropdownBox(
                onChanged: (value) => setState(() {
                  division = value as String;
                }),
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
                  onPressed: _onTapFile,
                  icon: const Icon(
                    Icons.attach_file_rounded,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: MeasureEditText(
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      area = value;
                    });
                  }
                },
                label: '측정장소',
                value: area,
                suffixIcon: IconButton(
                  onPressed: () async {
                    final areaData = await showDialog(
                      context: context,
                      builder: (context) => const AreaDialog(),
                    );
                    if (areaData != null) {
                      setState(() {
                        this.areaData = areaData;
                        area = areaData.name ?? '';
                      });
                    }
                  },
                  icon: const Icon(
                    Icons.search_rounded,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
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
              onChanged: (value) {
                isWideArea = value;
              },
              text: '넓은 지역 (고속도로 등)',
              value: isWideArea,
            ),
            const SizedBox(width: 24),
            CheckTextBox(
              onChanged: areaData == null
                  ? null
                  : (value) {
                      isAddData = value;
                    },
              text: '기존자료에 추가',
              checkColor: Colors.red,
              value: isAddData,
            ),
            const Spacer(),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: isEnableUpload
                    ? () {
                        final areaIdx = isAddData ? areaData!.idx : -1;
                        final uploadData = excelFile!.getUploadData(
                          areaIdx: areaIdx,
                          area: area,
                          division: division,
                          isWideArea: isWideArea,
                        );
                        widget.onTapUpload(uploadData);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.only(top: 16, bottom: 18),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        50), // Adjust the radius as needed
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
        ),
      ],
    );
  }

  Future<void> _onTapFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['xls', 'xlsx'],
      type: FileType.custom,
      allowMultiple: false,
    );
    if (result != null) {
      final file = result.files.single;
      setState(() {
        fileName = file.name;
        excelFile = ExcelFile(bytes: file.bytes!);
        isLteOnly = excelFile!.isLteOnly;
        isNoLocation = excelFile!.isNoLocation;
        widget.onChangedData(excelFile!);
      });
    }
  }
}
