import 'package:flutter/material.dart';
import 'package:luckify/core/theme/luckify_colors.dart';
import 'package:luckify/core/theme/luckify_text_styles.dart';
import 'package:luckify/domain/entity/fortune_entity.dart';
import 'package:luckify/domain/enum/fortune_type.dart';
import 'package:luckify/presentation/screen/fortune_chat_screen.dart';
import 'package:luckify/presentation/widget/fortune_history_card.dart';

class MyFortuneScreen extends StatefulWidget {
  const MyFortuneScreen({super.key});

  @override
  State<MyFortuneScreen> createState() => _MyFortuneScreenState();
}

class _MyFortuneScreenState extends State<MyFortuneScreen> {
  int _selectedTabIndex = 0;

  final List<FortuneEntity> _dummyItems = [
    FortuneEntity(id: 1, name: '오늘의 운세', type: FortuneType.fortuneToday),
    FortuneEntity(id: 2, name: '별자리 운세', type: FortuneType.zodiacFortune),
    FortuneEntity(id: 3, name: '오늘의 운세', type: FortuneType.fortuneToday),
  ];

  @override
  Widget build(BuildContext context) {
    List<FortuneEntity> displayItems;

    switch (_selectedTabIndex) {
      case 0:
        displayItems = _dummyItems;
        break;
      case 1:
        displayItems = _dummyItems
            .where((item) => item.type == FortuneType.fortuneToday)
            .toList();
        break;
      case 2:
        displayItems = _dummyItems
            .where((item) => item.type == FortuneType.zodiacFortune)
            .toList();
        break;
      default:
        displayItems = _dummyItems;
    }

    return Scaffold(
      body: Column(
        children: [
          _buildFilterTabs(),
          Expanded(
            child: displayItems.isEmpty
                ? _buildEmptyState()
                : _buildFortuneHistoryList(context, displayItems),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      height: 32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildTabButton('전체', 0),
          const SizedBox(width: 8),
          _buildTabButton('오늘의 운세', 1),
          const SizedBox(width: 8),
          _buildTabButton('별자리 운세', 2),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    final isSelected = _selectedTabIndex == index;
    final borderColor =
    isSelected ? LuckifyColors.primary : Colors.grey.withValues(alpha: 0.3);

    return InkWell(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: isSelected ? LuckifyColors.primary : LuckifyColors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Text(
          title,
          style: isSelected
              ? LuckifyTextStyles.tabButtonTextSelected
              : LuckifyTextStyles.tabButtonText,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    String message, subMessage;

    switch (_selectedTabIndex) {
      case 1:
        message = '오늘의 운세 기록이 없어요';
        subMessage = '운세 탭에서 오늘의 운세를 확인해보세요';
        break;
      case 2:
        message = '운세 탭에서 별자리 운세 기록이 없어요';
        subMessage = '운세 탭에서 별자리 운세를 확인해보세요';
        break;
      default:
        message = '아직 본 운세가 없어요';
        subMessage = '운세 탭에서 다양한 운세를 확인해보세요';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_awesome, size: 64, color: LuckifyColors.primaryLight),
          const SizedBox(height: 24),
          Text(message, style: LuckifyTextStyles.emptyStateTitle),
          const SizedBox(height: 16),
          Text(subMessage, style: LuckifyTextStyles.emptyStateSubtitle),
        ],
      ),
    );
  }

  Widget _buildFortuneHistoryList(
      BuildContext context,
      List<FortuneEntity> items,
      ) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = items[index];
        return FortuneHistoryCard(
          fortune: item,
          subtitle: '오늘은 예상치 못한 수익이 들어올 가능성이 있습니다.',
          timestamp: '20분 전',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FortuneChatScreen(selectedFortune: item),
              ),
            );
          },
        );
      },
    );
  }
}