import 'package:flutter/foundation.dart';
import 'package:luckify/data/logger/logger.dart';

class ConsoleLogger implements AppLogger {
  @override
  void d(String message, {String? tag}) {
    if (kDebugMode) {
      final tagInfo = tag != null ? '[$tag] ' : '';
      debugPrint('🐾️[DEBUG] $tagInfo$message');
    }
  }

  @override
  void i(String message, {String? tag}) {
    if (kDebugMode) {
      final tagInfo = tag != null ? '[$tag] ' : '';
      debugPrint('ℹ️[INFO] $tagInfo$message');
    }
  }

  @override
  void w(String message, {String? tag}) {
    if (kDebugMode) {
      final tagInfo = tag != null ? '[$tag] ' : '';
      debugPrint('⚠️[WARN] $tagInfo$message');
    }
  }

  @override
  void e(String message, {Object? error, StackTrace? stackTrace, String? tag}) {
    if (kDebugMode) {
      final tagInfo = tag != null ? '[$tag] ' : '';
      debugPrint('🚨 $tagInfo$message');
      if (error != null) debugPrint('🔻 $error');
      if (stackTrace != null) debugPrint('$stackTrace');
    }
  }
}