/// 건강 상태 레벨 (혈압/혈당 안정성 기준)
enum HealthStatusLevel {
  excellent('아주 좋아요!', '혈압/혈당 변화가 안정적이에요.', '👏', 0xFF71CE6E),
  good('좋아요!', '건강 관리를 잘 하고 계세요.', '💪', 0xFF1E90FF),
  caution('주의가 필요해요', '혈압/혈당 변화가 다소 불안정해요.', '⚠️', 0xFFFF9500),
  warning('관리가 필요해요', '혈압/혈당이 정상 범위를 벗어났어요.', '🩺', 0xFFFF4130);

  const HealthStatusLevel(this.title, this.description, this.emoji, this.color);

  final String title;
  final String description;
  final String emoji;
  final int color;
}
