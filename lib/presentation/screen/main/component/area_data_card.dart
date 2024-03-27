import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../common/utils/extension.dart';
import '../../../../common/const/color.dart';
import '../../../../domain/model/map/area_data.dart';
import '../../../../domain/model/enum/wireless_type.dart';

class AreaDataCard extends StatelessWidget {
  final AreaData areaData;
  final VoidCallback onTapItem;
  final VoidCallback onTapAll;
  final VoidCallback onTapRemove;
  final VoidCallback onLongPress;
  final bool isSelected;
  final WirelessType type;

  const AreaDataCard({
    required this.areaData,
    required this.onTapItem,
    required this.onTapAll,
    required this.onTapRemove,
    required this.onLongPress,
    required this.isSelected,
    required this.type,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        print('onTapItem');
        onTapItem();
      },
      onLongPress: onLongPress,
      child: Container(
        width: 400,
        color: isSelected ? const Color(0xffe6f7ff) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
                            type == WirelessType.wLte
                                ? 'assets/icons/ic_lte.svg'
                                : 'assets/icons/ic_5g.svg'),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            areaData.name,
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
                        const SizedBox(width: 12),
                        Text(
                          areaData.division.name,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          areaData.date.toDateString(),
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
                  'assets/icons/ic_list_all.svg',
                  width: 46,
                  height: 46,
                ),
              ),
              const SizedBox(width: 8.0),
              InkWell(
                onTap: onTapRemove,
                child: SvgPicture.asset(
                  'assets/icons/ic_list_remove.svg',
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