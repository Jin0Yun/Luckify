class ZodiacConstants {
  static const Set<String> zodiacNames = {
    '물병자리',
    '물고기자리',
    '양자리',
    '황소자리',
    '쌍둥이자리',
    '게자리',
    '사자자리',
    '처녀자리',
    '천칭자리',
    '전갈자리',
    '사수자리',
    '염소자리',
  };

  static String? findZodiac(String input) {
    if (input.trim().length <= 1) return null;

    final normalized = input.trim();
    final fullName = normalized.endsWith('자리') ? normalized : '${normalized}자리';

    return zodiacNames.contains(fullName) ? fullName : null;
  }
}