import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luckify/core/theme/luckify_colors.dart';
import 'package:luckify/core/theme/luckify_text_styles.dart';
import 'package:luckify/config/di/providers.dart';
import 'package:luckify/domain/entity/fortune_entity.dart';
import 'package:luckify/domain/entity/fortune_message_entity.dart';
import 'package:luckify/domain/entity/message_entity.dart';
import 'package:luckify/domain/enum/message_sender.dart';
import 'package:luckify/presentation/widget/chat_bubble.dart';
import 'package:luckify/presentation/widget/chat_input_field.dart';
import 'package:luckify/core/utils/uuid_generator.dart';

class FortuneChatScreen extends ConsumerStatefulWidget {
  final FortuneEntity selectedFortune;

  const FortuneChatScreen({super.key, required this.selectedFortune});

  @override
  ConsumerState<FortuneChatScreen> createState() => _FortuneChatScreenState();
}

class _FortuneChatScreenState extends ConsumerState<FortuneChatScreen> {
  final List<FortuneMessageEntity> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  late final UuidGenerator _uuidGenerator;
  bool _isLoading = false;

  String _generateId() => _uuidGenerator.generate();

  @override
  void initState() {
    super.initState();
    _uuidGenerator = ref.read(uuidGeneratorProvider);

    _addMessage(
      FortuneMessageEntity(
        id: _generateId(),
        content: widget.selectedFortune.requiresUserInput
            ? '별자리를 입력해주세요! ✨'
            : '오늘의 운세를 알려드릴게요! ✨\n잠시만 기다려주세요...',
        sender: MessageSender.assistant,
        timestamp: DateTime.now(),
        fortune: widget.selectedFortune,
      ),
    );

    if (!widget.selectedFortune.requiresUserInput) {
      _getFortuneReading();
    }
  }

  void _addMessage(FortuneMessageEntity message) {
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

  Future<void> _requestFortune({String? userInput}) async {
    setState(() {
      _isLoading = true;
    });

    bool shouldRemoveMessage = false;

    if (userInput != null) {
      final loadingMessage = FortuneMessageEntity(
        id: _generateId(),
        content: "운세를 확인하고 있습니다.\n잠시만 기다려주세요...",
        sender: MessageSender.assistant,
        timestamp: DateTime.now(),
        fortune: widget.selectedFortune,
      );
      _addMessage(loadingMessage);
      shouldRemoveMessage = true;
    } else {
      shouldRemoveMessage = true;
    }

    try {
      final useCase = ref.read(getFortuneReadingUseCaseProvider);

      final List<MessageEntity> messageHistory = _messages
          .map((msg) => MessageEntity(
        id: msg.id,
        content: msg.content,
        sender: msg.sender,
        timestamp: msg.timestamp,
      ))
          .toList();

      if (shouldRemoveMessage) {
        messageHistory.removeLast();
      }

      final result = await useCase.execute(
        fortune: widget.selectedFortune,
        messages: messageHistory,
        userInput: userInput,
      );

      if (shouldRemoveMessage) {
        setState(() {
          _messages.removeLast();
        });
      }

      _addMessage(result);
    } catch (e) {
      if (shouldRemoveMessage) {
        setState(() {
          _messages.removeLast();
        });
      }

      _addMessage(
        FortuneMessageEntity(
          id: _generateId(),
          content: "운세를 확인하는 중 오류가 발생했습니다. 다시 시도해주세요.",
          sender: MessageSender.assistant,
          timestamp: DateTime.now(),
          fortune: widget.selectedFortune,
        ),
      );

      debugPrint('API 오류: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getFortuneReading() async {
    return _requestFortune();
  }

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final userMessage = FortuneMessageEntity(
      id: _generateId(),
      content: text,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    );
    _addMessage(userMessage);
    _textController.clear();

    return _requestFortune(userInput: text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          widget.selectedFortune.name,
          style: LuckifyTextStyles.appBarTitle,
        ),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
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
            if (widget.selectedFortune.requiresUserInput)
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