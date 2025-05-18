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

  static final fortuneTitleSmall = _base.copyWith(
    fontWeight: FontWeight.w700,
    fontSize: 18,
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

  static final navLabel = _base.copyWith(
    fontSize: 12,
    color: LuckifyColors.grey.withValues(alpha: 0.6),
  );

  static final sectionTitle = _base.copyWith(
    fontSize: 17,
    fontWeight: FontWeight.w600,
  );

  static final profileItemText = buttonText.copyWith(
    fontWeight: FontWeight.w200,
    fontSize: 14,
  );

  static final profileItemTextDestructive = buttonText.copyWith(
    fontWeight: FontWeight.w200,
    fontSize: 14,
    color: LuckifyColors.error,
  );

  static final avatarInitial = _base.copyWith(
    fontSize: 40,
    color: LuckifyColors.white,
    fontWeight: FontWeight.bold,
  );

  static final alertTitle = _base.copyWith(
    fontWeight: FontWeight.w500,
    fontSize: 18,
  );

  static final alertContent = _base.copyWith(
    fontWeight: FontWeight.w300,
    fontSize: 13,
    color: LuckifyColors.alertNeutralTextColor,
  );

  static final alertCancelButton = _base.copyWith(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: LuckifyColors.alertCancelButtonText,
  );

  static final alertConfirmButton = _base.copyWith(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: LuckifyColors.white,
  );

  static final fortuneCardSubtitle = _base.copyWith(
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

  static final fortuneCardContent = _base.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w200,
    color: LuckifyColors.grey,
    overflow: TextOverflow.ellipsis,
  );

  static final fortuneCardTimestamp = _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: LuckifyColors.grey,
  );

  static final tabButtonText = _base.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    color: LuckifyColors.grey,
  );

  static final tabButtonTextSelected = _base.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: LuckifyColors.white,
  );

  static final emptyStateTitle = _base.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: LuckifyColors.primary,
  );

  static final emptyStateSubtitle = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: LuckifyColors.grey,
  );
}