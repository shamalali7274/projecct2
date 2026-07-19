import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// حقل نصي موحّد بنمط "Underline" (بدون صناديق)، يُستخدم بكل فورم
/// بالتطبيق (تسجيل الدخول، إنشاء الحساب...).
///
/// isPassword بتفعّل زر إظهار/إخفاء كلمة السر تلقائياً، بدل الاعتماد
/// على obscureText ثابتة.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.isPassword = false,
    this.keyboardType,
    this.icon,
    this.suffixText,
    this.maxLength,
    this.textDirection,
    this.inputFormatters,
  });

  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType? keyboardType;
  final IconData? icon;
  final String? suffixText;
  final int? maxLength;
  final TextDirection? textDirection;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure = widget.isPassword;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return TextField(
      controller: widget.controller,
      obscureText: _obscure,
      keyboardType: widget.keyboardType,
      textDirection: widget.textDirection,
      maxLength: widget.maxLength,
      inputFormatters: widget.inputFormatters,
      style: Theme.of(context).textTheme.bodyLarge,
      buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hintText,
        suffixText: widget.suffixText,
        prefixIcon: widget.icon != null ? Icon(widget.icon, color: scheme.outline) : null,
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: scheme.outline,
            size: 20,
          ),
          onPressed: () => setState(() => _obscure = !_obscure),
        )
            : null,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: scheme.outlineVariant.withOpacity(0.4), width: 2),
        ),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: scheme.primary, width: 2)),
      ),
    );
  }
}