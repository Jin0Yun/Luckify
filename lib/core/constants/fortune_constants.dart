import 'package:luckify/domain/enum/fortune_type.dart';

class FortuneConstants {
  static const Map<FortuneType, String> names = {
    FortuneType.fortuneToday: '오늘의 운세',
    FortuneType.zodiacFortune: '별자리 운세',
  };
  static const String allTabTitle = '전체';
  static const String todayFortuneTabTitle = '오늘의 운세';
  static const String zodiacFortuneTabTitle = '별자리 운세';
}