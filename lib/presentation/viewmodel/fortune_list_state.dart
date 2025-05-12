import 'package:luckify/domain/entity/fortune_entity.dart';

class FortuneListState {
  final List<FortuneEntity> fortunes;
  final FortuneEntity? selectedFortune;

  const FortuneListState({this.fortunes = const [], this.selectedFortune});

  FortuneListState copyWith({
    List<FortuneEntity>? fortunes,
    FortuneEntity? selectedFortune,
  }) {
    return FortuneListState(
      fortunes: fortunes ?? this.fortunes,
      selectedFortune: selectedFortune ?? this.selectedFortune,
    );
  }
}