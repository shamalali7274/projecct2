import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';

/// عنصر إجراء واحد داخل الشريط العلوي (أيقونة + حدث الضغط)
class AppTopBarAction {
  const AppTopBarAction({required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;
}

/// شريط علوي موحّد (صورة المستخدم + عنوان + وصف + أيقونات إجراءات).
/// يُبنى مرة واحدة، وتُمرَّر له البيانات والإجراءات من كل صفحة تستخدمه.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    required this.title,
    required this.subtitle,
    required this.avatarUrl,
    this.actions = const [],
    this.trailing,
  });

  final String title;
  final String subtitle;
  final String avatarUrl;
  final List<AppTopBarAction> actions;

  /// عنصر إضافي حر (مثل زر تبديل الثيم) يُعرض بعد أيقونات actions.
  final Widget? trailing;

  @override
  Size get preferredSize => const Size.fromHeight(88);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(bottom: BorderSide(color: scheme.surfaceContainerLow, width: 1)),
      ),
      // نثبّت (clamp) مقياس خط النظام جوا البار بس، حتى لو المستخدم
      // كبّر حجم الخط من إعدادات جهازه (Accessibility) ما ينكسر
      // ارتفاع البار الثابت (preferredSize) على أي جهاز أو أي مقاس.
      // باقي التطبيق برّا هاد البار بيضل يحترم إعداد المستخدم عادي.
      child: MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: MediaQuery.textScalerOf(context).clamp(minScaleFactor: 0.9, maxScaleFactor: 1.1)),
        child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            if (Navigator.canPop(context))
              Padding(
                padding: const EdgeInsets.only(left: AppSpacing.xs),
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(6),
                  constraints: const BoxConstraints(),
                  icon: Icon(Icons.arrow_forward, color: scheme.primary, size: 22),
                ),
              ),
            // Stack(
            //   children: [
            //     CircleAvatar(radius: 24, backgroundImage: NetworkImage(avatarUrl)),
            //     Positioned(
            //       bottom: 0,
            //       left: 0,
            //       child: Container(
            //         width: 12,
            //         height: 12,
            //         decoration: BoxDecoration(
            //           color: scheme.primary,
            //           shape: BoxShape.circle,
            //           border: Border.all(color: scheme.surface, width: 2),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                  child: avatarUrl.isEmpty
                      ? Icon(Icons.person, size: 24, color: scheme.onSurfaceVariant)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: scheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: scheme.surface, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: textTheme.headlineSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            for (final action in actions)
              IconButton(
                onPressed: action.onTap,
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.all(6),
                constraints: const BoxConstraints(),
                icon: Icon(action.icon, color: scheme.primary, size: 22),
              ),
            if (trailing != null) trailing!,
          ],
        ),
        ),
      ),
    );
  }
}
