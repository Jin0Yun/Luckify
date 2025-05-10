abstract class AppLogger {
  void d(String message, {String? tag});
  void i(String message, {String? tag});
  void w(String message, {String? tag});
  void e(String message, {Object? error, StackTrace? stackTrace, String? tag});
}