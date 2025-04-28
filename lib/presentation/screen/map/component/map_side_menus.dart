import 'package:flutter/material.dart';
import 'package:googlemap/common/const/color.dart';
import 'package:googlemap/presentation/screen/map/viewmodel/map_event.dart';

import '../viewmodel/map_state.dart';

class MapSideMenus extends StatelessWidget {
  final MapState state;
  final Function(MapEvent) onTap;

  const MapSideMenus({
    super.key,
    required this.onTap,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMenuButton(
          icon: Icons.cell_tower_rounded,
          label: 'ALL',
          isActive: state.isShowBase,
          activeColor: Colors.black,
          onPressed: () => onTap(MapEvent.onShowBase),
        ),
        const SizedBox(height: 8),
        _buildMenuButton(
          icon: Icons.cell_tower_rounded,
          label: 'Label',
          isActive: state.isShowCaption,
          activeColor: Colors.black,
          onPressed: () => onTap(MapEvent.onShowCaption),
        ),
        const SizedBox(height: 8),
        _buildMenuButton(
          icon: Icons.recommend_outlined,
          label: 'Best Point',
          isActive: state.isShowBestPoint,
          activeColor: Colors.red,
          onPressed: () => onTap(MapEvent.onShowBestPoint),
        ),
        const SizedBox(height: 8),
        _buildMenuButton(
          icon: Icons.speed_rounded,
          label: 'T/P',
          isActive: state.isShowSpeed,
          activeColor: Colors.red,
          onPressed: () => onTap(MapEvent.onShowSpeed),
        ),
      ],
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required Color activeColor,
    required VoidCallback onPressed,
  }) {
    final color = isActive ? activeColor : Colors.black38;
    return IconButton(
      onPressed: onPressed,
      icon: Column(
        children: [
          Icon(icon, size: 32, color: color),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
