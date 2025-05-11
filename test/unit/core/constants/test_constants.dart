abstract final class TestConstants {
  static const String gptModel = 'gpt-4o-mini';
  static const String testId = 'test-id';
  static const String messageId = 'msg-id';
  static const String apiKey = 'test-api-key';
  static final DateTime testDate = DateTime(2025, 5, 10);
  static const int testTimestamp = 1746802800;
  static const int fortuneId = 1;
  static const String zodiacSign = '물고기자리';
  static const String fortuneContent =
      '물고기자리의 운세입니다. 이번 주는 대인관계에서 좋은 기운이 있을 것입니다.';

  static const String promptText = '오늘의 운세 프롬프트';
  static const String formattedZodiacContent =
      '🌟 $zodiacSign의 운세 🌟\n\n$fortuneContent';
  static const String formattedTodayContent =
      '✨ 오늘의 운세 ✨\n\n오늘은 좋은 일이 생길 것입니다.';
}