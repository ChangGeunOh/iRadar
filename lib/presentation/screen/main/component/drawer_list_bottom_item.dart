import 'package:flutter/material.dart';

class DrawerListBottomItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const DrawerListBottomItem({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Row(
            children: [
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: onTap,
              ),
              const SizedBox(width: 16.0),
            ],
          ),
        ),
        const SizedBox(height: 32.0),
      ],
    );
  }
}