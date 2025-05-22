import 'package:flutter/material.dart';
import 'package:luckify/presentation/widget/luckify_alert_dialog.dart';

extension LuckifyDialogExtension on BuildContext {
  Future<bool?> showLuckifyDialog({
    required String title,
    required String content,
    String cancelText = '취소',
    String confirmText = '확인',
    bool isDestructive = false,
    bool barrierDismissible = true,
  }) {
    return showDialog<bool>(
      context: this,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder:
          (context) => LuckifyAlertDialog(
            title: title,
            content: content,
            cancelText: cancelText,
            confirmText: confirmText,
            onCancel: () => Navigator.pop(context, false),
            onConfirm: () => Navigator.pop(context, true),
            isDestructive: isDestructive,
          ),
    );
  }
}