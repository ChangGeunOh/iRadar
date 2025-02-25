import 'package:flutter/material.dart';

class NoticePageNumber extends StatelessWidget {
  final int currentPage;
  final int totalPage;
  final ValueChanged<int> onPageSelected;

  const NoticePageNumber({
    super.key,
    required this.currentPage,
    required this.totalPage,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    print('totalPage: $totalPage');
    int startPage = ((currentPage - 1) ~/ 10) * 10 + 1;
    int endPage = (startPage + 9 > totalPage) ? totalPage : startPage + 9;

    List<Widget> pageWidgets = [];

    if (startPage > 1) {
      pageWidgets.add(_buildPageItem(context, '<', startPage - 1));
    }

    for (int i = startPage; i <= endPage; i++) {
      pageWidgets.add(_buildPageItem(context, i.toString(), i,
          isCurrent: i == currentPage));
    }

    if (endPage < totalPage) {
      pageWidgets.add(_buildPageItem(context, '>', endPage + 1));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: pageWidgets,
    );
  }

  Widget _buildPageItem(
      BuildContext context,
      String text,
      int pageNumber, {
        bool isCurrent = false,
      }) {
    Widget widget;
    if (text == '<' || text == '>') {
      widget = Icon(
        text == '<' ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
        color: Colors.black54,
        size: 16,
      );
    } else if (isCurrent) {
      widget = Text(
        text,
        style: TextStyle(
          color: isCurrent ? Colors.black : Colors.black54,
          fontSize: isCurrent ? 16 : 14,
          fontWeight: isCurrent ? FontWeight.w500 : FontWeight.normal,
          decoration: TextDecoration.underline,
        ),
      );
    } else {
      widget = NumberHyperText(text: text);
    }

    return GestureDetector(
      onTap: () {
        onPageSelected(pageNumber);
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: widget,
        ),
      ),
    );
  }
}

class NumberHyperText extends StatefulWidget {
  final String text;

  const NumberHyperText({
    super.key,
    required this.text,
  });

  @override
  State<NumberHyperText> createState() => _NumberHyperTextState();
}

class _NumberHyperTextState extends State<NumberHyperText> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) => setState(() => _isHovered = true),
      onExit: (event) => setState(() => _isHovered = false),
      child: Text(
        widget.text,
        style: TextStyle(
          color: _isHovered ? Colors.black : Colors.black54,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          decoration:
          _isHovered ? TextDecoration.underline : TextDecoration.none,
        ),
      ),
    );
  }
}
