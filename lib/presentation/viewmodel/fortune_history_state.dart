import 'package:luckify/domain/entity/fortune_history_entity.dart';
import 'package:luckify/presentation/viewmodel/base_state.dart';

class FortuneHistoryState implements BaseState {
  final List<FortuneHistoryEntity> histories;
  final int selectedTabIndex;
  @override
  final bool isLoading;
  @override
  final String? error;
  final bool isRequestInProgress;
  final bool isInitialized;

  const FortuneHistoryState({
    this.histories = const [],
    this.selectedTabIndex = 0,
    this.isLoading = false,
    this.error,
    this.isRequestInProgress = false,
    this.isInitialized = false,
  });

  FortuneHistoryState copyWith({
    List<FortuneHistoryEntity>? histories,
    int? selectedTabIndex,
    bool? isLoading,
    String? error,
    bool? isRequestInProgress,
    bool? isInitialized,
  }) {
    return FortuneHistoryState(
      histories: histories ?? this.histories,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isRequestInProgress: isRequestInProgress ?? this.isRequestInProgress,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}