import 'package:luckify/core/constants/ui_text_constants.dart';
import 'package:luckify/core/utils/date_formatter.dart';
import 'package:luckify/domain/entity/empty_state_message.dart';
import 'package:luckify/domain/entity/fortune_history_entity.dart';
import 'package:luckify/domain/enum/fortune_type.dart';
import 'package:luckify/domain/repository/fortune_history_repository.dart';
import 'package:luckify/presentation/viewmodel/base_view_model.dart';
import 'package:luckify/presentation/viewmodel/fortune_history_state.dart';

class FortuneHistoryViewModel extends BaseViewModel<FortuneHistoryState> {
  final FortuneHistoryRepository _repository;
  final DateFormatter _dateFormatter;

  FortuneHistoryViewModel({
    required FortuneHistoryRepository repository,
    required DateFormatter dateFormatter,
  }) : _repository = repository,
       _dateFormatter = dateFormatter,
       super(const FortuneHistoryState());

  @override
  FortuneHistoryState setLoadingState(bool isLoading) {
    return state.copyWith(isLoading: isLoading);
  }

  @override
  FortuneHistoryState setErrorState(String? error) {
    return state.copyWith(error: error);
  }

  @override
  FortuneHistoryState clearErrorState() {
    return state.copyWith(error: null);
  }

  Future<void> loadHistories() async {
    await runWithLoading(() async {
      final histories = await _repository.getFortuneHistories();
      histories.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      state = state.copyWith(histories: histories);
    });
  }

  Future<void> loadHistoriesByType(FortuneType? type) async {
    await runWithLoading(() async {
      final histories =
          type == null
              ? await _repository.getFortuneHistories()
              : await _repository.getFortuneHistoriesByType(type);
      histories.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      state = state.copyWith(histories: histories);
    });
  }

  Future<void> deleteHistory(String id) async {
    await runWithLoading(() async {
      await _repository.deleteFortuneHistory(id);
      await loadHistories();
    });
  }

  void setSelectedTabIndex(int index) {
    state = state.copyWith(selectedTabIndex: index);

    switch (index) {
      case 0:
        loadHistories();
        break;
      case 1:
        loadHistoriesByType(FortuneType.fortuneToday);
        break;
      case 2:
        loadHistoriesByType(FortuneType.zodiacFortune);
        break;
    }
  }

  String formatTimestamp(DateTime timestamp) {
    return _dateFormatter.formatRelativeTime(timestamp);
  }

  EmptyStateMessage getEmptyStateMessage() {
    switch (state.selectedTabIndex) {
      case 1:
        return EmptyStateMessage(
          UITextConstants.emptyTodayMessage,
          UITextConstants.emptyTodaySubMessage,
        );
      case 2:
        return EmptyStateMessage(
          UITextConstants.emptyZodiacMessage,
          UITextConstants.emptyZodiacSubMessage,
        );
      default:
        return EmptyStateMessage(
          UITextConstants.emptyAllMessage,
          UITextConstants.emptyAllSubMessage,
        );
    }
  }

  List<FortuneHistoryEntity> get histories => state.histories;
  int get selectedTabIndex => state.selectedTabIndex;
}