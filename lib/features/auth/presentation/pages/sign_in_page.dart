// import 'package:academic_concourse_for_girls/core/navigation/page_transitions.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../core/bloc/request_status.dart';
// import '../../../../core/theme/app_dimensions.dart';
// import '../../../../core/widgets/app_button.dart';
// import '../../../../core/widgets/app_text_field.dart';
// import '../../../../core/navigation/auth_gate.dart';
// import '../bloc/sign_in_bloc.dart';
// import '../bloc/sign_in_event.dart';
// import '../bloc/sign_in_state.dart';
// import '../cubit/auth_cubit.dart';
// import 'sign_up_page.dart';
// import 'package:flutter/services.dart';

// class SignInPage extends StatelessWidget {
//   const SignInPage({super.key, this.onSignUpTap});

//   final VoidCallback? onSignUpTap;

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => SignInBloc(),
//       child: _SignInView(onSignUpTap: onSignUpTap),
//     );
//   }
// }

// class _SignInView extends StatefulWidget {
//   const _SignInView({this.onSignUpTap});
//   final VoidCallback? onSignUpTap;

//   @override
//   State<_SignInView> createState() => _SignInViewState();
// }

// class _SignInViewState extends State<_SignInView> {
//   final _numberController = TextEditingController();
//   final _passwordController = TextEditingController();

//   @override
//   void dispose() {
//     _numberController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   void _submit(BuildContext context) {
//     context.read<SignInBloc>().add(
//       SignInSubmitted(
//         number: _numberController.text,
//         password: _passwordController.text,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final scheme = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;

//     return Scaffold(
//       backgroundColor: scheme.surface,

//       resizeToAvoidBottomInset: true,
//       body: SafeArea(
//         child: BlocListener<SignInBloc, SignInState>(
//           listener: (context, state) {
//             if (state.status == RequestStatus.failure &&
//                 state.errorMessage != null) {
//               ScaffoldMessenger.of(context)
//                 ..hideCurrentSnackBar()
//                 ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
//             }
//             if (state.status == RequestStatus.success && state.role != null) {
//               context.read<AuthCubit>().markAuthenticated(state.role!);
//               Navigator.of(context).pushAndRemoveUntil(
//                 MaterialPageRoute(builder: (_) => const AuthGate()),
//                 (route) => false,
//               );
//             }
//           },
//           child: Column(
//             children: [
//               Align(
//                 alignment: Alignment.topRight,
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(
//                     0,
//                     AppSpacing.md,
//                     AppSpacing.xl,
//                     0,
//                   ),
//                   child: IconButton(
//                     onPressed: () => Navigator.of(context).maybePop(),
//                     icon: Icon(
//                       Icons.arrow_back_ios,
//                       color: scheme.onSurfaceVariant,
//                     ),
//                     style: IconButton.styleFrom(
//                       backgroundColor: scheme.surfaceContainerLow,
//                       shape: const CircleBorder(),
//                     ),
//                   ),
//                 ),
//               ),

//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: AppSpacing.xl,
//                   ),
//                   child: Column(
//                     children: [
//                       const SizedBox(height: AppSpacing.md),
//                       Container(
//                         width: 64,
//                         height: 64,
//                         decoration: BoxDecoration(
//                           color: scheme.surfaceContainerLowest,
//                           shape: BoxShape.circle,
//                           boxShadow: [
//                             BoxShadow(
//                               color: scheme.primary.withOpacity(0.1),
//                               blurRadius: 20,
//                               offset: const Offset(0, 8),
//                             ),
//                           ],
//                         ),
//                         child: Icon(
//                           Icons.auto_awesome,
//                           color: scheme.primary,
//                           size: 30,
//                         ),
//                       ),
//                       const SizedBox(height: AppSpacing.md),
//                       Text(
//                         'تسجيل الدخول',
//                         style: textTheme.headlineSmall?.copyWith(
//                           color: scheme.primary,
//                         ),
//                       ),
//                       const SizedBox(height: AppSpacing.sm),
//                       Text(
//                         'أهلاً بعودتكِ، سجّلي الدخول لمتابعة رحلتك',
//                         textAlign: TextAlign.center,
//                         style: textTheme.bodyMedium,
//                       ),
//                       const SizedBox(height: AppSpacing.xl),
//                       AppTextField(
//                         label: 'رقم الطالبة',
//                         hintText: '09xxxxxxxx',
//                         icon: Icons.call_outlined,
//                         controller: _numberController,
//                         keyboardType: TextInputType.number,
//                         textDirection: TextDirection.ltr,
//                         maxLength: 10,
//                         inputFormatters: [
//                           FilteringTextInputFormatter.digitsOnly,
//                         ],
//                       ),
//                       const SizedBox(height: AppSpacing.md),
//                       AppTextField(
//                         label: 'كلمة السر',
//                         hintText: '••••••••',
//                         icon: Icons.lock_outline,
//                         controller: _passwordController,
//                         isPassword: true,
//                       ),
//                       const SizedBox(height: AppSpacing.xl),
//                       BlocBuilder<SignInBloc, SignInState>(
//                         builder: (context, state) {
//                           return AppButton(
//                             label: 'تسجيل الدخول',
//                             isLoading: state.isLoading,
//                             onPressed: () => _submit(context),
//                           );
//                         },
//                       ),
//                       const SizedBox(height: AppSpacing.lg),
//                       GestureDetector(
//                         onTap:
//                             widget.onSignUpTap ??
//                             () {
//                               Navigator.of(context).pushReplacement(
//                                 TelegramPageRoute(page: const SignUpPage()),
//                               );
//                             },
//                         child: RichText(
//                           text: TextSpan(
//                             style: textTheme.bodySmall,
//                             children: [
//                               const TextSpan(text: 'ليس لديكِ حساب؟ '),
//                               TextSpan(
//                                 text: 'إنشاء حساب',
//                                 style: TextStyle(
//                                   color: scheme.primary,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: AppSpacing.xl),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:academic_concourse_for_girls/core/navigation/page_transitions.dart';
import 'package:academic_concourse_for_girls/core/util/tele_warning_signs.dart';
import 'package:academic_concourse_for_girls/core/util/telegram_bulletin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/request_status.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/navigation/auth_gate.dart';
import '../bloc/sign_in_bloc.dart';
import '../bloc/sign_in_event.dart';
import '../bloc/sign_in_state.dart';
import '../cubit/auth_cubit.dart';
import 'sign_up_page.dart';
import 'package:flutter/services.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key, this.onSignUpTap});

  final VoidCallback? onSignUpTap;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignInBloc(),
      child: _SignInView(onSignUpTap: onSignUpTap),
    );
  }
}

class _SignInView extends StatefulWidget {
  const _SignInView({this.onSignUpTap});
  final VoidCallback? onSignUpTap;

  @override
  State<_SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<_SignInView> {
  final _numberController = TextEditingController();
  final _passwordController = TextEditingController();

  // مفتاحين منشان نقدر ننادي shake() على كل حقل من برا (من الـ BlocListener)
  final _numberFieldKey = GlobalKey<ShakeableFieldState>();
  final _passwordFieldKey = GlobalKey<ShakeableFieldState>();

  @override
  void dispose() {
    _numberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    context.read<SignInBloc>().add(
      SignInSubmitted(
        number: _numberController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: scheme.surface,

      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: BlocListener<SignInBloc, SignInState>(
          listener: (context, state) {
            if (state.status == RequestStatus.failure &&
                state.errorMessage != null) {
              // بدل ScaffoldMessenger/SnackBar بالكامل — نفس شكل تلغرام تماماً
              TelegramBulletin.show(
                context,
                message: state.errorMessage!,
                icon: Icons.error_outline,
                duration: TelegramBulletin.durationShort,
              );

              // نفس لحظة ظهور رسالة الخطأ، نهزّ الحقلين — تماماً زي
              // shakeWrongCode() بصفحة تسجيل الدخول تبع تلغرام.
              _numberFieldKey.currentState?.shake();
              _passwordFieldKey.currentState?.shake();
            }
            if (state.status == RequestStatus.success && state.role != null) {
              context.read<AuthCubit>().markAuthenticated(state.role!);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const AuthGate()),
                (route) => false,
              );
            }
          },
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    0,
                    AppSpacing.md,
                    AppSpacing.xl,
                    0,
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: scheme.onSurfaceVariant,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: scheme.surfaceContainerLow,
                      shape: const CircleBorder(),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: AppSpacing.md),
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerLowest,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: scheme.primary.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.auto_awesome,
                          color: scheme.primary,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'تسجيل الدخول',
                        style: textTheme.headlineSmall?.copyWith(
                          color: scheme.primary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'أهلاً بعودتكِ، سجّلي الدخول لمتابعة رحلتك',
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      // لفينا الحقل بـ ShakeableField بدون ما نغيّر AppTextField نفسه
                      ShakeableField(
                        key: _numberFieldKey,
                        child: AppTextField(
                          label: 'رقم الطالبة',
                          hintText: '09xxxxxxxx',
                          icon: Icons.call_outlined,
                          controller: _numberController,
                          keyboardType: TextInputType.number,
                          textDirection: TextDirection.ltr,
                          maxLength: 10,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ShakeableField(
                        key: _passwordFieldKey,
                        child: AppTextField(
                          label: 'كلمة السر',
                          hintText: '••••••••',
                          icon: Icons.lock_outline,
                          controller: _passwordController,
                          isPassword: true,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      BlocBuilder<SignInBloc, SignInState>(
                        builder: (context, state) {
                          return AppButton(
                            label: 'تسجيل الدخول',
                            isLoading: state.isLoading,
                            onPressed: () => _submit(context),
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      GestureDetector(
                        onTap:
                            widget.onSignUpTap ??
                            () {
                              Navigator.of(context).pushReplacement(
                                TelegramPageRoute(page: const SignUpPage()),
                              );
                            },
                        child: RichText(
                          text: TextSpan(
                            style: textTheme.bodySmall,
                            children: [
                              const TextSpan(text: 'ليس لديكِ حساب؟ '),
                              TextSpan(
                                text: 'إنشاء حساب',
                                style: TextStyle(
                                  color: scheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
