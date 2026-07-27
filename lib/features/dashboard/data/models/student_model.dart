import 'package:flutter/material.dart';
import '../../domain/entities/student_entity.dart';

class StudentModel extends StudentEntity {
  const StudentModel({
    required super.id,
    required super.name,
    required super.membershipId,
    required super.college,
    required super.avatarUrl,
    required super.completedParts,
    required super.totalParts,
    required super.lastAchievementLabel,
    required super.badgeIcon,
    super.teacherId,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    // الباك ايند (TeachersController@getStudents) صار يحط الاسم الكامل
    // جاهز بحقل full_name (first_name من علاقة user + last_name)، وهاد
    // بالضبط الإصلاح اللي طلع بعد تحديث الباك ايند. قبل هيك كان الاسم
    // يُبنى محلياً من father_name + last_name بس (بدون first_name!) وهيك
    // كان اسم الطالبة ما يبين. منعتمد full_name أولاً، وإذا غاب لأي سبب
    // (استجابة قديمة أو endpoint تاني) منرجع نبنيه يدوياً من first_name
    // (تحت علاقة user المتضمّنة بالاستجابة) + last_name كخطة بديلة.
    final fullNameFromApi = (json['full_name'] as String?)?.trim();

    final userJson = json['user'] as Map<String, dynamic>?;
    final firstName = (userJson?['first_name'] as String?)?.trim() ?? '';
    final lastName = (json['last_name'] as String?)?.trim() ?? '';
    final fallbackName = [firstName, lastName].where((s) => s.isNotEmpty).join(' ');

    final displayName = (fullNameFromApi != null && fullNameFromApi.isNotEmpty)
        ? fullNameFromApi
        : fallbackName;

    return StudentModel(
      id: json['id'].toString(),
      name: displayName.isEmpty ? 'بدون اسم' : displayName,
      membershipId: 'MLT-${json['id']}', // مبني على الـ id، لأنه ما في رقم عضوية فعلي بالباك ايند
      college: (json['college'] as String?)?.trim() ?? '',
      avatarUrl: '', // ⬅️ دايماً فاضية — الباك ايند ما بيرجع صور إطلاقاً
      completedParts: (json['achievement'] as num?)?.toDouble() ?? 0,
      totalParts: (json['goal'] as num?)?.toDouble() ?? 0,
      lastAchievementLabel: 'الهدف: ${json['goal'] ?? 0} جزء',
      badgeIcon: Icons.verified,
      teacherId: (json['teacher_id'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'college': college,
    'completed_parts': completedParts,
    'total_parts': totalParts,
  };
}
