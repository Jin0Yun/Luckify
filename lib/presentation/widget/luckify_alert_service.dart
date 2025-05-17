import 'package:flutter/material.dart';
import 'package:luckify/presentation/widget/fly_transition.dart';
import 'package:luckify/presentation/widget/luckify_alert_dialog.dart';

class LuckifyAlertService {
  static final LuckifyAlertService _instance = LuckifyAlertService._internal();
  factory LuckifyAlertService() => _instance;

  LuckifyAlertService._internal();

  Future<bool?> showAlert({
    required BuildContext context,
    required String title,
    required String content,
    String cancelText = '취소',
    String confirmText = '확인',
    bool isDestructive = false,
    bool barrierDismissible = true,
  }) {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: "Dismiss",
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => Container(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FlyTransition(
          animation: animation,
          child: LuckifyAlertDialog(
            title: title,
            content: content,
            cancelText: cancelText,
            confirmText: confirmText,
            isDestructive: isDestructive,
            onCancel: () => Navigator.of(context).pop(false),
            onConfirm: () => Navigator.of(context).pop(true),
          ),
        );
      },
    );
  }
}