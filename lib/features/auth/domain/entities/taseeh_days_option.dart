/// خيارات أيام التسميع المتاحة عند إنشاء الحساب.
enum TaseehDaysOption {
  sundayTuesdayThursday('الأحد - الثلاثاء - الخميس'),
  saturdayMondayWednesday('السبت - الاثنين - الأربعاء');

  const TaseehDaysOption(this.label);
  final String label;
}
