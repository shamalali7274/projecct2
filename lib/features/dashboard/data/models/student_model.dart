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
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    final fatherName = (json['father_name'] as String?)?.trim() ?? '';
    final lastName = (json['last_name'] as String?)?.trim() ?? '';
    final displayName = [fatherName, lastName].where((s) => s.isNotEmpty).join(' ');

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