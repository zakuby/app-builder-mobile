// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppConfig _$AppConfigFromJson(Map<String, dynamic> json) => _AppConfig(
  appName: json['app_name'] as String?,
  appIcon: json['app_icon'] as String?,
  packageName: json['package_name'] as String?,
  version: json['version'] as String?,
  versionCode: json['version_code'] as String?,
  description: json['description'] as String?,
  platform: json['platform'] as String?,
  buildType: json['build_type'] as String?,
  environment: json['environment'] as String?,
  enableAppBar: json['enable_app_bar'] as bool? ?? false,
  styles: json['styles'] == null
      ? null
      : Styles.fromJson(json['styles'] as Map<String, dynamic>),
  urls: json['urls'] == null
      ? null
      : Urls.fromJson(json['urls'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AppConfigToJson(_AppConfig instance) =>
    <String, dynamic>{
      'app_name': instance.appName,
      'app_icon': instance.appIcon,
      'package_name': instance.packageName,
      'version': instance.version,
      'version_code': instance.versionCode,
      'description': instance.description,
      'platform': instance.platform,
      'build_type': instance.buildType,
      'environment': instance.environment,
      'enable_app_bar': instance.enableAppBar,
      'styles': instance.styles?.toJson(),
      'urls': instance.urls?.toJson(),
    };

_Styles _$StylesFromJson(Map<String, dynamic> json) => _Styles(
  color: json['color'] == null
      ? null
      : StyleColors.fromJson(json['color'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StylesToJson(_Styles instance) => <String, dynamic>{
  'color': instance.color?.toJson(),
};

_StyleColors _$StyleColorsFromJson(Map<String, dynamic> json) => _StyleColors(
  primary: const ColorConverter().fromJson(json['primary'] as String?),
  secondary: const ColorConverter().fromJson(json['secondary'] as String?),
  textColor: const ColorConverter().fromJson(json['text_color'] as String?),
  tabSelectColor: const ColorConverter().fromJson(
    json['tab_select_color'] as String?,
  ),
  tabUnselectColor: const ColorConverter().fromJson(
    json['tab_unselect_color'] as String?,
  ),
);

Map<String, dynamic> _$StyleColorsToJson(
  _StyleColors instance,
) => <String, dynamic>{
  'primary': const ColorConverter().toJson(instance.primary),
  'secondary': const ColorConverter().toJson(instance.secondary),
  'text_color': const ColorConverter().toJson(instance.textColor),
  'tab_select_color': const ColorConverter().toJson(instance.tabSelectColor),
  'tab_unselect_color': const ColorConverter().toJson(
    instance.tabUnselectColor,
  ),
};

_Urls _$UrlsFromJson(Map<String, dynamic> json) => _Urls(
  login: json['login'] as String?,
  signup: json['signup'] as String?,
  tabs: (json['tabs'] as List<dynamic>?)
      ?.map((e) => TabItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UrlsToJson(_Urls instance) => <String, dynamic>{
  'login': instance.login,
  'signup': instance.signup,
  'tabs': instance.tabs?.map((e) => e.toJson()).toList(),
};

_TabItem _$TabItemFromJson(Map<String, dynamic> json) => _TabItem(
  title: json['title'] as String?,
  url: json['url'] as String?,
  icon: json['icon'] as String?,
);

Map<String, dynamic> _$TabItemToJson(_TabItem instance) => <String, dynamic>{
  'title': instance.title,
  'url': instance.url,
  'icon': instance.icon,
};
