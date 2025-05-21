import 'package:luckify/presentation/viewmodel/base_view_model.dart';
import 'package:luckify/presentation/viewmodel/fortune_history_view_model.dart';
import 'package:luckify/presentation/viewmodel/main_tab_state.dart';

class MainTabViewModel extends BaseViewModel<MainTabState> {
  final FortuneHistoryViewModel _historyViewModel;

  MainTabViewModel(this._historyViewModel) : super(const MainTabState());

  @override
  MainTabState setLoadingState(bool isLoading) {
    return state.copyWith(isLoading: isLoading);
  }

  @override
  MainTabState setErrorState(String? error) {
    return state.copyWith(error: error);
  }

  @override
  MainTabState clearErrorState() {
    return state.copyWith(error: null);
  }

  void setTabIndex(int index) {
    if (state.selectedIndex == index) return;

    if (index == 1) {
      if (!_historyViewModel.isInitialized) {
        _historyViewModel.loadHistories();
      }
      _historyViewModel.setSelectedTabIndex(0);
    }

    state = state.copyWith(selectedIndex: index);
  }
}
