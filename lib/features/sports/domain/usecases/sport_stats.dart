class SportStats {
  const SportStats({
    required this.totalSessions,
    required this.totalDistanceKm,
    required this.totalDurationMinutes,
    required this.currentStreak,
    this.mostFrequentType,
  });

  final int totalSessions;
  final double totalDistanceKm;
  final int totalDurationMinutes;
  final int currentStreak;
  final String? mostFrequentType;
}
