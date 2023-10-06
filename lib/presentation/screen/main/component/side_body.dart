import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../common/const/color.dart';
import '../../../../domain/model/place_data.dart';
import '../../../../domain/model/wireless_type.dart';

class SideBody extends StatefulWidget {
  final List<PlaceData> measureList;
  final ValueChanged onTapItem;
  final ValueChanged onTapAll;
  final ValueChanged onTapRemove;
  final ValueChanged<PlaceData> onLongPress;
  final ValueChanged onTapWithShift;
  final VoidCallback onLoadMore;

  const SideBody({
    required this.measureList,
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
    return RawKeyboardListener(
      focusNode: focusNode,
      autofocus: true,
      onKey: (event) {
        isShiftPressed = event.isShiftPressed;
      },
      child: ListView.separated(
        controller: controller,
        itemBuilder: (context, index) {
          final measureData = widget.measureList[index];
          return MeasureDataCard(
            measureData: measureData,
            onTapItem: () {
              print('onTapItem>$index, isShiftPressed>$isShiftPressed');
              if (isShiftPressed) {
                widget.onTapWithShift(measureData);
              } else {
                widget.onTapItem(measureData);
              }
            },
            onTapAll: () {
              widget.onTapAll(measureData);
            },
            onTapRemove: () {
              widget.onTapRemove(measureData);
            },
            onLongPress: () {
              widget.onLongPress(measureData);
            },
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(
            thickness: 1,
            color: Color(0xffd9d9d9),
          );
        },
        itemCount: widget.measureList.length,
      ),
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
                            measureData.type == WirelessType.wLte
                                ? 'assets/icons/ic_lte.svg'
                                : 'assets/icons/ic_5g.svg'),
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
                          measureData.division.name,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          measureData.type.name,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          measureData.dateTime.split(' ').first,
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
