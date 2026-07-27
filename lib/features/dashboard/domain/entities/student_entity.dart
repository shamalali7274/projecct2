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
    this.teacherId,
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

  /// معرّف الأنسة (Teacher.id — مو User.id) المالكة لهاي الطالبة.
  /// موجود بمعظم الاستجابات (getStudents/getStudentByName) لأنو عمود
  /// خام بجدول students، وغائب فقط بـ searchStudentById (استجابتها
  /// مبنية يدوياً بحقول محددة بالباك ايند). نعتمد عليه لتعبئة
  /// teacher_id المطلوب عند إنشاء جلسة تسميع جديدة.
  final int? teacherId;

  double get progress => totalParts == 0 ? 0 : completedParts / totalParts;
}
