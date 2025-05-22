import 'package:flutter/material.dart';
import 'package:luckify/core/theme/luckify_colors.dart';
import 'package:luckify/domain/enum/fortune_type.dart';

class FortuneEntity {
  final int id;
  final String name;
  final FortuneType type;
  final String iconPath;
  final Color primaryColor;

  const FortuneEntity({
    required this.id,
    required this.name,
    required this.type,
    this.iconPath = '',
    this.primaryColor = LuckifyColors.primary,
  });

  bool get requiresUserInput => type == FortuneType.zodiacFortune;
}