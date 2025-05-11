import 'package:luckify/core/utils/date_formatter.dart';
import 'package:luckify/presentation/prompt/generators/fortune_prompt_generator.dart';

class ZodiacFortunePromptGenerator implements FortunePromptGenerator {
  final DateFormatter _dateFormatter;

  ZodiacFortunePromptGenerator(this._dateFormatter);

  @override
  String generatePrompt({String? userInput}) {
    final today = DateTime.now();
    final formattedDate = _dateFormatter.formatToKorean(today);

    if (userInput == null || userInput.isEmpty) {
      throw ArgumentError('별자리 운세에는 별자리 입력이 필요합니다.');
    }

    return ''''$userInput의 오늘($formattedDate) 운세를 알려주세요. 금전운, 사랑운, 건강운, 행운의 컬러를 알려주세요.
    금전운, 사랑운, 건강운을 아래와 같은 스타일로 작성해주세요:
    # 금전운 \n
    # 사랑운 \n 
    # 건강운 \n 
    # 행운의 컬러 \n
    주의사항: 
    - 별자리명과 날짜 범위, 오늘 날짜, 오늘의 운세라는 멘트 작성하지 마세요!
    ''';
  }
}
