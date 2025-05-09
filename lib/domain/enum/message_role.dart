enum MessageRole {
  system,
  user,
  assistant;

  bool get isUser => this == MessageRole.user;
  bool get isAssistant => this == MessageRole.assistant;

  static MessageRole fromString(String value) {
    return MessageRole.values.firstWhere(
          (role) => role.name == value,
      orElse: () => MessageRole.user,
    );
  }
}