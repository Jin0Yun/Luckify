import 'package:flutter/material.dart';
import 'package:luckify/core/theme/luckify_colors.dart';
import 'package:luckify/core/theme/luckify_text_styles.dart';
import 'package:luckify/domain/entity/chat_message.dart';
import 'package:luckify/domain/entity/fortune_entity.dart';
import 'package:luckify/domain/entity/message_sender.dart';
import 'package:luckify/presentation/widget/chat_bubble.dart';
import 'package:luckify/presentation/widget/chat_input_field.dart';

class FortuneChatScreen extends StatefulWidget {
  final FortuneEntity selectedFortune;

  const FortuneChatScreen({super.key, required this.selectedFortune});

  @override
  State<FortuneChatScreen> createState() => _FortuneChatScreenState();
}

class _FortuneChatScreenState extends State<FortuneChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _addMessage(
        ChatMessage(
            content: '별자리를 입력해주세요! ✨',
            sender: MessageSender.bot
        )
    );
  }

  void _addMessage(ChatMessage message) {
    setState(() {
      _messages.add(message);
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _addMessage(ChatMessage(
        content: text,
        sender: MessageSender.user
    ));

    _textController.clear();

    /// API 연동 전
    Future.delayed(const Duration(seconds: 1), () {
      _addMessage(ChatMessage(
          content: "운세를 확인하고 있습니다.\n잠시만 기다려주세요...",
          sender: MessageSender.bot
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.selectedFortune.name, style: LuckifyTextStyles.appBarTitle),
        backgroundColor: LuckifyColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: LuckifyColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GestureDetector(
        onTap: () => _focusNode.unfocus(),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return ChatBubble(
                    message: _messages[index],
                    selectedFortune: widget.selectedFortune,
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ChatInputField(
                controller: _textController,
                focusNode: _focusNode,
                onSend: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
