import '../../../../core/bloc/request_status.dart';
import '../../domain/entities/user_role.dart';

class SignUpState {
  const SignUpState({
    this.status = RequestStatus.initial,
    this.errorMessage,
    this.sessionToken,
    this.role,
  });

  final RequestStatus status;
  final String? errorMessage;
  final String? sessionToken;
  final UserRole? role;

  bool get isLoading => status == RequestStatus.loading;

  SignUpState copyWith({
    RequestStatus? status,
    String? errorMessage,
    String? sessionToken,
    UserRole? role,
  }) {
    return SignUpState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      sessionToken: sessionToken ?? this.sessionToken,
      role: role ?? this.role,
    );
  }
}
