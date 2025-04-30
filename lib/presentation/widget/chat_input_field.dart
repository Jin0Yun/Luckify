import 'package:flutter/material.dart';
import 'package:luckify/core/theme/luckify_colors.dart';
import 'package:luckify/core/theme/luckify_text_styles.dart';

class ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;
  final bool keepKeyboardOpen;

  const ChatInputField({
    required this.controller,
    required this.focusNode,
    required this.onSend,
    this.keepKeyboardOpen = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onSubmitted: (_) {
                onSend();
                if (!keepKeyboardOpen) {
                  focusNode.unfocus();
                }
              },
              decoration: InputDecoration(
                hintText: '메시지를 입력하세요',
                hintStyle: LuckifyTextStyles.chatInputHint,
                filled: true,
                fillColor: LuckifyColors.surfaceSubtle,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              onSend();
              if (!keepKeyboardOpen) {
                focusNode.unfocus();
              }
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: LuckifyColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}