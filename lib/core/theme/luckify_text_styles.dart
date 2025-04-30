import 'package:flutter/material.dart';
import 'package:luckify/core/theme/luckify_colors.dart';

class LuckifyTextStyles {
  static const fortuneTitle = TextStyle(
    fontFamily: 'Moneygraphy',
    fontWeight: FontWeight.w700,
    fontSize: 23,
    color: LuckifyColors.primary,
  );

  static const fortuneHint = TextStyle(
    fontFamily: 'Moneygraphy',
    fontWeight: FontWeight.w200,
    fontSize: 13,
    color: LuckifyColors.grey,
  );

  static const buttonText = TextStyle(
    fontFamily: 'Moneygraphy',
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: LuckifyColors.black,
  );

  static const appBarTitle = TextStyle(
    fontFamily: 'Moneygraphy',
    fontWeight: FontWeight.w500,
    fontSize: 18,
    color: LuckifyColors.black,
  );

  static const chatInputHint = TextStyle(
    fontFamily: 'Moneygraphy',
    fontWeight: FontWeight.w300,
    fontSize: 14,
    color: LuckifyColors.grey,
  );
}