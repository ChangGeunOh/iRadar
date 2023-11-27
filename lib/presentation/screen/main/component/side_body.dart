import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../common/const/color.dart';
import '../../../../domain/model/place_data.dart';
import '../../../../domain/model/wireless_type.dart';

class SideBody extends StatefulWidget {
  final Set<PlaceData> selectedPlaceSet;
  final List<PlaceData> placeList;
  final ValueChanged onTapItem;
  final ValueChanged onTapAll;
  final ValueChanged onTapRemove;
  final ValueChanged<PlaceData> onLongPress;
  final ValueChanged onTapWithShift;
  final VoidCallback onLoadMore;

  const SideBody({
    required this.selectedPlaceSet,
    required this.placeList,
    required this.onTapItem,
    required this.onTapAll,
    required this.onTapRemove,
    required this.onLongPress,
    required this.onLoadMore,
    required this.onTapWithShift,
    super.key,
  });

  @override
  State<SideBody> createState() => _SideBodyState();
}

class _SideBodyState extends State<SideBody> {
  final controller = ScrollController();
  final focusNode = FocusNode();
  bool isShiftPressed = false;

  @override
  void initState() {
    controller.addListener(listener);
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    super.dispose();
  }

  void listener() {
    if (controller.offset > controller.position.maxScrollExtent - 300) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.selectedPlaceSet.toString());
    return RawKeyboardListener(
      focusNode: focusNode,
      autofocus: true,
      onKey: (event) {
        print("isShiftPressed>${event.isShiftPressed} :: ${widget.selectedPlaceSet.length}}");
        if (isShiftPressed && !event.isShiftPressed && widget.selectedPlaceSet.length > 1) {
            print("Show Merge Dialog");
        }
        isShiftPressed = event.isShiftPressed;
      },
      child: ListView.separated(
        controller: controller,
        itemBuilder: (context, index) {
          final placeData = widget.placeList[index];
          return MeasureDataCard(
            placeData: placeData,
            onTapItem: () {
              print('onTapItem>$index, isShiftPressed>$isShiftPressed');
              if (isShiftPressed) {
                widget.onTapWithShift(placeData);
              } else {
                widget.onTapItem(placeData);
              }
            },
            onTapAll: () {
              widget.onTapAll(placeData);
            },
            onTapRemove: () {
              widget.onTapRemove(placeData);
            },
            onLongPress: () {
              widget.onLongPress(placeData);
            },
            isSelected: widget.selectedPlaceSet.contains(placeData),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xffd9d9d9),
          );
        },
        itemCount: widget.placeList.length,
      ),
    );
  }
}

class MeasureDataCard extends StatelessWidget {
  final PlaceData placeData;
  final VoidCallback onTapItem;
  final VoidCallback onTapAll;
  final VoidCallback onTapRemove;
  final VoidCallback onLongPress;
  final bool isSelected;

  const MeasureDataCard({
    required this.placeData,
    required this.onTapItem,
    required this.onTapAll,
    required this.onTapRemove,
    required this.onLongPress,
    required this.isSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapItem,
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
                            placeData.type == WirelessType.wLte
                                ? 'assets/icons/ic_lte.svg'
                                : 'assets/icons/ic_5g.svg'),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            placeData.name,
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
                          placeData.group,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          placeData.division.name,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          placeData.dateTime.split(' ').first,
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
