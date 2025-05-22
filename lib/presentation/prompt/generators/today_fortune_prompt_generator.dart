import 'package:luckify/core/utils/date_formatter.dart';
import 'package:luckify/presentation/prompt/generators/fortune_prompt_generator.dart';

class TodayFortunePromptGenerator implements FortunePromptGenerator {
  final DateFormatter _dateFormatter;

  TodayFortunePromptGenerator(this._dateFormatter);

  @override
  String generatePrompt({String? userInput}) {
    final today = DateTime.now();
    final formattedDate = _dateFormatter.formatToKorean(today);

    return '''오늘($formattedDate)의 운세를 알려주세요. 오늘 하루의 전반적인 운세와 함께 금전운, 사랑운, 건강운, 행운의 컬러를 포함해 주세요.
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