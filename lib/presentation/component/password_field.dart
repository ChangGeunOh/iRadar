import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final ValueChanged onChanged;

  const PasswordField({required this.onChanged, super.key});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  final textFieldFocusNode = FocusNode();
  bool _obscured = false;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            '비밀번호',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14.0,
            ),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          obscureText: _obscured,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  4.0), // Adjust the radius to your liking
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscured ? Icons.visibility : Icons.visibility_off,
                color: Colors.black54,
              ),
              onPressed: _toggleObscured,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
          ),
          onChanged: (value) {
            widget.onChanged(value);
          },
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }
}
