import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
  final VoidCallback onAreaRename;
  final bool isSelected;
  final WirelessType type;
  final bool hasDivision;

  const AreaDataCard({
    required this.areaData,
    required this.onTapItem,
    required this.onTapAll,
    required this.onTapRemove,
    required this.onLongPress,
    required this.onAreaRename,
    required this.isSelected,
    required this.type,
    this.hasDivision = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (hasDivision)
          Container(
            width: double.infinity,
            color: primaryColor.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 8.0,
              ),
              child: Text(
                areaData.division?.name ?? "",
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        InkWell(
          onTap: () {
            onTapItem();
          },
          child: Slidable(
            key: Key(areaData.name),
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) => onLongPress(),
                  icon: Icons.delete_forever_outlined,
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  label: '자료삭제',
                ),
                SlidableAction(
                  onPressed: (_) => onAreaRename(),
                  icon: Icons.file_copy_outlined,
                  foregroundColor: Colors.white,
                  backgroundColor: primaryColor,
                  label: '이름변경',
                ),
              ],
            ),
            child: Container(
              width: 400,
              color: isSelected ? const Color(0xffe6f7ff) : Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(type == WirelessType.wLte
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
                                areaData.division!.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                areaData.measuredAt?.toDateString() ??
                                    areaData.createdAt!.toDateString(),
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
                    // const SizedBox(width: 20),
                    // const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    // InkWell(
                    //   onTap: onTapAll,
                    //   child: Image.asset(
                    //     'assets/icons/ic_area_rename.png',
                    //     width: 32,
                    //     height: 32,
                    //   ),
                    // ),
                    const SizedBox(width: 8.0),
                    // const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    // InkWell(
                    //   onTap: onTapRemove,
                    //   child: SvgPicture.asset(
                    //     'assets/icons/ic_list_remove.svg',
                    //     width: 46,
                    //     height: 46,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
