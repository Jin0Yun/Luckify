import 'package:flutter/material.dart';
import 'package:luckify/domain/enum/fortune_type.dart';
import 'package:luckify/core/theme/luckify_colors.dart';
import 'package:luckify/core/theme/luckify_text_styles.dart';
import 'package:luckify/presentation/util/fortune_asset_path.dart';

class LuckifyButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;
  final bool isActive;
  final FortuneType? fortuneType;

  const LuckifyButton({
    required this.buttonText,
    this.onPressed,
    this.isActive = false,
    this.fortuneType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            isActive ? LuckifyColors.primary : LuckifyColors.white,
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: isActive
                    ? Colors.transparent
                    : LuckifyColors.primary.withValues(alpha: 0.2),
                width: 1.0,
              ),
            ),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 16),
          ),
          overlayColor: WidgetStateProperty.all(
            LuckifyColors.primaryLight.withValues(alpha: 0.3),
          ),
          elevation: WidgetStateProperty.all(isActive ? 4 : 2),
          shadowColor: WidgetStateProperty.all(Colors.black26),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (fortuneType != null)
              Image.asset(
                FortuneAssetPath.getImagePath(fortuneType!),
                width: 35,
                height: 35,
              ),
            const SizedBox(width: 8),
            Text(
              buttonText,
              style: LuckifyTextStyles.buttonText.copyWith(
                color: isActive ? LuckifyColors.white : LuckifyColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}