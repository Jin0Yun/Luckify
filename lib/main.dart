import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luckify/core/theme/luckify_text_styles.dart';
import 'package:luckify/firebase_options.dart';
import 'package:luckify/core/theme/luckify_colors.dart';
import 'package:luckify/presentation/screen/login_screen.dart';
import 'package:luckify/presentation/screen/main_screen.dart';
import 'config/di/viewmodel_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);

    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: LuckifyColors.white,
        primaryColor: LuckifyColors.primary,
        fontFamily: 'Moneygraphy',
        appBarTheme: AppBarTheme(
          backgroundColor: LuckifyColors.white,
          foregroundColor: LuckifyColors.primary,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: LuckifyColors.transparent,
          titleTextStyle: LuckifyTextStyles.appBarTitle,
        ),
      ),
      home: authState.isLoggedIn ? const MainScreen() : const LoginScreen(),
    );
  }
}