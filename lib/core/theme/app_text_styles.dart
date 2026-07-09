import 'package:flutter/material.dart';

abstract final class AppTextStyles {
  static const String fontFamily = 'PlusJakartaSans';
}

/// Regular (400), SemiBold (600), Bold (700), and ExtraBold (800).
abstract final class AppFontWeight {
  static const regular = FontWeight.w400;
  static const semiBold = FontWeight.w600;
  static const bold = FontWeight.w700;
  static const extraBold = FontWeight.w800;
}
