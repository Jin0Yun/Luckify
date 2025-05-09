enum MessageSender {
  user,
  assistant;

  bool get isUser => this == MessageSender.user;
  bool get isAssistant => this == MessageSender.assistant;
}