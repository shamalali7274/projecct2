import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';

/// عنصر واحد داخل شريط التنقل السفلي (أيقونة + تسمية)
class AppNavItem {
  const AppNavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

/// شريط تنقل سفلي عائم موحّد (Island Navigation Bar).
/// يُبنى مرة واحدة ويُغذّى بقائمة عناصر من الخارج، بدل بناء شريط تنقل
/// منفصل لكل صفحة رئيسية في التطبيق.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<AppNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xl),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLowest.withOpacity(0.8),
              borderRadius: BorderRadius.circular(AppRadius.full),
              boxShadow: [
                BoxShadow(color: scheme.onSurface.withOpacity(0.04), blurRadius: 32, offset: const Offset(0, 8)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(items.length, (index) {
                final isActive = index == currentIndex;
                return _NavButton(item: items[index], isActive: isActive, onTap: () => onTap(index));
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.item, required this.isActive, required this.onTap});

  final AppNavItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? scheme.secondaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(item.icon, color: isActive ? scheme.primary : scheme.outline, size: 24),
            const SizedBox(height: 2),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isActive ? scheme.primary : scheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
