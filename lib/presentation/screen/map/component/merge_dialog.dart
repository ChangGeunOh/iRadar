import 'package:flutter/material.dart';
import 'package:googlemap/domain/model/enum/location_type.dart';

import '../../../../common/const/constants.dart';
import '../../../../domain/model/map/area_data.dart';
import '../../../component/dropdown_box.dart';
import '../../../component/edit_text.dart';

class MergeDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onMergeData;
  final Set<AreaData> areaDataSet;

  const MergeDialog({
    super.key,
    required this.onMergeData,
    required this.areaDataSet,
  });

  @override
  State<MergeDialog> createState() => _MergeDialogState();
}

class _MergeDialogState extends State<MergeDialog> {
  late LocationType? _locationType;
  String _name = '';
  late AreaData _mostRecent;

  @override
  void initState() {
    _locationType = widget.areaDataSet.first.division;
    final prefix = widget.areaDataSet.length > 1 ? '[병합] ' : '[수정]';
    _name = '$prefix ${widget.areaDataSet.map((e) => e.name).join(', ')}';
    _mostRecent = widget.areaDataSet.reduce((current, next) {
      return current.measuredAt!.isAfter(next.measuredAt!) ? current : next;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      titlePadding: const EdgeInsets.all(0),
      title: Container(
        color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Center(
            child: Text(
              widget.areaDataSet.length > 1 ? "병합하기" : '수정하기',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
      content: SizedBox(
        height: 200,
        width: 500,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 200,
                  child: DropdownBox(
                    value: _locationType!.name,
                    onChanged: (value) {
                      _locationType = LocationType.values
                          .firstWhere((element) => element.name == value);
                    },
                    hint: '구분선택',
                    label: '구분',
                    items: divisionList,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: EditText(
                    onChanged: (value) {
                      _name = value;
                    },
                    label: '측정장소',
                    value: _name,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("취소"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          onPressed: () {
            if (_name.isEmpty) {
              return;
            }
            widget.onMergeData({
              'name': _name,
              'locationType': _locationType,
              'measuredAt': _mostRecent.measuredAt,
            });
          },
          child: const Text("저장"),
        ),
      ],
    );
  }
}
