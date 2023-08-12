import 'package:flutter/material.dart';

class DropdownBox extends StatelessWidget {
  final String label;
  final String? hint;
  final List<String> items;
  final ValueChanged onChanged;

  const DropdownBox({
    required this.label,
    this.hint,
    required this.items,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField(
          hint: hint == null ? null : Text(
            hint!,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
          items: items
              .map(
                (e) => DropdownMenuItem<String>(
                  value: e,
                  child: Text(
                    e,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  4.0), // Adjust the radius to your liking
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
          ),
        ),
      ],
    );
  }
}
