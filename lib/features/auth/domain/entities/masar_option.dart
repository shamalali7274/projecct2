/// خيارات المسار المتاحة عند إنشاء الحساب.
enum MasarOption {
  zad('زاد', 'زاد'),
  otrujja('أترجة', 'أترجة');

  const MasarOption(this.label, this.apiValue);

  /// النص المعروض بالواجهة.
  final String label;


  final String apiValue;
}