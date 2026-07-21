// import 'dart:ui';
// import 'package:flutter/material.dart';
// import '../theme/app_dimensions.dart';

// /// عنصر واحد داخل شريط التنقل السفلي (أيقونة + تسمية)
// class AppNavItem {
//   const AppNavItem({required this.icon, required this.label});
//   final IconData icon;
//   final String label;
// }

// /// شريط تنقل سفلي عائم موحّد (Island Navigation Bar).
// /// يُبنى مرة واحدة ويُغذّى بقائمة عناصر من الخارج، بدل بناء شريط تنقل
// /// منفصل لكل صفحة رئيسية في التطبيق.
// class AppBottomNav extends StatelessWidget {
//   const AppBottomNav({
//     super.key,
//     required this.items,
//     required this.currentIndex,
//     required this.onTap,
//   });

//   final List<AppNavItem> items;
//   final int currentIndex;
//   final ValueChanged<int> onTap;

//   @override
//   Widget build(BuildContext context) {
//     final scheme = Theme.of(context).colorScheme;

//     return Padding(
//       padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xl),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(AppRadius.full),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
//             decoration: BoxDecoration(
//               color: scheme.surfaceContainerLowest.withOpacity(0.8),
//               borderRadius: BorderRadius.circular(AppRadius.full),
//               boxShadow: [
//                 BoxShadow(color: scheme.onSurface.withOpacity(0.04), blurRadius: 32, offset: const Offset(0, 8)),
//               ],
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: List.generate(items.length, (index) {
//                 final isActive = index == currentIndex;
//                 return _NavButton(item: items[index], isActive: isActive, onTap: () => onTap(index));
//               }),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _NavButton extends StatelessWidget {
//   const _NavButton({required this.item, required this.isActive, required this.onTap});

//   final AppNavItem item;
//   final bool isActive;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     final scheme = Theme.of(context).colorScheme;

//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(AppRadius.full),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
//         decoration: BoxDecoration(
//           color: isActive ? scheme.secondaryContainer : Colors.transparent,
//           borderRadius: BorderRadius.circular(AppRadius.full),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(item.icon, color: isActive ? scheme.primary : scheme.outline, size: 24),
//             const SizedBox(height: 2),
//             Text(
//               item.label,
//               style: TextStyle(
//                 fontSize: 10,
//                 fontWeight: FontWeight.w500,
//                 color: isActive ? scheme.primary : scheme.outline,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// lib/core/widgets/app_bottom_nav.dart
//
// نفس الـ API الخارجي تماماً (AppNavItem, AppBottomNav) — ما بتحتاج
// تغيّر ولا سطر بـ dashboard_page.dart أو أي صفحة تانية بتستخدمه.
// نفس الألوان (Theme.of(context).colorScheme من AppColors) ونفس الأيقونات
// يلي مررتها من برا.
//
// اللي تغيّر هو الآلية الداخلية فقط، مبنية على تحليل GlassTabView.java
// الرسمي من ريبو تلغرام:
//   - توقيت انتقال التاب المختار: 320ms + Curves.decelerate
//     (كان AnimatedContainer عام بـ 200ms بدون منحنى محدد)
//   - الـ blur: صار مربوط بفحص أداء الجهاز (DevicePerformance) بدل ما
//     يُفرض دايماً — على الأجهزة الضعيفة بيرجع خلفية صلبة خفيفة

import 'dart:ui';
import 'package:academic_concourse_for_girls/core/util/device_performance.dart';
import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';

/// عنصر واحد داخل شريط التنقل السفلي (أيقونة + تسمية) — بدون أي تغيير.
class AppNavItem {
  const AppNavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

/// شريط تنقل سفلي عائم موحّد (Island Navigation Bar).
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
    final useGlass = DevicePerformance.canUseGlassEffect;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: BackdropFilter(
          // على الأجهزة الضعيفة: sigma=0 بدل ما نلغي الـ BackdropFilter
          // بالكامل — هيك اللاي آوت نفسه ثابت، بس بدون تكلفة GPU حقيقية.
          filter: useGlass
              ? ImageFilter.blur(sigmaX: 20, sigmaY: 20)
              : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              // نفس اللون تماماً، بس شفافية أعلى شوي إذا ما في Blur حقيقي
              // (منشان يضل واضح المحتوى تحته حتى بدون تأثير الزجاج).
              color: scheme.surfaceContainerLowest.withOpacity(
                useGlass ? 0.8 : 0.97,
              ),
              borderRadius: BorderRadius.circular(AppRadius.full),
              boxShadow: [
                BoxShadow(
                  color: scheme.onSurface.withOpacity(0.04),
                  blurRadius: 32,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(items.length, (index) {
                final isActive = index == currentIndex;
                return Expanded(
                  child: _NavButton(
                    item: items[index],
                    isActive: isActive,
                    onTap: () => onTap(index),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final AppNavItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: TweenAnimationBuilder<double>(
        // 320ms + decelerate: نفس توقيت GlassTabView.java بالضبط، بدل
        // الـ 200ms العام السابق. بيغيّر حجم الأيقونة ولون الخلفية والنص
        // بانسيابية أوضح بكثير من التبديل السريع القديم.
        tween: Tween(begin: 0, end: isActive ? 1.0 : 0.0),
        duration: const Duration(milliseconds: 320),
        curve: Curves.decelerate,
        builder: (context, t, _) {
          final color = Color.lerp(scheme.outline, scheme.primary, t)!;
          final bgColor = Color.lerp(
            Colors.transparent,
            scheme.secondaryContainer,
            t,
          )!;
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(item.icon, color: color, size: lerpDouble(22, 24, t)),
                const SizedBox(height: 2),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
