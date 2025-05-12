import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luckify/config/di/providers.dart';
import 'package:luckify/core/constants/ui_text_constants.dart';
import 'package:luckify/core/theme/luckify_text_styles.dart';
import 'package:luckify/domain/entity/fortune_entity.dart';
import 'package:luckify/presentation/screen/fortune_chat_screen.dart';
import 'package:luckify/presentation/viewmodel/fortune_list_view_model.dart';
import 'package:luckify/presentation/widget/luckify_button.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _navigateToFortuneChat(BuildContext context, WidgetRef ref) {
    final selectedFortune =
        ref.read(fortuneListViewModelProvider).selectedFortune;
    if (selectedFortune == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => FortuneChatScreen(selectedFortune: selectedFortune),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fortuneListViewModelProvider);
    final viewModel = ref.read(fortuneListViewModelProvider.notifier);
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenSize.height * 0.1),
              _buildHeader(),
              SizedBox(height: screenSize.height * 0.05),
              _buildFortuneList(
                state.fortunes,
                state.selectedFortune,
                viewModel,
              ),
              if (state.selectedFortune != null)
                _buildSelectButton(context, ref),
            ],
          ),
        ),
      ),
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
          const SizedBox(height: 12),
          Text(
            UITextConstants.homeScreenSubtitle,
            style: LuckifyTextStyles.fortuneSubtitle,
          ),
        ],
      ),
    );
  }

  Widget _buildFortuneList(
    List<FortuneEntity> fortunes,
    FortuneEntity? selectedFortune,
    FortuneListViewModel viewModel,
  ) {
    return Expanded(
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemCount: fortunes.length,
        separatorBuilder: (context, index) => const SizedBox(height: 18),
        itemBuilder: (context, index) {
          final fortune = fortunes[index];
          return LuckifyButton(
            buttonText: fortune.name,
            isActive: selectedFortune?.id == fortune.id,
            fortuneType: fortune.type,
            onPressed: () => viewModel.selectFortune(fortune),
          );
        },
      ),
    );
  }

  Widget _buildSelectButton(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: LuckifyButton(
        buttonText: UITextConstants.selectButtonText,
        isActive: true,
        onPressed: () => _navigateToFortuneChat(context, ref),
      ),
    );
  }
}