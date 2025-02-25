import 'package:flutter/material.dart';
import 'package:googlemap/common/utils/extension.dart';

import '../../../../domain/model/notice/notice_data.dart';
import 'notice_header.dart';
import 'notice_item.dart';
import 'notice_page_number.dart';

class NoticeList extends StatelessWidget {
  final List<NoticeData> noticeList;
  final int currentPage;
  final int totalPage;
  final ValueChanged<NoticeData> onTapNoticeData;
  final ValueChanged<int> onTapPageNumber;

  const NoticeList({
    super.key,
    required this.noticeList,
    required this.currentPage,
    required this.onTapNoticeData,
    required this.totalPage,
    required this.onTapPageNumber,
  });

  @override
  Widget build(BuildContext context) {
    int startPage = (currentPage - 1) * 10 + 1;
    return Column(
      children: [
        const NoticeHeader(),
        SizedBox(
          height: 565,
          child: ListView.separated(
            itemCount: noticeList.length,
            itemBuilder: (context, index) {
              final noticeData = noticeList[index];
              return NoticeItem(
                no: startPage + index,
                title: noticeData.title,
                date: noticeData.createdAt.toDateString(),
                onTap: () {
                  onTapNoticeData(noticeData);
                },
              );
            },
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Colors.grey[200],
            ),
          ),
        ),
        Divider(height: 1, color: Colors.grey[400], endIndent: 0, indent: 0),
        const SizedBox(height: 32),
        NoticePageNumber(
          currentPage: currentPage,
          totalPage: totalPage,
          onPageSelected: onTapPageNumber,
        ),
      ],
    );
  }
}