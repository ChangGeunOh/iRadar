import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrawerListItem extends StatelessWidget {
  final String title;
  final IconData iconData;
  final VoidCallback onTap;

  const DrawerListItem({
    super.key,
    required this.title,
    required this.iconData,
    required this.onTap,
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
          child: InkWell(
            onTap: (){
              context.pop();
              onTap();
            },
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
        ),
      ],
    );
  }
}