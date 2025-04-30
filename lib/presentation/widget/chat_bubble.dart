import 'package:flutter/material.dart';
import 'package:luckify/core/theme/luckify_colors.dart';
import 'package:luckify/core/theme/luckify_text_styles.dart';
import 'package:luckify/domain/entity/chat_message.dart';
import 'package:luckify/domain/entity/fortune_entity.dart';
import 'package:luckify/domain/entity/message_sender.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final FortuneEntity selectedFortune;

  const ChatBubble({
    required this.message,
    required this.selectedFortune,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == MessageSender.user;
    final screenWidth = MediaQuery.of(context).size.width;

    return isUser
        ? _buildUserBubble(context, screenWidth)
        : _buildBotBubble(context, screenWidth);
  }

  Widget _buildUserBubble(BuildContext context, double screenWidth) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(maxWidth: screenWidth * 0.7),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: LuckifyColors.surfaceSubtle,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message.content,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: LuckifyColors.primary),
        ),
      ),
    );
  }

  Widget _buildBotBubble(BuildContext context, double screenWidth) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundImage: AssetImage(selectedFortune.imageType.path),
          backgroundColor: LuckifyColors.white,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(selectedFortune.name, style: LuckifyTextStyles.fortuneHint),
              const SizedBox(height: 4),
              Container(
                constraints: BoxConstraints(maxWidth: screenWidth * 0.7),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: LuckifyColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  message.content,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: LuckifyColors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
