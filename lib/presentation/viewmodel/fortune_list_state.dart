import 'package:luckify/domain/entity/fortune_entity.dart';
import 'package:luckify/presentation/viewmodel/base_state.dart';

class FortuneListState implements BaseState {
  final List<FortuneEntity> fortunes;
  final FortuneEntity? selectedFortune;
  @override
  final bool isLoading;
  @override
  final String? error;

  const FortuneListState({
    this.fortunes = const [],
    this.selectedFortune,
    this.isLoading = false,
    this.error,
  });

  FortuneListState copyWith({
    List<FortuneEntity>? fortunes,
    FortuneEntity? selectedFortune,
    bool? isLoading,
    String? error,
  }) {
    return FortuneListState(
      fortunes: fortunes ?? this.fortunes,
      selectedFortune: selectedFortune ?? this.selectedFortune,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}