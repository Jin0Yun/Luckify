import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:luckify/config/di/providers.dart';
import 'package:luckify/core/theme/luckify_colors.dart';
import 'package:luckify/core/theme/luckify_text_styles.dart';
import 'package:luckify/presentation/screen/home_screen.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);

    if (authState.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      });
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              LuckifyColors.primary,
              LuckifyColors.primaryDark,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Luckify',
                        style: LuckifyTextStyles.loginTitle.copyWith(
                          color: LuckifyColors.white,
                          fontSize: 48,
                          letterSpacing: 1.2,
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.black.withValues(alpha: 0.3),
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.auto_awesome,
                        size: 30,
                        color: LuckifyColors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '운세를 확인하고 나만의 행운을 찾아보세요',
                    style: LuckifyTextStyles.loginSubtitle.copyWith(
                      color: LuckifyColors.white.withValues(alpha: 0.9),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50),
                  if (authState.isLoading)
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(LuckifyColors.white),
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: SignInButton(
                        Buttons.Google,
                        text: "Google로 로그인",
                        onPressed: () {
                          ref.read(authViewModelProvider.notifier).signInWithGoogle();
                        },
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  if (authState.error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        authState.error!,
                        style: LuckifyTextStyles.errorText.copyWith(
                          color: LuckifyColors.errorRed.withValues(alpha: 0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}