import '../../domain/entities/taseeh_days_option.dart';

abstract class SignUpEvent {
  const SignUpEvent();
}

class SignUpSubmitted extends SignUpEvent {
  const SignUpSubmitted({
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
    required this.password,
    required this.confirmPassword,
  });

  final String firstName;
  final String fatherName;
  final String lastName;
  final String motherName;
  final String college;
  final String address;
  final String number;
  final String targetParts;
  final String pageFrom;
  final String pageTo;
  final TaseehDaysOption taseehDays;
  final String password;
  final String confirmPassword;
}
