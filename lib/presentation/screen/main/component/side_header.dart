import 'package:flutter/material.dart';
import 'package:googlemap/presentation/screen/main/component/type_segment.dart';

import '../../../../common/const/color.dart';
import 'my_text_field.dart';

class SideHeader extends StatelessWidget {
  final ValueChanged onTapWirelessType;
  final ValueChanged<String> onSearch;
  final VoidCallback onTapRefresh;
  final VoidCallback onTapMenu;

  const SideHeader({
    required this.onSearch,
    required this.onTapWirelessType,
    required this.onTapRefresh,
    required this.onTapMenu,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 165,
      color: primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: onTapMenu,
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const Text(
                  'iRadar',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22.0,
                      fontFamily: 'Poppins',
                      color: Colors.white),
                ),
                const Spacer(),
                IconButton(
                  onPressed: onTapRefresh,
                  icon: const Icon(
                    Icons.refresh_rounded,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              height: 47.0,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.search_rounded,
                      color: Color(0xffc9c9c9),
                      size: 24.0,
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 316,
                      child: MyTextField(
                        onSearch: onSearch,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14.0),
            TypeSegment(
              onChangedValue: (value) => onTapWirelessType(value),
            ),
          ],
        ),
      ),
    );
  }
}
