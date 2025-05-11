abstract class DateFormatter {
  String formatToKorean(DateTime date);
}

class KoreanDateFormatter implements DateFormatter {
  @override
  String formatToKorean(DateTime date) {
    return '${date.year}년 ${date.month}월 ${date.day}일';
  }
}