import 'package:flutter/material.dart';
import 'package:googlemap/presentation/screen/notice/widget/notice_page_number.dart';

import '../../notice/widget/notice_header.dart';
import '../../notice/widget/notice_item.dart';

class NoticeDialog extends StatelessWidget {
  final ValueChanged<int> onPageSelected;
  final int currentPage;
  final int totalPage;

  const NoticeDialog({
    super.key,
    required this.onPageSelected,
    required this.currentPage,
    required this.totalPage,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: SizedBox(
        width: 800,
        height: 900,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: double.infinity,
                child: Text(
                  '공지사항',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Divider(
                height: 48,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const NoticeHeader(),
              SizedBox(
                height: 565,
                child: ListView.separated(
                  itemCount: 10,
                  itemBuilder: (context, index) => NoticeItem(
                    no: index + 1,
                    title: '공지사항 제목',
                    date: '2021-09-01',
                    onTap: () {},
                  ),
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: Colors.grey[200],
                  ),
                ),
              ),
              Divider(
                  height: 1, color: Colors.grey[400], endIndent: 0, indent: 0),
              const SizedBox(height: 32),
              NoticePageNumber(
                currentPage: currentPage,
                totalPage: totalPage,
                onPageSelected: onPageSelected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}






