import 'package:flutter_bloc/flutter_bloc.dart';

/// يتحكم في مؤشر الشريحة الحالية داخل onboarding (PageView).
///
/// نفس فلسفة ThemeCubit: حالة بسيطة (int) بدون داتا خارجية،
/// لأن onboarding لا يحتاج ربط بالباك ايند.
class OnboardingCubit extends Cubit<int> {
  OnboardingCubit() : super(0);

  static const int totalSlides = 4;

  void goTo(int index) {
    if (index < 0 || index >= totalSlides) return;
    emit(index);
  }

  void next() => goTo(state + 1);

  void previous() => goTo(state - 1);

  bool get isLast => state == totalSlides - 1;
}
