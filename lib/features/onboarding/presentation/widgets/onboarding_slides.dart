import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_button.dart';

// ---------------------------------------------------------------------
// Layout موحّد لكل الشرائح: نفس الخلفية، نفس أحجام الأيقونات،
// نفس المسافات، نفس أنماط الكتابة — لضمان تناسق تام بين الشرائح.
// ---------------------------------------------------------------------
class _SlideLayout extends StatelessWidget {
  const _SlideLayout({
    required this.iconData,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.title,
    required this.description,
    this.extra,
    this.footer,
    this.bottomPadding = 0,
  });

  final IconData iconData;
  final Color iconBackgroundColor;
  final Color iconColor;
  final String title;
  final String description;
  final Widget? extra;
  final Widget? footer;
  final double bottomPadding;

  static const double _iconContainerSize = 96;
  static const double _iconSize = 44;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      height: double.infinity,
      // خلفية موحدة لكل الشرائح
      color: scheme.surface,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.xl + bottomPadding,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: _iconContainerSize,
            height: _iconContainerSize,
            decoration: BoxDecoration(color: iconBackgroundColor, shape: BoxShape.circle),
            child: Icon(iconData, color: iconColor, size: _iconSize),
          ),
          const SizedBox(height: AppSpacing.xl),
          if (extra != null) ...[extra!, const SizedBox(height: AppSpacing.lg)],
          Text(
            title,
            textAlign: TextAlign.center,
            style: textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            description,
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(height: 1.6),
          ),
          if (footer != null) ...[
            const SizedBox(height: AppSpacing.xl),
            footer!,
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------
// شريحة 1: الترحيب
// ---------------------------------------------------------------------
class WelcomeSlide extends StatelessWidget {
  const WelcomeSlide({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return _SlideLayout(
      iconData: Icons.auto_awesome,
      iconBackgroundColor: scheme.primary.withOpacity(0.1),
      iconColor: scheme.primary,
      title: 'أهلاً بكِ في الملتقى',
      description:
          'مساحتكِ الجامعية لحفظ القرآن، وتنمية الذات، وأخوّة صالحة تكبر معكِ خطوة بخطوة',
    );
  }
}

// ---------------------------------------------------------------------
// شريحة 2: تتبع الحفظ 
// ---------------------------------------------------------------------
class MemorizationTrackingSlide extends StatelessWidget {
  const MemorizationTrackingSlide({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return _SlideLayout(
      iconData: Icons.menu_book,
      iconBackgroundColor: scheme.secondaryContainer,
      iconColor: scheme.onSecondaryContainer,
      title: 'تابعي حفظك أولاً بأول',
      description:
          'خطط حفظ ومراجعة مرنة تتناسب مع جدولك الجامعي، وتقدّم مرئي يحفزكِ على الاستمرار',
    );
  }
}

// ---------------------------------------------------------------------
// شريحة 3: تنمية الذات
// ---------------------------------------------------------------------
class SelfDevelopmentSlide extends StatelessWidget {
  const SelfDevelopmentSlide({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return _SlideLayout(
      iconData: Icons.psychology,
      iconBackgroundColor: scheme.primary.withOpacity(0.1),
      iconColor: scheme.primary,
      title: 'وارتقي بمهاراتكِ أيضاً',
      description:
          'برامج تنموية تصقل شخصيتكِ القيادية وتهيئكِ لمستقبل مهني واعد ومبارك',
      extra: Wrap(
        spacing: AppSpacing.sm,
        alignment: WrapAlignment.center,
        children: const [
          _SkillChip(label: 'ورش مهارية'),
          _SkillChip(label: 'تطوير قيادي'),
        ],
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  const _SkillChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.full),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: scheme.primary, size: 14),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: scheme.primary, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------
// شريحة 4: الأخوة الجامعية + أزرار الدخول
// ---------------------------------------------------------------------
class CommunitySlide extends StatelessWidget {
  const CommunitySlide({super.key, required this.onSignIn, required this.onSignUp});

  final VoidCallback onSignIn;
  final VoidCallback onSignUp;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return _SlideLayout(
      iconData: Icons.diversity_1,
      iconBackgroundColor: scheme.secondaryContainer,
      iconColor: scheme.onSecondaryContainer,
      title: 'لستِ وحدكِ في الرحلة',
      description: 'انضمي لأخوات يشاركنكِ ذات القيم والطموح، في بيئة آمنة تجمعكن على الخير',
      // مساحة إضافية أسفل الشريحة حتى لا تتداخل الأزرار مع نقط التنقل
      bottomPadding: -30,
      footer: Column(
        children: [
          // AppButton بدون icon، والسهم مُضاف يدوياً على اليسار عبر Stack
          // (AppButton الأصلي يضع الأيقونة على اليمين، وهنا بغينا العكس)
          SizedBox(
            width: double.infinity,
            height: 56,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AppButton(label: 'تسجيل الدخول', onPressed: onSignIn),
                Positioned(
                  left: AppSpacing.lg,
                  child: IgnorePointer(
                    child: Icon(Icons.arrow_circle_left, color: scheme.onPrimary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: onSignUp,
            child: Text(
              'ليس لدي حساب — إنشاء حساب',
              style: textTheme.labelLarge?.copyWith(color: scheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
