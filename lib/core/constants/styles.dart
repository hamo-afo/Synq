import 'package:flutter/material.dart';
import 'colors.dart';

class AppStyles {
  static const heading1 = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const heading2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static const bodyText = TextStyle(fontSize: 16, color: AppColors.textDark);

  static const caption = TextStyle(fontSize: 13, color: AppColors.textLight);
}
