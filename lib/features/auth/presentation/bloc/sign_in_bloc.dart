import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/request_status.dart';
import '../../../../core/config/dev_config.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/auth_repository_mock.dart';
import '../../domain/entities/auth_credentials_entity.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import 'sign_in_event.dart';
import 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc({SignInUseCase? signInUseCase})
      : _signInUseCase = signInUseCase ??
            SignInUseCase(
              DevConfig.useMockAuth ? AuthRepositoryMock() : AuthRepositoryImpl(),
            ),
        super(const SignInState()) {
    on<SignInSubmitted>(_onSubmitted);
  }

  final SignInUseCase _signInUseCase;

  // نفس شرط رقم الهاتف المستخدم فـ SignUpBloc: 10 أرقام تبدأ بـ 09.
  static final RegExp _numberRegExp = RegExp(r'^09\d{8}$');

  Future<void> _onSubmitted(SignInSubmitted event, Emitter<SignInState> emit) async {
    final validationError = _validate(event);
    if (validationError != null) {
      emit(state.copyWith(status: RequestStatus.failure, errorMessage: validationError));
      return;
    }

    emit(state.copyWith(status: RequestStatus.loading));
    try {
      final session = await _signInUseCase(
        AuthCredentialsEntity(number: event.number.trim(), password: event.password),
      );
      emit(state.copyWith(
        status: RequestStatus.success,
        sessionToken: session.token,
        role: session.role,
      ));
    } on AuthException catch (e) {
      emit(state.copyWith(status: RequestStatus.failure, errorMessage: e.message));
    } catch (_) {
      emit(state.copyWith(
        status: RequestStatus.failure,
        errorMessage: 'تعذّر الاتصال بالخادم، حاولي مرة أخرى',
      ));
    }
  }

  String? _validate(SignInSubmitted event) {
    if (event.number.trim().isEmpty || event.password.trim().isEmpty) {
      return 'الرجاء تعبئة جميع الحقول';
    }

    if (!_numberRegExp.hasMatch(event.number.trim())) {
      return 'رقم الطالبة يجب أن يتكون من 10 أرقام ويبدأ بـ 09';
    }

    if (event.password.length < 8) {
      return 'كلمة السر يجب ألا تقل عن 8 خانات';
    }

    return null;
  }
}
