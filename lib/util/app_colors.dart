import 'package:app_builder_mobile/util/app_util.dart';
import 'package:flutter/material.dart';

class AppColors {
  static const Color transparent = Color(0x00000000);
  static Color primary = AppUtil.config.styles?.color?.primary ?? Colors.amber;
  static Color textColor =
      AppUtil.config.styles?.color?.textColor ?? Colors.grey;
  static Color secondary =
      AppUtil.config.styles?.color?.secondary ?? Colors.grey;
  static Color textSelectedColor =
      AppUtil.config.styles?.color?.tabSelectColor ?? primary;
  static Color textUnselectedColor =
      AppUtil.config.styles?.color?.tabUnselectColor ?? Color(0xFF616161);
}
