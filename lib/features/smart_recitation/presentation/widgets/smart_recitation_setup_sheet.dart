import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

/// نتيجة اختيار الانسة: من صفحة - إلى صفحة - كم سؤال تريد.
class SmartRecitationSetupResult {
  const SmartRecitationSetupResult({
    required this.fromPage,
    required this.toPage,
    required this.count,
  });
  final int fromPage;
  final int toPage;
  final int count;
}

/// يفتح Bottom Sheet لإدخال نطاق صفحات السبر وعدد الأسئلة، ويرجّع
/// النتيجة (أو null لو الانسة ألغت). نفس نمط الحقول المستخدم بصفحة
/// إنشاء تسميع جديد (AppTextField + AppButton)، بس بودجت مستقل قابل
/// لإعادة الاستخدام بدل صفحة كاملة.
Future<SmartRecitationSetupResult?> showSmartRecitationSetupSheet(BuildContext context) {
  return showModalBottomSheet<SmartRecitationSetupResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _SmartRecitationSetupSheet(),
  );
}

class _SmartRecitationSetupSheet extends StatefulWidget {
  const _SmartRecitationSetupSheet();

  @override
  State<_SmartRecitationSetupSheet> createState() => _SmartRecitationSetupSheetState();
}

class _SmartRecitationSetupSheetState extends State<_SmartRecitationSetupSheet> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _countController = TextEditingController(text: '5');
  String? _errorText;

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _countController.dispose();
    super.dispose();
  }

  void _submit() {
    final from = int.tryParse(_fromController.text.trim());
    final to = int.tryParse(_toController.text.trim());
    final count = int.tryParse(_countController.text.trim());

    if (from == null || to == null || to < from) {
      setState(() => _errorText = 'حددي نطاق صفحات صحيح (من - إلى)');
      return;
    }
    if (count == null || count < 1 || count > 20) {
      setState(() => _errorText = 'عدد الأسئلة لازم يكون بين 1 و 20');
      return;
    }

    Navigator.of(
      context,
    ).pop(SmartRecitationSetupResult(fromPage: from, toPage: to, count: count));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: scheme.outlineVariant,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                ),
              ),
              Text('سبر ذكي', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 6),
              Text(
                'حددي المجال اللي جهزتلو الطالبة، وكم سؤال تريدي النظام '
                'يقترحلك بناءً على أخطائها السابقة.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _fromController,
                      label: 'من صفحة',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppTextField(
                      controller: _toController,
                      label: 'إلى صفحة',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _countController,
                label: 'كم سؤال تريدي',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              if (_errorText != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(_errorText!, style: TextStyle(color: scheme.error, fontSize: 13)),
              ],
              const SizedBox(height: AppSpacing.xl),
              AppButton(label: 'ابدأ السبر', icon: Icons.auto_awesome, onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
