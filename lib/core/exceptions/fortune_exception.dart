class FortuneException implements Exception {
  final String message;
  final Exception? cause;

  const FortuneException(this.message, [this.cause]);

  @override
  String toString() => 'FortuneException: $message ${cause != null ? '(Caused by: $cause)' : ''}';
}