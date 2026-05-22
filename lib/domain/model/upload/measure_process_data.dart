import 'package:googlemap/domain/model/enum/location_type.dart';
import 'package:googlemap/domain/model/upload/intf_tt_data.dart';
import 'package:googlemap/domain/model/upload/measure_upload_data.dart';

import 'intf_data.dart';

class MeasureProcessData {
  final LocationType division;
  final bool isNoLocation;
  final bool isLteOnly;
  final bool isWideArea;
  final String name;

  final List<IntfTtData> intfTTList;

  MeasureProcessData({
    required this.division,
    required this.isNoLocation,
    required this.isLteOnly,
    required this.isWideArea,
    required this.name,
    required this.intfTTList,
  });

  MeasureUploadData getUploadData({areaIdx = -1}) {
    // intfTTList가 비어있을 수 있으므로(first 호출 금지) 안전하게 처리
    final DateTime? dt = intfTTList.isNotEmpty ? intfTTList.first.dt : null;
    return MeasureUploadData(
      dt: dt,
      intf5GList: _getIntfList(is5G: true),
      intfLteList: _getIntfList(is5G: false),
      intfTTList: intfTTList,
      area: name,
      division: division.name,
      areaIdx: areaIdx,
      isWideArea: isWideArea,
    );
  }

  List<IntfData> _getIntfList({is5G = true}) {
    final List<IntfData> list = [];
    for (var data in intfTTList) {
      list.addAll(data.getIntfData(is5G: is5G));
    }
    return list;
  }
}
