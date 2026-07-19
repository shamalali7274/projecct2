import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/theme_toggle_button.dart';

/// واجهات الطالبة الفعلية لسا ما بُنيت (خارج نطاق الشغل الحالي).
/// هاي صفحة مؤقتة هدفها التأكد إن التوجيه حسب role شغّال صح —
/// التصميم الحقيقي رح ييجي بمرحلة قادمة.
class StudentHomePlaceholderPage extends StatelessWidget {
  const StudentHomePlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        title: const Text('واجهة الطالبة'),
        actions: const [ThemeToggleButton()],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Text(
            'تسجيل الدخول نجح كـ "طالبة" ✅\nواجهات الطالبة رح نبنيها بمرحلة قادمة.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );
  }
}
