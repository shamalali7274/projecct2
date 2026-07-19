/// أنصاف أقطار الحواف الموحّدة في كل التطبيق (بدل تكرار أرقام عشوائية)
class AppRadius {
  AppRadius._();
  static const double sm = 8;
  static const double md = 16; // DEFAULT (1rem)
  static const double lg = 32; // rounded-lg (2rem)
  static const double xl = 48; // rounded-xl (3rem)
  static const double full = 999; // كبسولة / دائرة كاملة
}

/// المسافات الموحّدة (Spacing Scale) المستخدمة بين وداخل العناصر
class AppSpacing {
  AppSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 40;
}
