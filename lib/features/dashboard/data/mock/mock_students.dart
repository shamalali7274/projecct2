import 'package:flutter/material.dart';
import '../../domain/entities/student_entity.dart';

/// مصدر بيانات وهمي واحد للطالبات، تستخدمه أي صفحة تحتاج القائمة
/// (اللوحة الرئيسية وصفحة "كل الطالبات") بدل تكرار نفس البيانات
/// بأكثر من مكان.
///
/// TODO: يُستبدل لاحقاً بـ StudentRepository يجلب البيانات فعلياً
/// عبر ApiClient (Dio) بدل هاي القائمة الثابتة.
class MockStudents {
  MockStudents._();

  static const List<StudentEntity> all = [
    StudentEntity(
      id: '1',
      name: 'سارة خالد العمري',
      membershipId: 'MLT-2026-7842',
      college: 'كلية الطب',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAEx-OAwE6PksCNX9Nt9heDL9tUBcr4gVO2crtsO8F4VDRrrFFZ8cxsk4dxM--CeJ9SnliGRTK6WTjW3VFfWSmyWxDdgfC7OWP3SE1bWGTbzUcEb8DeaisK9k6KkKX2Xu_c0P_gbM6PV_OHX6bT-jc9hOPylbbhNSt2edbPDcZEEGa1UefEkLo_QOu6Ry4EKMy7uqyidZ-LuQafSdeZVjhWyZqjhvu1zPYuQbG7Df8_rO_RsZdeFGGsPRYyngMu13PEdtArPRPNatQ',
      completedParts: 18.5,
      totalParts: 30,
      lastAchievementLabel: 'آخر إنجاز: أمس',
      badgeIcon: Icons.star,
    ),
    StudentEntity(
      id: '2',
      name: 'لين عبدالرحمن',
      membershipId: 'MLT-2026-1102',
      college: 'علوم الحاسب',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBuxrM1k-xqWd6O1f1YMpYkWz5qSgpjhH5eAB_TKOANswntJeVQ2iFTxLlnKsqhhJI8yvGJdGF-xuCOtiHg2WkzP3SVRcTtmTrIw-BBNf1pltCKHID4NXGhdKIS8HDWnCVOAtTTm2kSXSomR1S1dy_P_NK6v19YLqiW5iyNmaSDCnStFyQ6RLl_QN8wCJh-aJMx2anttnsrLA8W9LbA153UZgs7zr4Jv_ugnpoRfkG4qhI90M9fK6xPk72q5o4Rq5DN9CX9SiXGgHI',
      completedParts: 5,
      totalParts: 30,
      lastAchievementLabel: 'آخر إنجاز: منذ ساعتين',
      badgeIcon: Icons.auto_stories,
    ),
    StudentEntity(
      id: '3',
      name: 'نورة العبدالله',
      membershipId: 'MLT-2026-4491',
      college: 'الهندسة',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuABHsq6chqezyxirEI2OXPl9wqibNsxkJ2SqI6SK-u6rYvGBud75rv0J1HqVJfm2nVibZqep4qReQiDILQdktMkc-vC85bxtmHYynCNztskwIhEQ1LvXMKus0dlLWDeN7ENeeqqnNdpXJ8KQhtcwvbla4pgkA7yUAnXSIJhcxqbLLe-Cq1YyFWU99pKaRe61JEXkvQwBg83U1WMo_ZO8LXH0lnTuvIW2RlQ8mTVwB-azwDZUJeG5C-RzAqaDJ1Dfjv3LvMSb5RktSs',
      completedParts: 29,
      totalParts: 30,
      lastAchievementLabel: 'آخر إنجاز: ٣ أيام',
      badgeIcon: Icons.verified,
    ),
  ];
}
