import 'package:luckify/core/constants/message_constants.dart';
import 'package:luckify/domain/entity/fortune_entity.dart';
import 'package:luckify/domain/entity/fortune_history_entity.dart';
import 'package:luckify/domain/entity/fortune_message_entity.dart';
import 'package:luckify/domain/entity/message_entity.dart';
import 'package:luckify/domain/enum/message_sender.dart';
import 'package:luckify/domain/enum/fortune_type.dart';
import 'package:luckify/domain/usecase/get_fortune_reading_usecase.dart';
import 'package:luckify/core/utils/uuid_generator.dart';
import 'package:luckify/core/constants/zodiac_constants.dart';
import 'package:luckify/domain/repository/fortune_history_repository.dart';
import 'package:luckify/presentation/viewmodel/base_view_model.dart';
import 'package:luckify/presentation/viewmodel/fortune_message_state.dart';

class FortuneMessageViewModel extends BaseViewModel<FortuneMessageState> {
  final FortuneEntity selectedFortune;
  final GetFortuneReadingUseCase _getFortuneReadingUseCase;
  final UuidGenerator _uuidGenerator;
  final FortuneHistoryRepository _historyRepository;

  FortuneMessageViewModel({
    required this.selectedFortune,
    required GetFortuneReadingUseCase getFortuneReadingUseCase,
    required UuidGenerator uuidGenerator,
    required FortuneHistoryRepository historyRepository,
  }) : _getFortuneReadingUseCase = getFortuneReadingUseCase,
       _uuidGenerator = uuidGenerator,
       _historyRepository = historyRepository,
       super(const FortuneMessageState()) {
    _initialize();
  }

  void _initialize() {
    if (selectedFortune.requiresUserInput) {
      final initialMessage = FortuneMessageEntity(
        id: _uuidGenerator.generate(),
        content: MessageConstants.zodiacPrompt,
        sender: MessageSender.assistant,
        timestamp: DateTime.now(),
        fortune: selectedFortune,
      );
      addMessage(initialMessage);
    } else {
      _requestFortuneDirectly();
    }
  }

  @override
  FortuneMessageState setLoadingState(bool isLoading) {
    return state.copyWith(isLoading: isLoading);
  }

  @override
  FortuneMessageState setErrorState(String? error) {
    return state.copyWith(error: error);
  }

  @override
  FortuneMessageState clearErrorState() {
    return state.copyWith(error: null);
  }

  void addMessage(FortuneMessageEntity message) {
    final updatedMessages = [...state.messages, message];
    state = state.copyWith(messages: updatedMessages);
  }

  void removeMessage(String messageId) {
    if (!mounted) return;
    final updatedMessages =
        state.messages.where((msg) => msg.id != messageId).toList();

    state = state.copyWith(messages: updatedMessages);
  }

  void _handleError(String loadingMessageId) {
    removeMessage(loadingMessageId);

    final errorMessage = FortuneMessageEntity(
      id: _uuidGenerator.generate(),
      content: MessageConstants.errorMessage,
      sender: MessageSender.assistant,
      timestamp: DateTime.now(),
      fortune: selectedFortune,
    );
    addMessage(errorMessage);
  }

  Future<void> _saveToHistory(FortuneMessageEntity message) async {
    if (!message.content.contains(MessageConstants.waitingText) &&
        message.sender == MessageSender.assistant) {
      await _historyRepository.saveFortuneHistory(
        FortuneHistoryEntity(
          id: _uuidGenerator.generate(),
          fortune: selectedFortune,
          content: message.content,
          timestamp: DateTime.now(),
          userInput: message.userInput,
        ),
      );
    }
  }

  Future<void> _requestWithLoading(
    Future<FortuneMessageEntity> Function() action,
    String loadingContent,
  ) async {
    final loadingMessage = FortuneMessageEntity(
      id: _uuidGenerator.generate(),
      content: loadingContent,
      sender: MessageSender.assistant,
      timestamp: DateTime.now(),
      fortune: selectedFortune,
    );
    addMessage(loadingMessage);

    try {
      final result = await runWithLoading(action);
      if (!mounted) return;
      removeMessage(loadingMessage.id);
      addMessage(result);
      await _saveToHistory(result);
    } catch (e) {
      if (!mounted) return;
      _handleError(loadingMessage.id);
    }
  }

  Future<void> _requestFortuneDirectly() async {
    await _requestWithLoading(
      () => _getFortuneReadingUseCase.execute(
        fortune: selectedFortune,
        messages: [],
        userInput: null,
      ),
      MessageConstants.todayFortuneIntro,
    );
  }

  Future<void> requestFortune({String? userInput}) async {
    await _requestWithLoading(() {
      final messageHistory =
          state.messages
              .where(
                (msg) => !msg.content.contains(MessageConstants.waitingText),
              )
              .map(
                (msg) => MessageEntity(
                  id: msg.id,
                  content: msg.content,
                  sender: msg.sender,
                  timestamp: msg.timestamp,
                ),
              )
              .toList();

      return _getFortuneReadingUseCase.execute(
        fortune: selectedFortune,
        messages: messageHistory,
        userInput: userInput,
      );
    }, MessageConstants.checkingFortune);
  }

  Future<void> getFortuneReading() async {
    state = state.copyWith(messages: []);

    if (selectedFortune.requiresUserInput) {
      final initialMessage = FortuneMessageEntity(
        id: _uuidGenerator.generate(),
        content: MessageConstants.zodiacPrompt,
        sender: MessageSender.assistant,
        timestamp: DateTime.now(),
        fortune: selectedFortune,
      );
      addMessage(initialMessage);
    } else {
      return _requestFortuneDirectly();
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = FortuneMessageEntity(
      id: _uuidGenerator.generate(),
      content: text,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    );
    addMessage(userMessage);

    if (selectedFortune.type == FortuneType.zodiacFortune) {
      final zodiac = ZodiacConstants.findZodiac(text);

      if (zodiac == null) {
        final errorMessage = FortuneMessageEntity(
          id: _uuidGenerator.generate(),
          content: MessageConstants.invalidZodiacMessage,
          sender: MessageSender.assistant,
          timestamp: DateTime.now(),
          fortune: selectedFortune,
        );
        addMessage(errorMessage);
        return;
      }

      return requestFortune(userInput: zodiac);
    }

    return requestFortune(userInput: text);
  }

  List<FortuneMessageEntity> get messages => state.messages;
}