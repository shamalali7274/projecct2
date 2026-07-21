import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/theme_toggle_button.dart';

/// الشريط العلوي الخاص بصفحة "المصحف" (لوحة التسميع) — نفس شكل
/// المرجع المرفق: زر الثيم بدائرة ناعمة على جهة، اسم السورة ونطاق
/// الصفحات بالمنتصف، وبيانات الطالبة على الجهة الأخرى.
/// مبني كمكوّن مستقل حتى يُعاد استخدامه لو صار في صفحات تسميع تانية
/// بدل تكرار نفس التخطيط.
class RecitationTopBar extends StatelessWidget {
  const RecitationTopBar({
    super.key,
    required this.surahName,
    required this.fromPage,
    required this.toPage,
    required this.studentName,
    this.studentAvatarUrl = '',
  });

  final String surahName;
  final int fromPage;
  final int toPage;
  final String studentName;
  final String studentAvatarUrl;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      color: scheme.surface,
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            _CircleIconSlot(
              child: const ThemeToggleButton(),
              background: scheme.surfaceContainerLow,
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    surahName,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$surahName • صفحة $fromPage - $toPage',
                    style: textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'الطالبة',
                  style: textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: scheme.secondaryContainer,
                  backgroundImage: studentAvatarUrl.isNotEmpty
                      ? NetworkImage(studentAvatarUrl)
                      : null,
                  child: studentAvatarUrl.isEmpty
                      ? Icon(
                          Icons.person,
                          size: 18,
                          color: scheme.onSecondaryContainer,
                        )
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleIconSlot extends StatelessWidget {
  const _CircleIconSlot({required this.child, required this.background});

  final Widget child;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: child,
    );
  }
}
