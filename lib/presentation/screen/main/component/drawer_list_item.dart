import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrawerListItem extends StatelessWidget {
  final String title;
  final IconData iconData;
  final VoidCallback onTap;
  final String description;

  const DrawerListItem({
    super.key,
    required this.title,
    required this.iconData,
    required this.onTap,
    this.description = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(
          indent: 24,
          color: Colors.black12,
          endIndent: 24,
        ),
        SizedBox(
          height: 64,
          width: double.infinity,
          child: InkWell(
            onTap: () {
              context.pop();
              onTap();
            },
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 24),
                        child: Icon(
                          iconData,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 24,
                  bottom: 0,
                  child: Text(
                    description,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
