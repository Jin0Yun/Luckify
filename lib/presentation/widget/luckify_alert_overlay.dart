import 'package:flutter/material.dart';
import 'package:luckify/presentation/widget/fly_transition.dart';
import 'package:luckify/presentation/widget/luckify_alert_dialog.dart';
import 'package:luckify/core/theme/luckify_colors.dart';

class LuckifyAlertOverlay extends StatefulWidget {
  final String title;
  final String content;
  final String cancelText;
  final String confirmText;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;
  final bool isDestructive;

  const LuckifyAlertOverlay({
    super.key,
    required this.title,
    required this.content,
    required this.cancelText,
    required this.confirmText,
    required this.onCancel,
    required this.onConfirm,
    required this.isDestructive,
  });

  @override
  State<LuckifyAlertOverlay> createState() => _LuckifyAlertOverlayState();
}

class _LuckifyAlertOverlayState extends State<LuckifyAlertOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _closeOverlay() {
    _controller.reverse().then((_) {
      widget.onCancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _closeOverlay,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Positioned.fill(
                child: Container(
                  color: LuckifyColors.alertOverlay.withValues(
                    alpha: _animation.value * 0.5,
                  ),
                ),
              );
            },
          ),

          Center(
            child: GestureDetector(
              onTap: () {},
              child: FlyTransition(
                animation: _animation,
                child: LuckifyAlertDialog(
                  title: widget.title,
                  content: widget.content,
                  cancelText: widget.cancelText,
                  confirmText: widget.confirmText,
                  onCancel: () {
                    _controller.reverse().then((_) {
                      widget.onCancel();
                    });
                  },
                  onConfirm: () {
                    _controller.reverse().then((_) {
                      widget.onConfirm();
                    });
                  },
                  isDestructive: widget.isDestructive,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}