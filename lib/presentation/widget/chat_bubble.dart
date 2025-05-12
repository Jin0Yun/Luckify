import 'package:flutter/material.dart';
import 'package:luckify/core/theme/luckify_colors.dart';
import 'package:luckify/core/theme/luckify_text_styles.dart';
import 'package:luckify/domain/entity/fortune_entity.dart';
import 'package:luckify/domain/entity/fortune_message_entity.dart';
import 'package:intl/intl.dart';
import 'package:luckify/presentation/util/fortune_asset_path.dart';

class ChatBubble extends StatelessWidget {
  final FortuneMessageEntity message;
  final FortuneEntity selectedFortune;

  const ChatBubble({
    required this.message,
    required this.selectedFortune,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender.isUser;
    final screenWidth = MediaQuery.of(context).size.width;

    return isUser
        ? _buildUserBubble(screenWidth)
        : _buildBotBubble(screenWidth);
  }

  Widget _buildUserBubble(double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatTime(message.timestamp),
            style: LuckifyTextStyles.timestampText,
          ),
          const SizedBox(width: 6),
          Container(
            constraints: BoxConstraints(maxWidth: screenWidth * 0.7),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: LuckifyColors.surfaceSubtle,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message.content,
              style: LuckifyTextStyles.messageUserText,
              overflow: TextOverflow.visible,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotBubble(double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: AssetImage(
              FortuneAssetPath.getImagePathFromEntity(selectedFortune),
            ),
            backgroundColor: LuckifyColors.white,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selectedFortune.name,
                style: LuckifyTextStyles.fortuneSubtitle,
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: screenWidth * 0.6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: selectedFortune.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message.content,
                      style: LuckifyTextStyles.messageBotText,
                      overflow: TextOverflow.visible,
                      softWrap: true,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _formatTime(message.timestamp),
                    style: LuckifyTextStyles.timestampText,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return DateFormat(
      'a h:mm',
    ).format(time).replaceAll('AM', '오전').replaceAll('PM', '오후');
  }
}