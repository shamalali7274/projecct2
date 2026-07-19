import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/request_status.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/navigation/auth_gate.dart';
import '../../domain/entities/taseeh_days_option.dart';
import '../bloc/sign_up_bloc.dart';
import '../bloc/sign_up_event.dart';
import '../bloc/sign_up_state.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/taseeh_days_selector.dart';
import 'sign_in_page.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignUpBloc(),
      child: const _SignUpView(),
    );
  }
}

class _SignUpView extends StatefulWidget {
  const _SignUpView();

  @override
  State<_SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<_SignUpView> {
  final _firstNameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _collegeController = TextEditingController();
  final _addressController = TextEditingController();
  final _numberController = TextEditingController();
  final _targetPartsController = TextEditingController();
  final _pageFromController = TextEditingController();
  final _pageToController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  TaseehDaysOption _taseehDays = TaseehDaysOption.sundayTuesdayThursday;

  @override
  void dispose() {
    _firstNameController.dispose();
    _fatherNameController.dispose();
    _lastNameController.dispose();
    _motherNameController.dispose();
    _collegeController.dispose();
    _addressController.dispose();
    _numberController.dispose();
    _targetPartsController.dispose();
    _pageFromController.dispose();
    _pageToController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    context.read<SignUpBloc>().add(
          SignUpSubmitted(
            firstName: _firstNameController.text,
            fatherName: _fatherNameController.text,
            lastName: _lastNameController.text,
            motherName: _motherNameController.text,
            college: _collegeController.text,
            address: _addressController.text,
            number: _numberController.text,
            targetParts: _targetPartsController.text,
            pageFrom: _pageFromController.text,
            pageTo: _pageToController.text,
            taseehDays: _taseehDays,
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
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
        child: BlocListener<SignUpBloc, SignUpState>(
          listener: (context, state) {
            if (state.status == RequestStatus.failure && state.errorMessage != null) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
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
                  padding: const EdgeInsets.fromLTRB(0, AppSpacing.md, AppSpacing.xl, 0),
                  child: IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: Icon(Icons.arrow_forward, color: scheme.onSurfaceVariant),
                    style: IconButton.styleFrom(
                      backgroundColor: scheme.surfaceContainerLow,
                      shape: const CircleBorder(),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'إنشاء حساب',
                        textAlign: TextAlign.center,
                        style: textTheme.headlineSmall?.copyWith(color: scheme.primary),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'خطوة واحدة تفصلكِ عن بدء رحلتكِ معنا',
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      _SectionLabel('البيانات الشخصية'),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: 'الاسم',
                        hintText: 'اسمك',
                        icon: Icons.person_outline,
                        controller: _firstNameController,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: 'اسم الأب',
                        hintText: 'اسم الأب',
                        icon: Icons.person_outline,
                        controller: _fatherNameController,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: 'الكنية',
                        hintText: 'الكنية / اسم العائلة',
                        icon: Icons.badge_outlined,
                        controller: _lastNameController,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: 'اسم الأم',
                        hintText: 'اسم الأم',
                        icon: Icons.person_outline,
                        controller: _motherNameController,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: 'الكلية',
                        hintText: 'اسم الكلية',
                        icon: Icons.school_outlined,
                        controller: _collegeController,
                      ),

                      const SizedBox(height: AppSpacing.lg),
                      _SectionLabel('بيانات التواصل'),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: 'مكان السكن',
                        hintText: 'المدينة / المنطقة',
                        icon: Icons.location_on_outlined,
                        controller: _addressController,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: 'رقم الهاتف',
                        hintText: '09xxxxxxxx',
                        icon: Icons.call_outlined,
                        controller: _numberController,
                        keyboardType: TextInputType.number,
                        textDirection: TextDirection.ltr,
                        maxLength: 10,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),

                      const SizedBox(height: AppSpacing.lg),
                      _SectionLabel('الهدف'),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: 'الهدف (عدد الأجزاء)',
                        hintText: 'مثال: 5',
                        icon: Icons.menu_book_outlined,
                        controller: _targetPartsController,
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        suffixText: 'جزء',
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AppTextField(
                              label: 'من الصفحة',
                              hintText: 'مثال: 1',
                              icon: Icons.last_page,
                              controller: _pageFromController,
                              keyboardType: TextInputType.number,
                              maxLength: 3,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: AppTextField(
                              label: 'إلى الصفحة',
                              hintText: 'مثال: 20',
                              icon: Icons.last_page,
                              controller: _pageToController,
                              keyboardType: TextInputType.number,
                              maxLength: 3,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TaseehDaysSelector(
                        selected: _taseehDays,
                        onChanged: (option) => setState(() => _taseehDays = option),
                      ),

                      const SizedBox(height: AppSpacing.lg),
                      _SectionLabel('كلمة السر'),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: 'كلمة السر',
                        hintText: '••••••••',
                        icon: Icons.lock_outline,
                        controller: _passwordController,
                        isPassword: true,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: 'تأكيد كلمة السر',
                        hintText: '••••••••',
                        icon: Icons.lock_outline,
                        controller: _confirmPasswordController,
                        isPassword: true,
                      ),

                      const SizedBox(height: AppSpacing.xl),
                      BlocBuilder<SignUpBloc, SignUpState>(
                        builder: (context, state) {
                          return AppButton(
                            label: 'إنشاء حساب',
                            isLoading: state.isLoading,
                            onPressed: () => _submit(context),
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const SignInPage()),
                          );
                        },
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: textTheme.bodySmall,
                            children: [
                              const TextSpan(text: 'لديكِ حساب؟ '),
                              TextSpan(
                                text: 'تسجيل الدخول',
                                style: TextStyle(color: scheme.primary, fontWeight: FontWeight.bold),
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Text(
      label,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: scheme.secondary,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
