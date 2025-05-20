import 'package:luckify/domain/entity/fortune_message_entity.dart';
import 'package:luckify/presentation/viewmodel/base_state.dart';

class FortuneState implements BaseState {
  final List<FortuneMessageEntity> messages;
  @override
  final bool isLoading;
  @override
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