import 'package:flutter/material.dart';

class NoticeItem extends StatelessWidget {
  final int no;
  final String title;
  final String date;
  final VoidCallback onTap;

  const NoticeItem({
    super.key,
    required this.no,
    required this.title,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              no.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: HyperLinkText(text: title),
            ),
          ),
          const SizedBox(width: 32),
          SizedBox(
            width: 100,
            child: Text(
              date,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HyperLinkText extends StatefulWidget {
  final String text;

  const HyperLinkText({
    super.key,
    required this.text,
  });

  @override
  State<HyperLinkText> createState() => _HyperLinkTextState();
}

class _HyperLinkTextState extends State<HyperLinkText> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    print('isHovered: $_isHovered');
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) => setState(() => _isHovered = true),
      onExit: (event) => setState(() => _isHovered = false),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.text,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              decoration:
                  _isHovered ? TextDecoration.underline : TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}
