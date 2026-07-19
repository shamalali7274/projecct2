import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/request_status.dart';
import '../../../../core/config/dev_config.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/auth_repository_mock.dart';
import '../../domain/entities/sign_up_data_entity.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import 'sign_up_event.dart';
import 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({SignUpUseCase? signUpUseCase})
      : _signUpUseCase = signUpUseCase ??
            SignUpUseCase(
              DevConfig.useMockAuth ? AuthRepositoryMock() : AuthRepositoryImpl(),
            ),
        super(const SignUpState()) {
    on<SignUpSubmitted>(_onSubmitted);
  }

  final SignUpUseCase _signUpUseCase;

  static final RegExp _numberRegExp = RegExp(r'^09\d{8}$');

  // إجمالي عدد صفحات المصحف الشريف.
  static const int _totalQuranPages = 604;
  // عدد الصفحات المعتمد لكل جزء (تقريب موحّد للحساب).
  static const int _pagesPerJuz = 20;
  // الهامش المسموح فوق مضاعفات الـ20 (مثال: 3 أجزاء = 60 إلى 63 صفحة).
  static const int _pageTolerance = 3;

  Future<void> _onSubmitted(SignUpSubmitted event, Emitter<SignUpState> emit) async {
    final validationError = _validate(event);
    if (validationError != null) {
      emit(state.copyWith(status: RequestStatus.failure, errorMessage: validationError));
      return;
    }

    emit(state.copyWith(status: RequestStatus.loading));
    try {
      final session = await _signUpUseCase(
        SignUpDataEntity(
          firstName: event.firstName.trim(),
          fatherName: event.fatherName.trim(),
          lastName: event.lastName.trim(),
          motherName: event.motherName.trim(),
          college: event.college.trim(),
          address: event.address.trim(),
          number: event.number.trim(),
          targetParts: int.parse(event.targetParts.trim()),
          pageFrom: int.parse(event.pageFrom.trim()),
          pageTo: int.parse(event.pageTo.trim()),
          taseehDays: event.taseehDays,
          password: event.password,
        ),
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

  String? _validate(SignUpSubmitted event) {
    if (event.firstName.trim().isEmpty ||
        event.fatherName.trim().isEmpty ||
        event.lastName.trim().isEmpty ||
        event.motherName.trim().isEmpty ||
        event.college.trim().isEmpty ||
        event.address.trim().isEmpty ||
        event.number.trim().isEmpty ||
        event.targetParts.trim().isEmpty ||
        event.pageFrom.trim().isEmpty ||
        event.pageTo.trim().isEmpty ||
        event.password.isEmpty ||
        event.confirmPassword.isEmpty) {
      return 'الرجاء تعبئة جميع الحقول';
    }

    if (!_numberRegExp.hasMatch(event.number.trim())) {
      return 'رقم الهاتف يجب أن يتكون من 10 أرقام ويبدأ بـ 09';
    }

    final target = int.tryParse(event.targetParts.trim());
    if (target == null || target < 1 || target > 30) {
      return 'الرجاء إدخال هدف صحيح بين 1 و 30 جزء';
    }

    final from = int.tryParse(event.pageFrom.trim());
    final to = int.tryParse(event.pageTo.trim());

    if (from == null || from < 1 || from > _totalQuranPages) {
      return 'خطأ في إدخال عدد الصفحات';
    }
    if (to == null || to < 1 || to > _totalQuranPages) {
      return 'خطأ في إدخال عدد الصفحات';
    }
    if (from >= to) {
      return 'خطأ في إدخال عدد الصفحات';
    }

    final pageCount = (to - from) + 1;
    final minAllowed = target * _pagesPerJuz;
    final maxAllowed = minAllowed + _pageTolerance;

    if (pageCount < minAllowed || pageCount > maxAllowed) {
      return 'عدد الصفحات المحددة ($pageCount) لا يتناسب مع عدد الأجزاء ($target)';
    }

    if (event.password.length < 6) {
      return 'كلمة السر يجب ألا تقل عن 6 خانات';
    }

    if (event.password != event.confirmPassword) {
      return 'كلمة السر وتأكيدها غير متطابقتين';
    }

    return null;
  }
}
