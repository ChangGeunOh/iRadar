import 'package:flutter/material.dart';

import '../../../../common/const/color.dart';

class MyTextField extends StatefulWidget {
  final ValueChanged<String> onSearch;

  const MyTextField({
    super.key,
    required this.onSearch,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clearText() {
    widget.onSearch('');
    setState(() {
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: '장소, 주소 검색',
        hintStyle: const TextStyle(
          color: Color(0xff9a9a9a),
          fontSize: 16.0,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: _clearText,
        ),
      ),
      onChanged: (text) {
        widget.onSearch(text);
      },
      style: const TextStyle(
        fontSize: 18.0,
        color: textColor,
      ),
    );
  }
}
