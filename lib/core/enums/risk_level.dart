enum RiskLevel {
  unknown('Unknown', null),
  low('낮음', 0xFF71CE6E),
  medium('보통', 0xFFF7DB34),
  higher('주의', 0xFFFF9500),
  high('높음', 0xFFFF4130);

  const RiskLevel(this.label, this.color);

  final String label;
  final int? color;
}
