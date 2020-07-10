extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

extension DateTimeExtension on DateTime {
  bool isToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final aDate = DateTime(this.year, this.month, this.day);
    return aDate == today;
  }

  bool isSameDay(DateTime date) {
    final aDate = DateTime(this.year, this.month, this.day);
    final bDate = DateTime(date.year, date.month, date.day);
    return aDate == bDate;
  }
}
