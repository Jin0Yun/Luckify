import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luckify/config/di/viewmodel_providers.dart';
import 'package:luckify/core/theme/luckify_colors.dart';
import 'package:luckify/core/theme/luckify_text_styles.dart';
import 'package:luckify/domain/entity/fortune_history_entity.dart';
import 'package:luckify/presentation/screen/fortune_chat_screen.dart';
import 'package:luckify/presentation/viewmodel/fortune_history_view_model.dart';
import 'package:luckify/presentation/widget/fortune_history_card.dart';

class MyFortuneScreen extends ConsumerStatefulWidget {
  const MyFortuneScreen({super.key});

  @override
  ConsumerState<MyFortuneScreen> createState() => _MyFortuneScreenState();
}

class _MyFortuneScreenState extends ConsumerState<MyFortuneScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final state = ref.watch(fortuneHistoryViewModelProvider);
    final viewModel = ref.read(fortuneHistoryViewModelProvider.notifier);

    final selectedTabIndex = state.selectedTabIndex;
    final histories = state.histories;
    final isLoading = state.isLoading;

    return Scaffold(
      body: Column(
        children: [
          _buildFilterTabs(selectedTabIndex, viewModel),
          if (isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            Expanded(
              child:
                  histories.isEmpty
                      ? _buildEmptyState(viewModel)
                      : _buildFortuneHistoryList(context, histories, viewModel),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs(
    int selectedTabIndex,
    FortuneHistoryViewModel viewModel,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      height: 32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildTabButton('전체', 0, selectedTabIndex, viewModel),
          const SizedBox(width: 8),
          _buildTabButton('오늘의 운세', 1, selectedTabIndex, viewModel),
          const SizedBox(width: 8),
          _buildTabButton('별자리 운세', 2, selectedTabIndex, viewModel),
        ],
      ),
    );
  }

  Widget _buildTabButton(
    String title,
    int index,
    int selectedTabIndex,
    FortuneHistoryViewModel viewModel,
  ) {
    final isSelected = selectedTabIndex == index;
    final borderColor =
        isSelected ? LuckifyColors.primary : Colors.grey.withValues(alpha: 0.3);

    return InkWell(
      onTap: () => viewModel.setSelectedTabIndex(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: isSelected ? LuckifyColors.primary : LuckifyColors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Text(
          title,
          style:
              isSelected
                  ? LuckifyTextStyles.tabButtonTextSelected
                  : LuckifyTextStyles.tabButtonText,
        ),
      ),
    );
  }

  Widget _buildEmptyState(FortuneHistoryViewModel viewModel) {
    final emptyMessage = viewModel.getEmptyStateMessage();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_awesome, size: 64, color: LuckifyColors.primaryLight),
          const SizedBox(height: 24),
          Text(emptyMessage.message, style: LuckifyTextStyles.emptyStateTitle),
          const SizedBox(height: 16),
          Text(
            emptyMessage.subMessage,
            style: LuckifyTextStyles.emptyStateSubtitle,
          ),
        ],
      ),
    );
  }

  Widget _buildFortuneHistoryList(
    BuildContext context,
    List<FortuneHistoryEntity> histories,
    FortuneHistoryViewModel viewModel,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
      itemCount: histories.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final history = histories[index];
        return FortuneHistoryCard(
          fortune: history.fortune,
          subtitle:
              history.content.length > 80
                  ? '${history.content.substring(0, 80)}...'
                  : history.content,
          timestamp: viewModel.formatTimestamp(history.timestamp),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        FortuneChatScreen(selectedFortune: history.fortune),
              ),
            );
          },
        );
      },
    );
  }
}