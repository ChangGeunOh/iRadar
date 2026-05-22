import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googlemap/data/repository/repository.dart';
import 'package:googlemap/domain/model/enum/location_type.dart';
import 'package:googlemap/domain/model/map/area_data.dart';
import 'package:googlemap/domain/model/upload/measure_process_data.dart';
import 'package:googlemap/presentation/screen/upload/component/measure_edit_text.dart';
import 'package:googlemap/presentation/screen/upload/component/request_storage_dialog.dart';

import '../../../../common/const/constants.dart';
import '../../../../domain/model/excel_file.dart';
import '../../../../domain/model/upload/intf_tt_data.dart';
import '../../../../domain/model/upload/measure_upload_data.dart';
import '../../../../domain/model/upload/request_storage_data.dart';
import '../../../component/check_text_box.dart';
import '../../../component/dropdown_box.dart';
// import 'area_dialog.dart';

class TopLayout extends StatefulWidget {
  final ValueChanged<MeasureUploadData> onTapUpload;
  final ValueChanged<bool> onChangeLoading;
  final ValueChanged<MeasureProcessData> onProcessData;

  const TopLayout({
    required this.onTapUpload,
    required this.onChangeLoading,
    required this.onProcessData,
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

  List<IntfTtData> intfTtDataList = [];

  // ExcelFile? excelFile;
  AreaData? areaData;

  late final Repository _repository;

  @override
  void initState() {
    _repository = context.read<Repository>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isEnableUpload = division.isNotEmpty &&
        fileName.isNotEmpty &&
        area.isNotEmpty &&
        intfTtDataList.isNotEmpty;

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '측정 DB 선택',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    height: 48,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(
                        color: Colors.black54,
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            fileName.isEmpty ? '파일을 선택해 주세요.' : fileName,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        SizedBox(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: _onTapFile,
                                icon: const Icon(
                                  Icons.attach_file_rounded,
                                ),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: _onTapRequestStorage,
                                icon: const Icon(
                                  Icons.dns_outlined,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: MeasureEditText(
                value: fileName.replaceAll(RegExp(r'\.(xls|xlsx)$'), ''),
                onChanged: (value) {
                  area = value;
                  setState(() {});
                },
                label: 'i-Radar Pro 파일명',
                onChangedArea: (value) {
                  areaData = value;
                  division = areaData?.division?.name ?? '';
                  if (areaData?.name.isNotEmpty == true) {
                    area = areaData!.name;
                  }
                  setState(() {});
                },
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
            // const SizedBox(width: 24),
            // CheckTextBox(
            //   onChanged: (value) {
            //     isWideArea = value;
            //     setState(() {});
            //   },
            //   text: '넓은 지역 (고속도로 등)',
            //   value: isWideArea,
            // ),
            const SizedBox(width: 24),
            CheckTextBox(
              onChanged: areaData == null
                  ? null
                  : (value) {
                      isAddData = value;
                      setState(() {});
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
                        final areaIdx = (isAddData && areaData != null)
                            ? areaData!.idx
                            : -1;
                        final measureProcessData = MeasureProcessData(
                          division: LocationType.getByName(division),
                          isNoLocation: isNoLocation,
                          isLteOnly: isLteOnly,
                          isWideArea: isWideArea,
                          name: area,
                          intfTTList: intfTtDataList,
                        );
                        final uploadData =
                            measureProcessData.getUploadData(areaIdx: areaIdx);
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
      widget.onChangeLoading(true);
      print('Selected file: ${result.files.single.name} :: isLoading: true');
      try {
        final file = result.files.single;
        fileName = file.name;
        await Future.delayed(const Duration(milliseconds: 500)); // Simulate loading delay
        final excelFile = await ExcelFile.fromBytes(file.bytes!);
        isLteOnly = excelFile.isLteOnly;
        isNoLocation = excelFile.isNoLocation;
        intfTtDataList = excelFile.intfTTList;

        area = area.isEmpty
            ? fileName.replaceAll(RegExp(r'\.(xls|xlsx)$'), '')
            : area;
        // excelFile.getIntfTtDataList();
        // widget.onChangedData(excelFile);

        MeasureProcessData measureProcessData = MeasureProcessData(
          division: LocationType.getByName(division),
          isNoLocation: isNoLocation,
          isLteOnly: isLteOnly,
          isWideArea: false,
          name: area,
          intfTTList: excelFile.intfTTList,
        );
        widget.onChangeLoading(false);
        widget.onProcessData(measureProcessData);
      } catch (e, stack) {
        debugPrint('Excel load error: $e');
        debugPrintStack(stackTrace: stack);
      } finally {
        widget.onChangeLoading(false);
        print('Finished processing file: ${result.files.single.name} :: isLoading: false');
      }
      setState(() {});
    }
  }

  Future<void> _onTapRequestStorage() async {
    RequestStorageData? result = await showDialog(
      context: context,
      builder: (context) => const RequestStorageDialog(),
    );

    if (result == null) return;

    widget.onChangeLoading(true);
    try {
      fileName = result.name;
      area = result.name;
      division = result.division.name;
      isNoLocation = !result.hasLocation;
      isLteOnly = result.isLteOnly;
      setState(() {});

      // widget.onChangedData(ExcelFile.fromBytes(result!.bytes));
      final responseData = await _repository.getRequestStorageMeasureData(30);
      if (responseData.meta.code == 200) {
        intfTtDataList = responseData.data;
        final measureProcessData = MeasureProcessData(
          division: result.division,
          isNoLocation: isNoLocation,
          isLteOnly: isLteOnly,
          isWideArea: isWideArea,
          name: area,
          intfTTList: responseData.data,
        );
        widget.onProcessData(measureProcessData);
        setState(() {});
      }
    } finally {
      widget.onChangeLoading(false);
    }
  }
}
