import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luckify/config/di/providers.dart';
import 'package:luckify/core/theme/luckify_colors.dart';
import 'package:luckify/core/theme/luckify_text_styles.dart';
import 'package:luckify/presentation/screen/login_screen.dart';
import 'package:luckify/presentation/viewmodel/auth_state.dart';
import 'package:luckify/presentation/viewmodel/auth_view_model.dart';
import 'package:luckify/presentation/widget/luckify_alert_service.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final authViewModel = ref.read(authViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('프로필', style: LuckifyTextStyles.appBarTitle),
        backgroundColor: LuckifyColors.white,
        foregroundColor: LuckifyColors.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(context, authState, authViewModel),
              const SizedBox(height: 32),
              Text('설정', style: LuckifyTextStyles.sectionTitle),
              const SizedBox(height: 16),
              _buildSettingsItems(context),
              const SizedBox(height: 32),
              Text('앱 정보', style: LuckifyTextStyles.sectionTitle),
              const SizedBox(height: 16),
              _buildAppInfoItems(context),
              const SizedBox(height: 32),
              Text('계정', style: LuckifyTextStyles.sectionTitle),
              const SizedBox(height: 16),
              _buildAccountItems(context, authViewModel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    AuthState authState,
    AuthViewModel authViewModel,
  ) {
    final String displayName = authState.user.displayName ?? '사용자';

    return Column(
      children: [
        Center(
          child: CircleAvatar(
            radius: 50,
            backgroundColor: LuckifyColors.primary,
            backgroundImage:
                authState.user.photoURL != null
                    ? NetworkImage(authState.user.photoURL.toString())
                    : null,
            child:
                authState.user.photoURL == null
                    ? Icon(Icons.person, size: 50, color: LuckifyColors.white)
                    : null,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: displayName,
                      style: LuckifyTextStyles.fortuneTitle,
                    ),
                    TextSpan(
                      text: ' 님',
                      style: LuckifyTextStyles.fortuneTitleSmall,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItems(BuildContext context) {
    return Column(
      children: [
        _buildSettingItem(
          title: '알림 설정',
          onTap: () {
            /// 알림 설정 화면으로 이동
          },
        ),
      ],
    );
  }

  Widget _buildAppInfoItems(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            children: [
              Expanded(
                child: Text('버전 정보', style: LuckifyTextStyles.profileItemText),
              ),
              Text(
                'v1.0.0',
                style: LuckifyTextStyles.fortuneSubtitle.copyWith(
                  color: LuckifyColors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccountItems(BuildContext context, AuthViewModel authViewModel) {
    return Column(
      children: [
        _buildSettingItem(
          title: '로그아웃',
          onTap: () {
            _showLogoutConfirmation(context, authViewModel);
          },
          showChevron: false,
        ),
        const Divider(),
        _buildSettingItem(
          title: '회원 탈퇴',
          isDestructive: true,
          onTap: () {
            _showDeleteAccountConfirmation(context, authViewModel);
          },
          showChevron: false,
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required String title,
    String? rightText,
    required VoidCallback onTap,
    bool isDestructive = false,
    bool showChevron = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style:
                    isDestructive
                        ? LuckifyTextStyles.profileItemTextDestructive
                        : LuckifyTextStyles.profileItemText,
              ),
            ),
            if (rightText != null)
              Text(
                rightText,
                style: LuckifyTextStyles.fortuneSubtitle.copyWith(
                  color: LuckifyColors.grey,
                ),
              ),
            if (showChevron)
              const Icon(
                Icons.chevron_right,
                size: 24,
                color: LuckifyColors.grey,
              ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation(
    BuildContext context,
    AuthViewModel authViewModel,
  ) {
    final alertService = LuckifyAlertService();
    alertService
        .showAlert(
          context: context,
          title: '로그아웃',
          content: '정말 로그아웃 하시겠습니까?',
          cancelText: '취소',
          confirmText: '확인',
          isDestructive: false,
          barrierDismissible: true,
        )
        .then((confirmed) async {
          if (confirmed == true) {
            await authViewModel.signOut();
            if (context.mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            }
          }
        });
  }

  void _showDeleteAccountConfirmation(
    BuildContext context,
    AuthViewModel authViewModel,
  ) {
    final alertService = LuckifyAlertService();
    alertService
        .showAlert(
          context: context,
          title: '회원 탈퇴',
          content:
              '탈퇴하면 모든 데이터가 영구적으로 제거됩니다. 이 작업은 되돌릴 수 없습니다. \n정말 탈퇴 하시겠습니까?',
          cancelText: '취소',
          confirmText: '탈퇴',
          isDestructive: true,
          barrierDismissible: true,
        )
        .then((confirmed) async {
          if (confirmed == true) {
            try {
              await authViewModel.deleteAccount();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            } catch (e) {
              if (context.mounted) {
                final alertService = LuckifyAlertService();
                alertService.showAlert(
                  context: context,
                  title: '오류',
                  content: '회원 탈퇴 중 오류가 발생했습니다. \n다시 시도해주세요.',
                  confirmText: '확인',
                  barrierDismissible: true,
                );
              }
            }
          }
        });
  }
}