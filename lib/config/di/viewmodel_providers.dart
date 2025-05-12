import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luckify/config/di/core_providers.dart';
import 'package:luckify/config/di/usecase_providers.dart';
import 'package:luckify/domain/entity/fortune_entity.dart';
import 'package:luckify/presentation/viewmodel/fortune_list_state.dart';
import 'package:luckify/presentation/viewmodel/fortune_list_view_model.dart';
import 'package:luckify/presentation/viewmodel/fortune_state.dart';
import 'package:luckify/presentation/viewmodel/fortune_viewmodel.dart';

final fortuneListViewModelProvider =
    StateNotifierProvider<FortuneListViewModel, FortuneListState>(
      (ref) => FortuneListViewModel(),
    );

final fortuneViewModelProvider =
    StateNotifierProvider.family<FortuneViewModel, FortuneState, FortuneEntity>(
      (ref, selectedFortune) => FortuneViewModel(
        selectedFortune: selectedFortune,
        getFortuneReadingUseCase: ref.read(getFortuneReadingUseCaseProvider),
        uuidGenerator: ref.read(uuidGeneratorProvider),
      ),
    );