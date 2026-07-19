import 'package:flutter/material.dart';

/// كيان الطالبة (Domain Entity).
///
/// مستقل تماماً عن أي مصدر بيانات (Mock حالياً أو API لاحقاً).
/// الواجهات تتعامل مع هذا الكيان فقط، وعند الربط مع الباك ايند
/// سيقوم StudentModel (في طبقة data) بتحويل JSON إلى هذا الكيان.
@immutable
class StudentEntity {
  const StudentEntity({
    required this.id,
    required this.name,
    required this.membershipId,
    required this.college,
    required this.avatarUrl,
    required this.completedParts,
    required this.totalParts,
    required this.lastAchievementLabel,
    required this.badgeIcon,
  });

  final String id;
  final String name;
  final String membershipId;
  final String college;
  final String avatarUrl;
  final double completedParts;
  final double totalParts;
  final String lastAchievementLabel;
  final IconData badgeIcon;

  double get progress => totalParts == 0 ? 0 : completedParts / totalParts;
}
