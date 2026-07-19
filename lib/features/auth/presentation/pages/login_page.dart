import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../bloc/sign_in_bloc.dart';
import '../bloc/sign_in_event.dart';
import '../bloc/sign_in_state.dart';
import '../cubit/auth_cubit.dart';
import '../../../../core/bloc/request_status.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignInBloc(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _numberController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _numberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    context.read<SignInBloc>().add(
      SignInSubmitted(
        number: _numberController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<SignInBloc, SignInState>(
          listener: (context, state) {
            if (state.status == RequestStatus.failure && state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
            if (state.status == RequestStatus.success && state.role != null) {
              context.read<AuthCubit>().markAuthenticated(state.role!);
            }
          },
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'لوحة المسمعة',
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'سجّلي الدخول للمتابعة',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  AppTextField(
                    label: 'رقم الهاتف',
                    controller: _numberController,
                    keyboardType: TextInputType.number,
                    icon: Icons.call_outlined,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    label: 'كلمة المرور',
                    controller: _passwordController,
                    isPassword: true,
                    icon: Icons.lock_outline,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  BlocBuilder<SignInBloc, SignInState>(
                    builder: (context, state) {
                      return AppButton(
                        label: 'تسجيل الدخول',
                        isLoading: state.isLoading,
                        onPressed: () => _submit(context),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}