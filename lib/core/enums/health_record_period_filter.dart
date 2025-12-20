/// 기록 기간 필터
enum HealthRecordPeriodFilter {
  week('7일', 7),
  month('30일', 30),
  all('전체', null);

  const HealthRecordPeriodFilter(this.label, this.days);

  final String label;
  final int? days;
}
