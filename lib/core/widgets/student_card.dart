import 'package:flutter/material.dart';
import 'app_card.dart';
import 'app_button.dart';
import 'app_progress_bar.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_pastel_tiles.dart';
import '../../features/dashboard/domain/entities/student_entity.dart';

/// بطاقة الطالبة الموحّدة.
///
/// تُبنى مرة واحدة فقط وتُغذّى ببيانات StudentEntity، بدل تكرار
/// نفس تركيبة (صورة + اسم + تقدّم + زر) لكل طالبة يدوياً.
///
/// تدعم لون "بلاطة" ناعم اختياري (tile) يُستخدم بحلقة الصورة الرمزية
/// وشارة الكلية، حتى كل طالبة تاخد هويتها اللونية الخاصة بالقائمة
/// (بدون tile بترجع لألوان المشروع الافتراضية).
class StudentCard extends StatelessWidget {
  const StudentCard({
    super.key,
    required this.student,
    required this.onStartRecitation,
    this.onTap,
    this.tile,
  });

  final StudentEntity student;

  /// بدء جلسة تسميع مباشرة لهاي الطالبة من نفس البطاقة، بدون المرور
  /// بصفحة سجل الإنجازات — نفس السلوك بالضبط من أي قائمة طالبات.
  final VoidCallback onStartRecitation;

  /// الضغط على أي مكان بالبطاقة (وخصوصاً الاسم) — يفتح صفحة سجل
  /// إنجازات الطالبة.
  final VoidCallback? onTap;

  final PastelTile? tile;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final accent = tile?.foreground(context) ?? scheme.primary;
    final accentBg = tile?.background(context) ?? scheme.secondaryContainer.withOpacity(0.5);

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StudentAvatar(
                imageUrl: student.avatarUrl,
                badgeIcon: student.badgeIcon,
                ringColor: accentBg,
                badgeColor: accent,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            student.name,
                            style: textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(student.lastAchievementLabel, style: textTheme.labelSmall),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: accentBg,
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                          child: Text(
                            student.college,
                            style: textTheme.labelSmall?.copyWith(color: accent, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(student.membershipId, style: textTheme.labelSmall),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppProgressBar(
            progressLabel:
                'التقدم: ${_formatParts(student.completedParts)} / ${_formatParts(student.totalParts)} جزء',
            percentage: student.progress,
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: 'بدء التسميع',
            icon: Icons.mic_none_rounded,
            height: 46,
            onPressed: onStartRecitation,
          ),
        ],
      ),
    );
  }

  String _formatParts(double value) {
    return value == value.roundToDouble() ? value.round().toString() : value.toString();
  }
}

// class _StudentAvatar extends StatelessWidget {
//   const _StudentAvatar({
//     required this.imageUrl,
//     required this.badgeIcon,
//     required this.ringColor,
//     required this.badgeColor,
//   });
//
//   final String imageUrl;
//   final IconData badgeIcon;
//   final Color ringColor;
//   final Color badgeColor;
//
//   @override
//   Widget build(BuildContext context) {
//     final scheme = Theme.of(context).colorScheme;
//     return SizedBox(
//       width: 68,
//       height: 68,
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           Container(
//             width: 68,
//             height: 68,
//             padding: const EdgeInsets.all(3),
//             decoration: BoxDecoration(color: ringColor, shape: BoxShape.circle),
//             child: CircleAvatar(
//               backgroundColor: scheme.surfaceContainerHigh,
//               backgroundImage: NetworkImage(imageUrl),
//             ),
//           ),
//           Positioned(
//             bottom: -2,
//             left: -2,
//             child: Container(
//               width: 22,
//               height: 22,
//               decoration: BoxDecoration(
//                 color: badgeColor,
//                 shape: BoxShape.circle,
//                 border: Border.all(color: scheme.surfaceContainerLowest, width: 2),
//               ),
//               child: Icon(badgeIcon, size: 12, color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
class _StudentAvatar extends StatelessWidget {
  const _StudentAvatar({
    required this.imageUrl,
    required this.badgeIcon,
    required this.ringColor,
    required this.badgeColor,
  });

  final String imageUrl;
  final IconData badgeIcon;
  final Color ringColor;
  final Color badgeColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 68,
      height: 68,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 68,
            height: 68,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(color: ringColor, shape: BoxShape.circle),
            child: CircleAvatar(
              backgroundColor: scheme.surfaceContainerHigh,
              backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
              child: imageUrl.isEmpty
                  ? Icon(Icons.person, size: 32, color: scheme.onSurfaceVariant)
                  : null,
            ),
          ),
          Positioned(
            bottom: -2,
            left: -2,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: badgeColor,
                shape: BoxShape.circle,
                border: Border.all(color: scheme.surfaceContainerLowest, width: 2),
              ),
              child: Icon(badgeIcon, size: 12, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}