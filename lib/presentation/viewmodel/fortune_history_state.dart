import 'package:luckify/domain/entity/fortune_history_entity.dart';
import 'package:luckify/presentation/viewmodel/base_state.dart';

class FortuneHistoryState implements BaseState {
  final List<FortuneHistoryEntity> histories;
  final int selectedTabIndex;
  @override
  final bool isLoading;
  @override
  final String? error;

  const FortuneHistoryState({
    this.histories = const [],
    this.selectedTabIndex = 0,
    this.isLoading = false,
    this.error,
  });

  FortuneHistoryState copyWith({
    List<FortuneHistoryEntity>? histories,
    int? selectedTabIndex,
    bool? isLoading,
    String? error,
  }) {
    return FortuneHistoryState(
      histories: histories ?? this.histories,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}