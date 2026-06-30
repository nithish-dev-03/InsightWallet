import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final bgColor = brightness == Brightness.dark
        ? AppColors.darkSurfaceContainerLow
        : AppColors.lightSurfaceContainerLow;

    return Container(
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.8),
        border: Border(
          top: BorderSide(
            color: brightness == Brightness.dark
                ? AppColors.darkOutlineVariant.withValues(alpha: 0.3)
                : AppColors.lightOutlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              _items.length,
              (index) => _NavBarItem(
                icon: _items[index].icon,
                selectedIcon: _items[index].selectedIcon,
                label: _items[index].label,
                isSelected: currentIndex == index,
                onTap: () => onTap(index),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

const List<_NavItem> _items = [
  _NavItem(
    icon: Icons.dashboard_outlined,
    selectedIcon: Icons.dashboard,
    label: 'Dashboard',
  ),
  _NavItem(
    icon: Icons.swap_horiz_outlined,
    selectedIcon: Icons.swap_horiz,
    label: 'Transactions',
  ),
  _NavItem(
    icon: Icons.bar_chart_outlined,
    selectedIcon: Icons.bar_chart,
    label: 'Reports',
  ),
  _NavItem(
    icon: Icons.person_outlined,
    selectedIcon: Icons.person,
    label: 'Profile',
  ),
];

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.darkPrimaryContainer.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: AppRadius.brFull,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected
                  ? AppColors.darkPrimary
                  : AppColors.darkOnSurfaceVariant,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? AppColors.darkPrimary
                    : AppColors.darkOnSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
