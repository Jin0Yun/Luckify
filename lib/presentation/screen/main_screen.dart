import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luckify/config/di/viewmodel_providers.dart';
import 'package:luckify/core/constants/ui_text_constants.dart';
import 'package:luckify/core/theme/luckify_colors.dart';
import 'package:luckify/core/theme/luckify_text_styles.dart';
import 'package:luckify/presentation/screen/fortune_screen.dart';
import 'package:luckify/presentation/screen/my_fortune_screen.dart';
import 'package:luckify/presentation/screen/profile_screen.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(mainTabViewModelProvider);
    final currentIndex = viewModel.selectedIndex;

    return Scaffold(
      appBar: _buildAppBar(context, currentIndex, ref),
      body: _buildBody(currentIndex),
      bottomNavigationBar: _buildBottomNavigationBar(
        context,
        currentIndex,
        ref,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    int currentIndex,
    WidgetRef ref,
  ) {
    return AppBar(
      title: Text(
        currentIndex == 0 ? '' : UITextConstants.myFortuneTitle,
        style: LuckifyTextStyles.appBarTitle.copyWith(
          color: LuckifyColors.primary,
        ),
      ),
      backgroundColor: LuckifyColors.white,
      foregroundColor: LuckifyColors.primary,
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.person, size: 28),
          padding: const EdgeInsets.all(16.0),
          onPressed: () => _navigateToProfileScreen(context),
        ),
      ],
    );
  }

  Widget _buildBody(int currentIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: IndexedStack(
        index: currentIndex,
        children: [
          const FortuneScreen(),
          MyFortuneScreen(key: ValueKey(currentIndex == 1)),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(
    BuildContext context,
    int currentIndex,
    WidgetRef ref,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: LuckifyColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
        boxShadow: [
          BoxShadow(
            color: LuckifyColors.primary.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: LuckifyColors.primary.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap:
              (index) => ref
                  .read(mainTabViewModelProvider.notifier)
                  .setTabIndex(index),
          backgroundColor: LuckifyColors.white,
          selectedItemColor: LuckifyColors.primary,
          unselectedItemColor: LuckifyColors.grey.withValues(alpha: 0.6),
          selectedLabelStyle: LuckifyTextStyles.navLabel.copyWith(
            fontWeight: FontWeight.w600,
            color: LuckifyColors.primary,
          ),
          unselectedLabelStyle: LuckifyTextStyles.navLabel,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: [
            _buildNavItem(Icons.auto_awesome, UITextConstants.fortuneTitle),
            _buildNavItem(Icons.history, UITextConstants.myFortuneTitle),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData iconData, String label) {
    const EdgeInsets navIconPadding = EdgeInsets.only(bottom: 4, top: 6);

    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(padding: navIconPadding, child: Icon(iconData)),
          Container(height: 3, color: Colors.transparent),
        ],
      ),
      activeIcon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(padding: navIconPadding, child: Icon(iconData, size: 28)),
        ],
      ),
      label: label,
    );
  }

  void _navigateToProfileScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }
}