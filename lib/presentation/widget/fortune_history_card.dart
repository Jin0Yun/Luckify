import 'package:flutter/material.dart';
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
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.3), width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    FortuneAssetPath.getImagePathFromEntity(fortune),
                    width: 25,
                    height: 25,
                  ),
                  const SizedBox(width: 8),
                  Text(fortune.name, style: LuckifyTextStyles.fortuneCardSubtitle),
                  const Spacer(),
                  Text(
                    timestamp,
                    style: LuckifyTextStyles.fortuneCardTimestamp,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                subtitle,
                style: LuckifyTextStyles.fortuneCardContent,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
