enum FortuneType {
  fortuneToday,
  zodiacFortune;

  String get path {
    switch (this) {
      case FortuneType.fortuneToday:
        return 'assets/images/fortune_today.png';
      case FortuneType.zodiacFortune:
        return 'assets/images/zodiac_fortune.png';
    }
  }
}