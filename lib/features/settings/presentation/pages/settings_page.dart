import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_menu_tile.dart';
import '../../../../core/widgets/theme_toggle_button.dart';
import '../../../../core/widgets/confirm_action_dialog.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

/// صفحة الإعدادات — مشتركة بين واجهة المعلّمة وواجهة الطالبة.
///
/// بما إنو كل صفحة (لوحة المعلّمة / قائمة الطالبات / الرئيسية تبع
/// الطالبة) عندها بار سفلي بعدد تبويبات وسلوك تنقّل مختلف، ما بنينا
/// بار جوّا هاي الصفحة، وإنما بناخده باراميتر (navItems / navIndex /
/// onNavTap) من الصفحة اللي فتحتها — هيك صفحة الإعدادات (وزر تسجيل
/// الخروج المربوط بالباك ايند فيها) تُبنى مرة وحدة بس، وتُستدعى بأي
/// مكان بإعدادات بار مختلفة بدل تكرار الكود.
class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
    required this.navItems,
    required this.navIndex,
    required this.onNavTap,
  });

  /// عناصر البار السفلي الخاصة بالصفحة الأم (المعلّمة أو الطالبة).
  final List<AppNavItem> navItems;

  /// index تبويب "الإعدادات/حسابي" ضمن navItems (يظهر محدَّد بالبار).
  final int navIndex;

  /// شو بيصير لما تضغط الأنسة/الطالبة على تبويب تاني وهي بصفحة
  /// الإعدادات — كل صفحة أم بتقرر هي كيف ترجع/تتنقل.
  final ValueChanged<int> onNavTap;

  Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await showConfirmActionDialog(
      context,
      title: 'تسجيل الخروج',
      message: 'هل أنتِ متأكدة من رغبتك بتسجيل الخروج من حسابك؟',
      confirmLabel: 'تسجيل الخروج',
      sentiment: ConfirmActionSentiment.negative,
    );
    if (!confirmed) return;
    if (!context.mounted) return;

    // AuthCubit.logout() بيستدعي AuthController@logout بالباك ايند
    // (POST /api/logout) وبعدين يمسح الجلسة محلياً — نفس التابع
    // بالضبط، سواء الحساب حساب معلّمة أو حساب طالبة، لأنو الباك ايند
    // نفسه واحد لكل الأدوار (يعتمد على التوكن الحالي بس).
    await context.read<AuthCubit>().logout();
    if (!context.mounted) return;

    // logout() لحاله بيغيّر الـ state لـ AuthUnauthenticated، وهاد
    // كافي نظرياً حتى AuthGate (يلي هو home: بالـ MaterialApp) يرجع
    // يبني OnboardingPage. بس المشكلة: صفحة الإعدادات هون مش هي
    // AuthGate نفسها — هي متل أي صفحة تانية متل (Navigator.push)
    // فوق AuthGate بنفس الـ Navigator، فإعادة بناء AuthGate عم تصير
    // بواجهة مدفونة تحت كل الصفحات المفتوحة، وما حدا شايفها. لازم
    // نمسح الـ stack كامل ونرجع لأول صفحة (AuthGate) حتى يظهر
    // التغيير فعلياً عالشاشة.
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: 'الإعدادات',
        subtitle: 'إدارة حسابك وتفضيلاتك',
        avatarUrl: '',
        trailing: const ThemeToggleButton(),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: navIndex,
        onTap: onNavTap,
        items: navItems,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          120,
        ),
        children: [
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Column(
              children: [
                AppMenuTile(icon: Icons.person_outline, label: 'الملف الشخصي', onTap: () {}),
                AppMenuTile(icon: Icons.notifications_none, label: 'الإشعارات', onTap: () {}),
                AppMenuTile(icon: Icons.info_outline, label: 'حول التطبيق', onTap: () {}),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: AppMenuTile(
              icon: Icons.logout,
              label: 'تسجيل الخروج',
              isDestructive: true,
              trailing: const SizedBox.shrink(),
              onTap: () => _handleLogout(context),
            ),
          ),
        ],
      ),
    );
  }
}
