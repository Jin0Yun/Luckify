import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luckify/presentation/viewmodel/fortune_list_state.dart';
import 'package:luckify/presentation/viewmodel/fortune_list_view_model.dart';

final fortuneListViewModelProvider =
    StateNotifierProvider<FortuneListViewModel, FortuneListState>(
      (ref) => FortuneListViewModel(),
    );