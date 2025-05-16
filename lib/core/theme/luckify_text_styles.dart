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

  static final fortuneSubtitle = _base.copyWith(
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

  static final inputHintText = _base.copyWith(
    fontWeight: FontWeight.w300,
    fontSize: 14,
    color: LuckifyColors.grey,
  );

  static final messageBotText = _base.copyWith(
    fontWeight: FontWeight.w300,
    fontSize: 14,
    color: LuckifyColors.white,
  );

  static final messageUserText = _base.copyWith(
    fontWeight: FontWeight.w300,
    fontSize: 14,
    color: LuckifyColors.primary,
  );

  static final timestampText = _base.copyWith(
    fontWeight: FontWeight.w300,
    fontSize: 11,
    color: LuckifyColors.grey,
  );

  static final loginTitle = _base.copyWith(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: LuckifyColors.white,
  );

  static final loginSubtitle = _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w300,
    color: LuckifyColors.white,
  );

  static final errorText = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.red[700],
  );
}