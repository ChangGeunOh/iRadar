import 'package:flutter/material.dart';
import 'package:googlemap/common/utils/extension.dart';

import '../../../../domain/model/notice/notice_data.dart';

class NoticeDetail extends StatelessWidget {
  final NoticeData noticeData;
  final VoidCallback onTapClose;

  const NoticeDetail({
    super.key,
    required this.noticeData,
    required this.onTapClose,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: const Color(0xFFF4F4F4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(
                height: 1,
                color: Colors.grey[400],
                endIndent: 0,
                indent: 0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        noticeData.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        noticeData.createdAt.toDateString(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
          color: Colors.grey[300],
          endIndent: 0,
          indent: 0,
        ),
        Container(
          color: const Color(0xFFF4F4F4),
          height: 540,
          child: Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    noticeData.content ?? '',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
        ),
        Divider(
          height: 1,
          color: Colors.grey[400],
          endIndent: 0,
          indent: 0,
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              onPressed: onTapClose,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '목록',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
