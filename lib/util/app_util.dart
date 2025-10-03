import 'dart:convert';

import 'package:app_builder_mobile/domain/config_model.dart';

class AppUtil {
  static final ConfigModel config = ConfigModel.fromJson(
    jsonDecode(const String.fromEnvironment('config', defaultValue: '{}')),
  );
}
