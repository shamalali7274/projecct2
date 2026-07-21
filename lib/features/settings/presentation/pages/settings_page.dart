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
import '../../../students/presentation/pages/students_list_page.dart';

/// صفحة الإعدادات — تُفتح من تبويب "الإعدادات" بالبار السفلي، بنفس
/// نمط باقي الصفحات (AppTopBar + AppBottomNav + AppCard + AppMenuTile
/// كلها مكوّنات جاهزة، ما تكرر ولا سطر بنائها من جديد هون).
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const int _navIndex = 3;

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
    // (POST /api/logout) وبعدين يمسح الجلسة محلياً. AuthGate بالأعلى
    // هو اللي بيسمع للحالة الجديدة (AuthUnauthenticated) وبيرجّع
    // الأنسة لصفحة تسجيل الدخول تلقائياً.
    await context.read<AuthCubit>().logout();
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
        currentIndex: _navIndex,
        onTap: (i) {
          if (i == _navIndex) return;
          Navigator.of(context).popUntil((route) => route.isFirst);
          if (i == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const StudentsListPage()),
            );
          }
          // باقي التبويبات (الرئيسية عبر popUntil فوق، الإنجازات) TODO لاحقاً
        },
        items: const [
          AppNavItem(icon: Icons.dashboard, label: 'الرئيسية'),
          AppNavItem(icon: Icons.groups_outlined, label: 'الطالبات'),
          AppNavItem(icon: Icons.auto_stories_outlined, label: 'الإنجازات'),
          AppNavItem(icon: Icons.settings_outlined, label: 'الإعدادات'),
        ],
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
                AppMenuTile(
                  icon: Icons.person_outline,
                  label: 'الملف الشخصي',
                  onTap: () {},
                ),
                AppMenuTile(
                  icon: Icons.notifications_none,
                  label: 'الإشعارات',
                  onTap: () {},
                ),
                AppMenuTile(
                  icon: Icons.info_outline,
                  label: 'حول التطبيق',
                  onTap: () {},
                ),
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
