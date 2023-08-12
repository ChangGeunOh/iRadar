import 'package:flutter/material.dart';

class CheckTextBox extends StatelessWidget {
  final bool value;
  final String? text;
  final ValueChanged? onChanged;
  final Color? checkColor;

  const CheckTextBox({
    required this.value,
    this.onChanged,
    this.text,
    this.checkColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          onChanged: onChanged,
          value: value,
          activeColor: checkColor,
        ),
        if (text != null) const SizedBox(width: 4),
        if (text != null)
          Text(
            text!,
            style: const TextStyle(fontSize: 16.0),
          ),
      ],
    );
  }
}