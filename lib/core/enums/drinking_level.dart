enum DrinkingLevel {
  none('없음', '전혀 음주를 하지 않음'),
  occasionally('가끔', '간단한 회식만 참가하는 정도'),
  moderate('적당', '약간의 숙취가 있는 정도'),
  heavy('과음', '다음날 기억이 흐릿할 정도');

  const DrinkingLevel(this.label, this.description);
  final String label;
  final String description;
}
