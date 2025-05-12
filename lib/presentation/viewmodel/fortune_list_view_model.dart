import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luckify/core/constants/fortune_constants.dart';
import 'package:luckify/core/theme/luckify_colors.dart';
import 'package:luckify/domain/entity/fortune_entity.dart';
import 'package:luckify/domain/enum/fortune_type.dart';
import 'package:luckify/presentation/util/fortune_asset_path.dart';
import 'package:luckify/presentation/viewmodel/fortune_list_state.dart';

class FortuneListViewModel extends StateNotifier<FortuneListState> {
  FortuneListViewModel() : super(const FortuneListState()) {
    _initialize();
  }

  void _initialize() {
    final fortunes = _createDefaultFortunes();
    state = state.copyWith(fortunes: fortunes);
  }

  List<FortuneEntity> _createDefaultFortunes() {
    return [
      FortuneEntity(
        id: 1,
        name: FortuneConstants.names[FortuneType.fortuneToday] ?? '오늘의 운세',
        type: FortuneType.fortuneToday,
        iconPath: FortuneAssetPath.getImagePath(FortuneType.fortuneToday),
        primaryColor: LuckifyColors.primary,
      ),
      FortuneEntity(
        id: 2,
        name: FortuneConstants.names[FortuneType.zodiacFortune] ?? '별자리 운세',
        type: FortuneType.zodiacFortune,
        iconPath: FortuneAssetPath.getImagePath(FortuneType.zodiacFortune),
        primaryColor: LuckifyColors.primary,
      ),
    ];
  }

  void selectFortune(FortuneEntity fortune) {
    state = state.copyWith(selectedFortune: fortune);
  }

  List<FortuneEntity> get fortunes => state.fortunes;
  FortuneEntity? get selectedFortune => state.selectedFortune;
}