import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:googlemap/common/utils/extension.dart';
import 'package:googlemap/domain/model/map/area_data.dart';

import '../../../../common/const/color.dart';
import '../../../../domain/model/place_data.dart';
import '../../../../domain/model/enum/wireless_type.dart';
import 'area_data_card.dart';

class SideBody extends StatelessWidget {
  final Set<AreaData> selectedPlaceSet;
  final List<AreaData> areaDataList;
  final ValueChanged onTapItem;
  final ValueChanged onTapAll;
  final ValueChanged onTapRemove;
  final ValueChanged<AreaData> onLongPress;
  final ValueChanged<AreaData> onAreaRename;
  final ValueChanged onTapWithShift;
  final WirelessType type;

  const SideBody({
    required this.selectedPlaceSet,
    required this.areaDataList,
    required this.onTapItem,
    required this.onTapAll,
    required this.onTapRemove,
    required this.onLongPress,
    required this.onTapWithShift,
    required this.onAreaRename,
    required this.type,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // print('filteredAreaDataList.length: ${areaDataList.length}');
    return ListView.separated(
      itemBuilder: (context, index) {
        final areaData = areaDataList[index];
        final hasDivision = index > 0
            ? areaDataList[index - 1].division != areaData.division
            : true;
        return AreaDataCard(
          areaData: areaData,
          onTapItem: () {
            onTapItem(areaData);
          },
          onTapAll: () {
            onTapAll(areaData);
          },
          onTapRemove: () {
            onTapRemove(areaData);
          },
          onLongPress: () {
            onLongPress(areaData);
          },
          onAreaRename: () {
            onAreaRename(areaData);
          },
          isSelected: selectedPlaceSet.contains(areaData),
          type: type,
          hasDivision: hasDivision,
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(
          height: 1,
          thickness: 1,
          color: Color(0xffd9d9d9),
        );
      },
      itemCount: areaDataList.length,
    );
  }
}
