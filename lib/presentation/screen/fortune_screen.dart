import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luckify/config/di/providers.dart';
import 'package:luckify/core/constants/ui_text_constants.dart';
import 'package:luckify/core/theme/luckify_text_styles.dart';
import 'package:luckify/domain/entity/fortune_entity.dart';
import 'package:luckify/presentation/screen/fortune_chat_screen.dart';
import 'package:luckify/presentation/viewmodel/fortune_list_view_model.dart';
import 'package:luckify/presentation/widget/luckify_button.dart';

class FortuneScreen extends ConsumerWidget {
  const FortuneScreen({super.key});

  void _navigateToFortuneChat(BuildContext context, FortuneEntity fortune) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FortuneChatScreen(selectedFortune: fortune),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fortuneListViewModelProvider);
    final viewModel = ref.read(fortuneListViewModelProvider.notifier);
    final Size screenSize = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: screenSize.height * 0.05),
        _buildHeader(),
        SizedBox(height: screenSize.height * 0.05),
        _buildFortuneList(context, state.fortunes, viewModel),
        const Spacer(flex: 1),
        SizedBox(height: screenSize.height * 0.05),
      ],
    );
  }

  Widget _buildHeader() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            UITextConstants.homeScreenTitle,
            style: LuckifyTextStyles.fortuneTitle,
          ),
          const SizedBox(height: 16),
          Text(
            UITextConstants.homeScreenSubtitle,
            style: LuckifyTextStyles.fortuneSubtitle,
          ),
        ],
      ),
    );
  }

  Widget _buildFortuneList(
    BuildContext context,
    List<FortuneEntity> fortunes,
    FortuneListViewModel viewModel,
  ) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.35,
      ),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: fortunes.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final fortune = fortunes[index];
          return LuckifyButton(
            buttonText: fortune.name,
            isActive: false,
            fortuneType: fortune.type,
            onPressed: () {
              viewModel.selectFortune(fortune);
              _navigateToFortuneChat(context, fortune);
            },
          );
        },
      ),
    );
  }
}