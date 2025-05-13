import 'package:flutter/material.dart';
import 'package:luckify/core/theme/luckify_colors.dart';
import 'package:luckify/core/theme/luckify_text_styles.dart';

class ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;
  final bool isLoading;

  const ChatInputField({
    required this.controller,
    required this.focusNode,
    required this.onSend,
    this.isLoading = false,
    super.key,
  }) : super();

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
              enabled: !isLoading,
              onSubmitted: (_) => onSend(),
              decoration: InputDecoration(
                hintText: '메시지를 입력하세요',
                hintStyle: LuckifyTextStyles.inputHintText,
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
            onTap: isLoading ? null : onSend,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    isLoading
                        ? LuckifyColors.primary.withValues(alpha: 0.5)
                        : LuckifyColors.primary,
                shape: BoxShape.circle,
              ),
              child:
                  isLoading
                      ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: LuckifyColors.white,
                        ),
                      )
                      : const Icon(Icons.send, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}