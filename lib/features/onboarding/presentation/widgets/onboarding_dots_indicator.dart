import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';

/// نقاط التنقل بين شرائح onboarding (Dots Indicator)
class OnboardingDotsIndicator extends StatelessWidget {
  const OnboardingDotsIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
    required this.onDotTap,
  });

  final int count;
  final int currentIndex;
  final ValueChanged<int> onDotTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return GestureDetector(
          onTap: () => onDotTap(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: isActive ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive ? scheme.primary : scheme.outlineVariant,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
          ),
        );
      }),
    );
  }
}
