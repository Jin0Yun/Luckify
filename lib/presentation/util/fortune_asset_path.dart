import 'package:luckify/domain/enum/fortune_type.dart';

class FortuneAssetPath {
  static String getImagePath(FortuneType type) {
    switch (type) {
      case FortuneType.fortuneToday:
        return 'assets/images/fortune_today.png';
      case FortuneType.zodiacFortune:
        return 'assets/images/zodiac_fortune.png';
    }
  }
}