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
    final normalized = input.trim();

    if (normalized.isEmpty) return null;

    if (zodiacNames.contains(normalized)) {
      return normalized;
    }

    final fullName = normalized.endsWith('자리') ? normalized : '${normalized}자리';
    if (zodiacNames.contains(fullName)) {
      return fullName;
    }

    return null;
  }
}