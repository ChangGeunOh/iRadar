import 'package:flutter/material.dart';
import 'package:googlemap/common/const/color.dart';
import 'package:googlemap/presentation/screen/notice/widget/notice_page_number.dart';

import '../../notice/widget/notice_header.dart';
import '../../notice/widget/notice_item.dart';

class RenameDialog extends StatefulWidget {
  final String oldAreaName;
  final Function(String) onRename;

  const RenameDialog({
    super.key,
    required this.oldAreaName,
    required this.onRename,
  });

  @override
  State<RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<RenameDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.oldAreaName);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 48,
      ),
      title: const Column(
        children: <Widget>[
          Icon(
            Icons.file_copy_outlined,
            color: primaryColor,
            size: 56,
          ),
          SizedBox(height: 16),
          Text(
            '측정 이름을 변경하시겠습니까?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 450,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            controller: _controller,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize:18,
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            '취소',
            style: TextStyle(
              color: Colors.black87,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            widget.onRename(_controller.text);
          },
          child: const Text(
            '변경',
            style: TextStyle(
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}






