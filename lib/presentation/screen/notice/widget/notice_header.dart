import 'package:flutter/material.dart';

class NoticeHeader extends StatelessWidget {
  const NoticeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF4F4F4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Divider(height: 1, color: Colors.grey[400], endIndent: 0, indent: 0),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              children: [
                SizedBox(
                  width: 70,
                  child: Text(
                    'No',
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                    child: Text(
                      '제목',
                      textAlign: TextAlign.center,
                    )),
                SizedBox(
                  width: 100,
                  child: Text(
                    '등록일',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}