enum FortuneType {
  fortuneToday,
  zodiacFortune;

  bool get isZodiacFortune => this == FortuneType.zodiacFortune;
  bool get isFortuneTodayType => this == FortuneType.fortuneToday;
}