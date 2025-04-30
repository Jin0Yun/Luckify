import 'package:flutter/material.dart';
import 'package:luckify/core/theme/luckify_colors.dart';

class LuckifyTextStyles {
  static const _base = TextStyle(
    fontFamily: 'Moneygraphy',
    color: LuckifyColors.black,
  );

  static final fortuneTitle = _base.copyWith(
    fontWeight: FontWeight.w700,
    fontSize: 23,
    color: LuckifyColors.primary,
  );

  static final fortuneHint = _base.copyWith(
    fontWeight: FontWeight.w200,
    fontSize: 13,
    color: LuckifyColors.grey,
  );

  static final buttonText = _base.copyWith(
    fontWeight: FontWeight.w500,
    fontSize: 16,
  );

  static final appBarTitle = _base.copyWith(
    fontWeight: FontWeight.w500,
    fontSize: 18,
  );

  static final chatInputHint = _base.copyWith(
    fontWeight: FontWeight.w300,
    fontSize: 14,
    color: LuckifyColors.grey,
  );
}