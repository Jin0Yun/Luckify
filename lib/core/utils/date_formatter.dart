abstract class DateFormatter {
  String formatToKorean(DateTime date);
  String formatRelativeTime(DateTime timestamp);
}

class TimeFormat {
  final int limit;
  final String unit;
  final int divisor;

  const TimeFormat({required this.limit, required this.unit, required this.divisor});
}

class KoreanDateFormatter implements DateFormatter {
  final List<TimeFormat> _formats = const [
    TimeFormat(limit: 60, unit: '분', divisor: 1),
    TimeFormat(limit: 24 * 60, unit: '시간', divisor: 60),
    TimeFormat(limit: 30 * 24 * 60, unit: '일', divisor: 24 * 60),
  ];

  @override
  String formatToKorean(DateTime date) {
    return '${date.year}년 ${date.month}월 ${date.day}일';
  }

  @override
  String formatRelativeTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    final minutes = difference.inMinutes;

    for (var format in _formats) {
      if (minutes < format.limit) {
        final value = (minutes / format.divisor).floor();
        return '$value${format.unit} 전';
      }
    }

    return '${timestamp.year}.${timestamp.month}.${timestamp.day}';
  }
}