import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// طبقة تخزين موحّدة:
/// - التوكن يُخزَّن بشكل مُشفَّر عبر FlutterSecureStorage.
/// - إعدادات بسيطة (مثل "أول مرة") تُخزَّن عبر SharedPreferences.
class SecureStorage {
  SecureStorage._();

  static const _storage = FlutterSecureStorage();
  static const _keyToken = 'auth_token';
  static const _keyRole = 'user_role';
  static const _keyFirstTime = 'is_first_time';

  // ============ التوكن ونوع الحساب (Secure) ============

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  static Future<String?> getToken() async {
    return _storage.read(key: _keyToken);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }

  /// يخزّن نوع الحساب (role.name) حتى نقدر نرجع نقرر أي واجهة تُفتح
  /// بدون ما نحتاج نطلب تسجيل الدخول من جديد بكل مرة.
  static Future<void> saveRole(String role) async {
    await _storage.write(key: _keyRole, value: role);
  }

  static Future<String?> getRole() async {
    return _storage.read(key: _keyRole);
  }

  // ============ أول مرة (SharedPreferences) ============

  static Future<bool> isFirstTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyFirstTime) ?? true;
    } catch (e) {
      _logError('قراءة $_keyFirstTime', e);
      return true;
    }
  }

  static Future<void> setFirstTimeDone() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyFirstTime, false);
    } catch (e) {
      _logError('حفظ $_keyFirstTime', e);
    }
  }

  static Future<void> resetFirstTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyFirstTime, true);
    } catch (e) {
      _logError('إعادة تعيين $_keyFirstTime', e);
    }
  }

  // ============ دوال مساعدة ============

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> clearAll() async {
    await deleteToken();
    await _storage.delete(key: _keyRole);
    // لا تحذف is_first_time عمداً
  }

  /// طباعة الأخطاء فقط بوضع التطوير (debugPrint يُهمَل تلقائياً بالـ release)
  static void _logError(String action, Object error) {
    if (kDebugMode) {
      debugPrint('خطأ في $action: $error');
    }
  }
}
