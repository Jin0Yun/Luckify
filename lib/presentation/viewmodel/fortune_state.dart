import 'package:luckify/domain/entity/fortune_message_entity.dart';

class FortuneState {
  final List<FortuneMessageEntity> messages;
  final bool isLoading;
  final String? error;

  const FortuneState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  FortuneState copyWith({
    List<FortuneMessageEntity>? messages,
    bool? isLoading,
    String? error,
  }) {
    return FortuneState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}