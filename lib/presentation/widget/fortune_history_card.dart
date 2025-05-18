import 'package:flutter/material.dart';
import 'package:luckify/core/theme/luckify_colors.dart';
import 'package:luckify/core/theme/luckify_text_styles.dart';
import 'package:luckify/domain/entity/fortune_entity.dart';
import 'package:luckify/presentation/util/fortune_asset_path.dart';

class FortuneHistoryCard extends StatelessWidget {
  final FortuneEntity fortune;
  final String subtitle;
  final String timestamp;
  final VoidCallback? onPressed;

  const FortuneHistoryCard({
    required this.fortune,
    required this.subtitle,
    required this.timestamp,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = fortune.primaryColor;

    return Card(
      elevation: 2,
      shadowColor: LuckifyColors.alertOverlay,
      color: LuckifyColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: primaryColor.withValues(alpha: 0.2),
          width: 1.0,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    FortuneAssetPath.getImagePathFromEntity(fortune),
                    width: 35,
                    height: 35,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          fortune.name,
                          style: LuckifyTextStyles.fortuneCardSubtitle,
                        ),
                        Text(
                          timestamp,
                          style: LuckifyTextStyles.fortuneCardTimestamp,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: LuckifyTextStyles.fortuneCardContent,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}