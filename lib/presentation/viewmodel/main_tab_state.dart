import 'package:luckify/presentation/viewmodel/base_state.dart';

class MainTabState implements BaseState {
  final int selectedIndex;
  @override
  final bool isLoading;
  @override
  final String? error;

  const MainTabState({
    this.selectedIndex = 0,
    this.isLoading = false,
    this.error,
  });

  MainTabState copyWith({int? selectedIndex, bool? isLoading, String? error}) {
    return MainTabState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}