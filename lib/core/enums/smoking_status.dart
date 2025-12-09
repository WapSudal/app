enum SmokingStatus {
  neverSmoked('평생 비흡연'),
  formerSmoker('과거 흡연'),
  currentSmoker('현재 흡연 중');

  const SmokingStatus(this.label);
  final String label;
}
