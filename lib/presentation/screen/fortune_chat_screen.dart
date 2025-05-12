import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luckify/config/di/providers.dart';
import 'package:luckify/core/theme/luckify_colors.dart';
import 'package:luckify/core/theme/luckify_text_styles.dart';
import 'package:luckify/domain/entity/fortune_entity.dart';
import 'package:luckify/domain/entity/fortune_message_entity.dart';
import 'package:luckify/presentation/widget/chat_bubble.dart';
import 'package:luckify/presentation/widget/chat_input_field.dart';
import 'package:luckify/presentation/viewmodel/fortune_viewmodel.dart';

class FortuneChatScreen extends ConsumerStatefulWidget {
  final FortuneEntity selectedFortune;

  const FortuneChatScreen({super.key, required this.selectedFortune});

  @override
  ConsumerState<FortuneChatScreen> createState() => _FortuneChatScreenState();
}

class _FortuneChatScreenState extends ConsumerState<FortuneChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  late FortuneViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel = ref.read(
        fortuneViewModelProvider(widget.selectedFortune).notifier,
      );
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;

    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _handleSendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    await _viewModel.sendMessage(text);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fortuneViewModelProvider(widget.selectedFortune));

    ref.listen(fortuneViewModelProvider(widget.selectedFortune), (
        previous,
        next,
        ) {
      if (previous?.messages.length != next.messages.length) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _buildAppBar(),
      body: GestureDetector(
        onTap: () => _focusNode.unfocus(),
        child: Column(
          children: [
            _buildMessageList(state.messages),
            const SizedBox(height: 12),
            if (widget.selectedFortune.requiresUserInput) _buildInputField(state.isLoading),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
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
    );
  }

  Widget _buildMessageList(List<FortuneMessageEntity> messages) {
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return ChatBubble(
            message: messages[index],
            selectedFortune: widget.selectedFortune,
          );
        },
      ),
    );
  }

  Widget _buildInputField(bool isLoading) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ChatInputField(
        controller: _textController,
        focusNode: _focusNode,
        onSend: _handleSendMessage,
        isLoading: isLoading,
      ),
    );
  }
}