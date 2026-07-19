import 'package:flutter/material.dart';
import 'app_button.dart';
import '../theme/app_dimensions.dart';

/// حالة خطأ موحّدة (لا اتصال، فشل تحميل...) تُستخدم في أي صفحة
/// بدل تكرار نفس التركيبة (أيقونة + رسالة + زر إعادة محاولة).
/// مربوطة بالكامل بألوان وخط التطبيق (Theme) بدل قيم ثابتة.
class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
    this.icon,
  });

  final String message;
  final VoidCallback onRetry;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.wifi_off_rounded,
              size: 64,
              color: scheme.outline,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'حاول مجدداً',
              onPressed: onRetry,
              fullWidth: false,
              height: 48,
            ),
          ],
        ),
      ),
    );
  }
}
