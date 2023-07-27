import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../common/const/color.dart';
import '../../../../domain/model/place_data.dart';
import '../../../../domain/model/wireless_type.dart';

class SideBody extends StatelessWidget {
  final List<PlaceData> measureList;
  final ValueChanged onTapItem;
  final ValueChanged onTapAll;
  final ValueChanged onTapRemove;
  final ValueChanged<PlaceData> onLongPress;

  const SideBody({
    required this.measureList,
    required this.onTapItem,
    required this.onTapAll,
    required this.onTapRemove,
    required this.onLongPress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        final measureData = measureList[index];
        return MeasureDataCard(
          measureData: measureData,
          onTapItem: () {
            onTapItem(measureData);
          },
          onTapAll: () {
            onTapAll(measureData);
          },
          onTapRemove: () {
            onTapRemove(measureData);
          },
          onLongPress: () {
            onLongPress(measureData);
          },
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(
          thickness: 1,
          color: Color(0xffd9d9d9),
        );
      },
      itemCount: measureList.length,
    );
  }
}

class MeasureDataCard extends StatelessWidget {
  final PlaceData measureData;
  final VoidCallback onTapItem;
  final VoidCallback onTapAll;
  final VoidCallback onTapRemove;
  final VoidCallback onLongPress;

  const MeasureDataCard({
    required this.measureData,
    required this.onTapItem,
    required this.onTapAll,
    required this.onTapRemove,
    required this.onLongPress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapItem,
      onLongPress: onLongPress,
      child: Container(
        width: 400,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                            measureData.wirelessType == WirelessType.wLte
                                ? 'icons/ic_lte.svg'
                                : 'icons/ic_5g.svg'),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            measureData.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              color: textColor,
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          measureData.location,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          measureData.locationType.name,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          measureData.regDate,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              InkWell(
                onTap: onTapAll,
                child: SvgPicture.asset(
                  'icons/ic_list_all.svg',
                  width: 46,
                  height: 46,
                ),
              ),
              const SizedBox(width: 8.0),
              InkWell(
                onTap: onTapRemove,
                child: SvgPicture.asset(
                  'icons/ic_list_remove.svg',
                  width: 46,
                  height: 46,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
