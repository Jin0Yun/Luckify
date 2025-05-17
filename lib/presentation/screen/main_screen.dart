import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luckify/core/theme/luckify_colors.dart';
import 'package:luckify/core/theme/luckify_text_styles.dart';
import 'package:luckify/presentation/screen/fortune_screen.dart';
import 'package:luckify/presentation/screen/profile_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  static const EdgeInsets _navIconPadding = EdgeInsets.only(bottom: 4, top: 6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentIndex == 0 ? '' : '히스토리',
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        child: IndexedStack(
          index: _currentIndex,
          children: [const FortuneScreen(), _buildHistoryScreen()],
        ),
      ),
      bottomNavigationBar: Container(
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
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
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
              _buildNavItem(Icons.auto_awesome, '운세'),
              _buildNavItem(Icons.history, '히스토리'),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData iconData, String label) {
    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(padding: _navIconPadding, child: Icon(iconData)),
          Container(height: 3, color: Colors.transparent),
        ],
      ),
      activeIcon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(padding: _navIconPadding, child: Icon(iconData, size: 28)),
        ],
      ),
      label: label,
    );
  }

  Widget _buildHistoryScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '히스토리 화면 (준비 중...)',
            style: LuckifyTextStyles.navLabel.copyWith(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

void _navigateToProfileScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const ProfileScreen()),
  );
}