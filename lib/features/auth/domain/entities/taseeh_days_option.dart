enum TaseehDaysOption {
  sundayTuesdayThursday('الأحد - الثلاثاء - الخميس', 'SundayTuesdayThursday'),
  saturdayMondayWednesday('السبت - الاثنين - الأربعاء', 'SaturdayMondayWednesday');

  const TaseehDaysOption(this.label, this.apiValue);
  final String label;
  final String apiValue;
}