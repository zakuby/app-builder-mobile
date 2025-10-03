// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'config_model.freezed.dart';
part 'config_model.g.dart';

@freezed
abstract class ConfigModel with _$ConfigModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory ConfigModel({
    String? appName,
    String? appIcon,
    Styles? styles,
    Urls? urls,
  }) = _AppConfig;

  factory ConfigModel.fromJson(Map<String, dynamic> json) =>
      _$ConfigModelFromJson(json);
}

@freezed
abstract class Styles with _$Styles {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory Styles({StyleColors? color}) = _Styles;

  factory Styles.fromJson(Map<String, dynamic> json) => _$StylesFromJson(json);
}

@freezed
abstract class StyleColors with _$StyleColors {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory StyleColors({
    @ColorConverter() Color? primary,
    @ColorConverter() Color? secondary,
    @ColorConverter() Color? textColor,
    @ColorConverter() Color? tabSelectColor,
    @ColorConverter() Color? tabUnselectColor,
  }) = _StyleColors;

  factory StyleColors.fromJson(Map<String, dynamic> json) =>
      _$StyleColorsFromJson(json);
}

@freezed
abstract class Urls with _$Urls {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory Urls({String? login, String? signup, List<TabItem>? tabs}) =
      _Urls;

  factory Urls.fromJson(Map<String, dynamic> json) => _$UrlsFromJson(json);
}

@freezed
abstract class TabItem with _$TabItem {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory TabItem({String? title, String? url}) = _TabItem;

  factory TabItem.fromJson(Map<String, dynamic> json) =>
      _$TabItemFromJson(json);
}

/// Converter for hex string <-> Color
class ColorConverter implements JsonConverter<Color?, String?> {
  const ColorConverter();

  @override
  Color? fromJson(String? json) {
    if (json == null || json.isEmpty) return null;
    final hex = json.replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  String? toJson(Color? object) {
    if (object == null) return null;
    return '#${object.value.toRadixString(16).substring(2).toUpperCase()}';
  }
}
