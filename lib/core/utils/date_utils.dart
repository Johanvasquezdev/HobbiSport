class AppDateUtils {
  const AppDateUtils._();

  static DateTime startOfDay(DateTime date) => DateTime(date.year, date.month, date.day);

  static DateTime endOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static DateTime withoutTime(DateTime date) => DateTime(date.year, date.month, date.day);
}
