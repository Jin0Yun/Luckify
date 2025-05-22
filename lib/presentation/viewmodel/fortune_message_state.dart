import 'package:luckify/domain/entity/fortune_message_entity.dart';
import 'package:luckify/presentation/viewmodel/base_state.dart';

class FortuneMessageState implements BaseState {
  final List<FortuneMessageEntity> messages;
  @override
  final bool isLoading;
  @override
  final String? error;
  final bool isRequestInProgress;

  const FortuneMessageState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
    this.isRequestInProgress = false,
  });

  FortuneMessageState copyWith({
    List<FortuneMessageEntity>? messages,
    bool? isLoading,
    String? error,
    bool? isRequestInProgress,
  }) {
    return FortuneMessageState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isRequestInProgress: isRequestInProgress ?? this.isRequestInProgress,
    );
  }
}