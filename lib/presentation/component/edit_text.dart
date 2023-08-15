import 'package:flutter/material.dart';

class EditText extends StatefulWidget {
  final ValueChanged onChanged;
  final String label;
  final String? value;
  final bool? enabled;
  final Widget? suffixIcon;

  const EditText({
    required this.onChanged,
    required this.label,
    this.value,
    this.enabled,
    this.suffixIcon,
    super.key,
  });

  @override
  State<EditText> createState() => _EditTextState();
}

class _EditTextState extends State<EditText> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: widget.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.value != null && controller.text.isEmpty) {
      setState(() {
        controller.text = widget.value!;
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            widget.label,
            style: const TextStyle(
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          enabled: widget.enabled ?? true,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  4.0), // Adjust the radius to your liking
            ),
            suffixIcon: widget.suffixIcon,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
          ),
          onChanged: widget.onChanged,
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }
}
