import 'package:flutter/material.dart';

class RemoveDialog extends StatelessWidget {
  final VoidCallback onRemove;
  final String description;

  const RemoveDialog({
    super.key,
    required this.onRemove,
    this.description = 'Are you sure you want to remove this note?',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 32,
      ),
      title: const Column(
        children: <Widget>[
          Icon(
            Icons.delete_forever,
            color: Colors.red,
            size: 56,
          ),
          SizedBox(height: 16),
          Text(
            '삭제 하시겠습니까?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          description,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize:16,
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
            onRemove();
          },
          child: const Text(
            '삭제',
            style: TextStyle(
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
