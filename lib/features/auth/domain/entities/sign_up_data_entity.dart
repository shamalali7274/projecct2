import 'masar_option.dart';
import 'taseeh_days_option.dart';

/// بيانات إنشاء الحساب الكاملة، منفصلة عن شكل الـ request المُرسل
/// فعلياً للـ API (والذي ممكن يتغير بلا ما تتأثر باقي الطبقات).
class SignUpDataEntity {
  const SignUpDataEntity({
    required this.firstName,
    required this.fatherName,
    required this.lastName,
    required this.motherName,
    required this.college,
    required this.address,
    required this.number,
    required this.targetParts,
    required this.pageFrom,
    required this.pageTo,
    required this.taseehDays,
    required this.masar,
    required this.password,
  });

  final String firstName;
  final String fatherName;
  final String lastName;
  final String motherName;
  final String college;
  final String address;
  final String number;
  final int targetParts;
  final int pageFrom;
  final int pageTo;
  final TaseehDaysOption taseehDays;
  final MasarOption masar;
  final String password;
}
