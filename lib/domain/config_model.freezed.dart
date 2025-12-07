// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'config_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
ConfigModel _$ConfigModelFromJson(
  Map<String, dynamic> json
) {
    return _AppConfig.fromJson(
      json
    );
}

/// @nodoc
mixin _$ConfigModel {

 String? get appName; String? get appIcon; String? get packageName; String? get version; String? get versionCode; String? get description; String? get platform; String? get buildType; String? get environment; bool? get enableAppBar; Styles? get styles; Urls? get urls;
/// Create a copy of ConfigModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConfigModelCopyWith<ConfigModel> get copyWith => _$ConfigModelCopyWithImpl<ConfigModel>(this as ConfigModel, _$identity);

  /// Serializes this ConfigModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConfigModel&&(identical(other.appName, appName) || other.appName == appName)&&(identical(other.appIcon, appIcon) || other.appIcon == appIcon)&&(identical(other.packageName, packageName) || other.packageName == packageName)&&(identical(other.version, version) || other.version == version)&&(identical(other.versionCode, versionCode) || other.versionCode == versionCode)&&(identical(other.description, description) || other.description == description)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.buildType, buildType) || other.buildType == buildType)&&(identical(other.environment, environment) || other.environment == environment)&&(identical(other.enableAppBar, enableAppBar) || other.enableAppBar == enableAppBar)&&(identical(other.styles, styles) || other.styles == styles)&&(identical(other.urls, urls) || other.urls == urls));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,appName,appIcon,packageName,version,versionCode,description,platform,buildType,environment,enableAppBar,styles,urls);

@override
String toString() {
  return 'ConfigModel(appName: $appName, appIcon: $appIcon, packageName: $packageName, version: $version, versionCode: $versionCode, description: $description, platform: $platform, buildType: $buildType, environment: $environment, enableAppBar: $enableAppBar, styles: $styles, urls: $urls)';
}


}

/// @nodoc
abstract mixin class $ConfigModelCopyWith<$Res>  {
  factory $ConfigModelCopyWith(ConfigModel value, $Res Function(ConfigModel) _then) = _$ConfigModelCopyWithImpl;
@useResult
$Res call({
 String? appName, String? appIcon, String? packageName, String? version, String? versionCode, String? description, String? platform, String? buildType, String? environment, bool? enableAppBar, Styles? styles, Urls? urls
});


$StylesCopyWith<$Res>? get styles;$UrlsCopyWith<$Res>? get urls;

}
/// @nodoc
class _$ConfigModelCopyWithImpl<$Res>
    implements $ConfigModelCopyWith<$Res> {
  _$ConfigModelCopyWithImpl(this._self, this._then);

  final ConfigModel _self;
  final $Res Function(ConfigModel) _then;

/// Create a copy of ConfigModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? appName = freezed,Object? appIcon = freezed,Object? packageName = freezed,Object? version = freezed,Object? versionCode = freezed,Object? description = freezed,Object? platform = freezed,Object? buildType = freezed,Object? environment = freezed,Object? enableAppBar = freezed,Object? styles = freezed,Object? urls = freezed,}) {
  return _then(_self.copyWith(
appName: freezed == appName ? _self.appName : appName // ignore: cast_nullable_to_non_nullable
as String?,appIcon: freezed == appIcon ? _self.appIcon : appIcon // ignore: cast_nullable_to_non_nullable
as String?,packageName: freezed == packageName ? _self.packageName : packageName // ignore: cast_nullable_to_non_nullable
as String?,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,versionCode: freezed == versionCode ? _self.versionCode : versionCode // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String?,buildType: freezed == buildType ? _self.buildType : buildType // ignore: cast_nullable_to_non_nullable
as String?,environment: freezed == environment ? _self.environment : environment // ignore: cast_nullable_to_non_nullable
as String?,enableAppBar: freezed == enableAppBar ? _self.enableAppBar : enableAppBar // ignore: cast_nullable_to_non_nullable
as bool?,styles: freezed == styles ? _self.styles : styles // ignore: cast_nullable_to_non_nullable
as Styles?,urls: freezed == urls ? _self.urls : urls // ignore: cast_nullable_to_non_nullable
as Urls?,
  ));
}
/// Create a copy of ConfigModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StylesCopyWith<$Res>? get styles {
    if (_self.styles == null) {
    return null;
  }

  return $StylesCopyWith<$Res>(_self.styles!, (value) {
    return _then(_self.copyWith(styles: value));
  });
}/// Create a copy of ConfigModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UrlsCopyWith<$Res>? get urls {
    if (_self.urls == null) {
    return null;
  }

  return $UrlsCopyWith<$Res>(_self.urls!, (value) {
    return _then(_self.copyWith(urls: value));
  });
}
}


/// Adds pattern-matching-related methods to [ConfigModel].
extension ConfigModelPatterns on ConfigModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppConfig() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppConfig value)  $default,){
final _that = this;
switch (_that) {
case _AppConfig():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppConfig value)?  $default,){
final _that = this;
switch (_that) {
case _AppConfig() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? appName,  String? appIcon,  String? packageName,  String? version,  String? versionCode,  String? description,  String? platform,  String? buildType,  String? environment,  bool? enableAppBar,  Styles? styles,  Urls? urls)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppConfig() when $default != null:
return $default(_that.appName,_that.appIcon,_that.packageName,_that.version,_that.versionCode,_that.description,_that.platform,_that.buildType,_that.environment,_that.enableAppBar,_that.styles,_that.urls);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? appName,  String? appIcon,  String? packageName,  String? version,  String? versionCode,  String? description,  String? platform,  String? buildType,  String? environment,  bool? enableAppBar,  Styles? styles,  Urls? urls)  $default,) {final _that = this;
switch (_that) {
case _AppConfig():
return $default(_that.appName,_that.appIcon,_that.packageName,_that.version,_that.versionCode,_that.description,_that.platform,_that.buildType,_that.environment,_that.enableAppBar,_that.styles,_that.urls);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? appName,  String? appIcon,  String? packageName,  String? version,  String? versionCode,  String? description,  String? platform,  String? buildType,  String? environment,  bool? enableAppBar,  Styles? styles,  Urls? urls)?  $default,) {final _that = this;
switch (_that) {
case _AppConfig() when $default != null:
return $default(_that.appName,_that.appIcon,_that.packageName,_that.version,_that.versionCode,_that.description,_that.platform,_that.buildType,_that.environment,_that.enableAppBar,_that.styles,_that.urls);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _AppConfig implements ConfigModel {
  const _AppConfig({this.appName, this.appIcon, this.packageName, this.version, this.versionCode, this.description, this.platform, this.buildType, this.environment, this.enableAppBar = false, this.styles, this.urls});
  factory _AppConfig.fromJson(Map<String, dynamic> json) => _$AppConfigFromJson(json);

@override final  String? appName;
@override final  String? appIcon;
@override final  String? packageName;
@override final  String? version;
@override final  String? versionCode;
@override final  String? description;
@override final  String? platform;
@override final  String? buildType;
@override final  String? environment;
@override@JsonKey() final  bool? enableAppBar;
@override final  Styles? styles;
@override final  Urls? urls;

/// Create a copy of ConfigModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppConfigCopyWith<_AppConfig> get copyWith => __$AppConfigCopyWithImpl<_AppConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppConfig&&(identical(other.appName, appName) || other.appName == appName)&&(identical(other.appIcon, appIcon) || other.appIcon == appIcon)&&(identical(other.packageName, packageName) || other.packageName == packageName)&&(identical(other.version, version) || other.version == version)&&(identical(other.versionCode, versionCode) || other.versionCode == versionCode)&&(identical(other.description, description) || other.description == description)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.buildType, buildType) || other.buildType == buildType)&&(identical(other.environment, environment) || other.environment == environment)&&(identical(other.enableAppBar, enableAppBar) || other.enableAppBar == enableAppBar)&&(identical(other.styles, styles) || other.styles == styles)&&(identical(other.urls, urls) || other.urls == urls));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,appName,appIcon,packageName,version,versionCode,description,platform,buildType,environment,enableAppBar,styles,urls);

@override
String toString() {
  return 'ConfigModel(appName: $appName, appIcon: $appIcon, packageName: $packageName, version: $version, versionCode: $versionCode, description: $description, platform: $platform, buildType: $buildType, environment: $environment, enableAppBar: $enableAppBar, styles: $styles, urls: $urls)';
}


}

/// @nodoc
abstract mixin class _$AppConfigCopyWith<$Res> implements $ConfigModelCopyWith<$Res> {
  factory _$AppConfigCopyWith(_AppConfig value, $Res Function(_AppConfig) _then) = __$AppConfigCopyWithImpl;
@override @useResult
$Res call({
 String? appName, String? appIcon, String? packageName, String? version, String? versionCode, String? description, String? platform, String? buildType, String? environment, bool? enableAppBar, Styles? styles, Urls? urls
});


@override $StylesCopyWith<$Res>? get styles;@override $UrlsCopyWith<$Res>? get urls;

}
/// @nodoc
class __$AppConfigCopyWithImpl<$Res>
    implements _$AppConfigCopyWith<$Res> {
  __$AppConfigCopyWithImpl(this._self, this._then);

  final _AppConfig _self;
  final $Res Function(_AppConfig) _then;

/// Create a copy of ConfigModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? appName = freezed,Object? appIcon = freezed,Object? packageName = freezed,Object? version = freezed,Object? versionCode = freezed,Object? description = freezed,Object? platform = freezed,Object? buildType = freezed,Object? environment = freezed,Object? enableAppBar = freezed,Object? styles = freezed,Object? urls = freezed,}) {
  return _then(_AppConfig(
appName: freezed == appName ? _self.appName : appName // ignore: cast_nullable_to_non_nullable
as String?,appIcon: freezed == appIcon ? _self.appIcon : appIcon // ignore: cast_nullable_to_non_nullable
as String?,packageName: freezed == packageName ? _self.packageName : packageName // ignore: cast_nullable_to_non_nullable
as String?,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,versionCode: freezed == versionCode ? _self.versionCode : versionCode // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String?,buildType: freezed == buildType ? _self.buildType : buildType // ignore: cast_nullable_to_non_nullable
as String?,environment: freezed == environment ? _self.environment : environment // ignore: cast_nullable_to_non_nullable
as String?,enableAppBar: freezed == enableAppBar ? _self.enableAppBar : enableAppBar // ignore: cast_nullable_to_non_nullable
as bool?,styles: freezed == styles ? _self.styles : styles // ignore: cast_nullable_to_non_nullable
as Styles?,urls: freezed == urls ? _self.urls : urls // ignore: cast_nullable_to_non_nullable
as Urls?,
  ));
}

/// Create a copy of ConfigModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StylesCopyWith<$Res>? get styles {
    if (_self.styles == null) {
    return null;
  }

  return $StylesCopyWith<$Res>(_self.styles!, (value) {
    return _then(_self.copyWith(styles: value));
  });
}/// Create a copy of ConfigModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UrlsCopyWith<$Res>? get urls {
    if (_self.urls == null) {
    return null;
  }

  return $UrlsCopyWith<$Res>(_self.urls!, (value) {
    return _then(_self.copyWith(urls: value));
  });
}
}


/// @nodoc
mixin _$Styles {

 StyleColors? get color;
/// Create a copy of Styles
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StylesCopyWith<Styles> get copyWith => _$StylesCopyWithImpl<Styles>(this as Styles, _$identity);

  /// Serializes this Styles to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Styles&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,color);

@override
String toString() {
  return 'Styles(color: $color)';
}


}

/// @nodoc
abstract mixin class $StylesCopyWith<$Res>  {
  factory $StylesCopyWith(Styles value, $Res Function(Styles) _then) = _$StylesCopyWithImpl;
@useResult
$Res call({
 StyleColors? color
});


$StyleColorsCopyWith<$Res>? get color;

}
/// @nodoc
class _$StylesCopyWithImpl<$Res>
    implements $StylesCopyWith<$Res> {
  _$StylesCopyWithImpl(this._self, this._then);

  final Styles _self;
  final $Res Function(Styles) _then;

/// Create a copy of Styles
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? color = freezed,}) {
  return _then(_self.copyWith(
color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as StyleColors?,
  ));
}
/// Create a copy of Styles
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StyleColorsCopyWith<$Res>? get color {
    if (_self.color == null) {
    return null;
  }

  return $StyleColorsCopyWith<$Res>(_self.color!, (value) {
    return _then(_self.copyWith(color: value));
  });
}
}


/// Adds pattern-matching-related methods to [Styles].
extension StylesPatterns on Styles {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Styles value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Styles() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Styles value)  $default,){
final _that = this;
switch (_that) {
case _Styles():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Styles value)?  $default,){
final _that = this;
switch (_that) {
case _Styles() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StyleColors? color)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Styles() when $default != null:
return $default(_that.color);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StyleColors? color)  $default,) {final _that = this;
switch (_that) {
case _Styles():
return $default(_that.color);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StyleColors? color)?  $default,) {final _that = this;
switch (_that) {
case _Styles() when $default != null:
return $default(_that.color);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _Styles implements Styles {
  const _Styles({this.color});
  factory _Styles.fromJson(Map<String, dynamic> json) => _$StylesFromJson(json);

@override final  StyleColors? color;

/// Create a copy of Styles
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StylesCopyWith<_Styles> get copyWith => __$StylesCopyWithImpl<_Styles>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StylesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Styles&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,color);

@override
String toString() {
  return 'Styles(color: $color)';
}


}

/// @nodoc
abstract mixin class _$StylesCopyWith<$Res> implements $StylesCopyWith<$Res> {
  factory _$StylesCopyWith(_Styles value, $Res Function(_Styles) _then) = __$StylesCopyWithImpl;
@override @useResult
$Res call({
 StyleColors? color
});


@override $StyleColorsCopyWith<$Res>? get color;

}
/// @nodoc
class __$StylesCopyWithImpl<$Res>
    implements _$StylesCopyWith<$Res> {
  __$StylesCopyWithImpl(this._self, this._then);

  final _Styles _self;
  final $Res Function(_Styles) _then;

/// Create a copy of Styles
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? color = freezed,}) {
  return _then(_Styles(
color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as StyleColors?,
  ));
}

/// Create a copy of Styles
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StyleColorsCopyWith<$Res>? get color {
    if (_self.color == null) {
    return null;
  }

  return $StyleColorsCopyWith<$Res>(_self.color!, (value) {
    return _then(_self.copyWith(color: value));
  });
}
}


/// @nodoc
mixin _$StyleColors {

@ColorConverter() Color? get primary;@ColorConverter() Color? get secondary;@ColorConverter() Color? get textColor;@ColorConverter() Color? get tabSelectColor;@ColorConverter() Color? get tabUnselectColor;
/// Create a copy of StyleColors
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StyleColorsCopyWith<StyleColors> get copyWith => _$StyleColorsCopyWithImpl<StyleColors>(this as StyleColors, _$identity);

  /// Serializes this StyleColors to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StyleColors&&(identical(other.primary, primary) || other.primary == primary)&&(identical(other.secondary, secondary) || other.secondary == secondary)&&(identical(other.textColor, textColor) || other.textColor == textColor)&&(identical(other.tabSelectColor, tabSelectColor) || other.tabSelectColor == tabSelectColor)&&(identical(other.tabUnselectColor, tabUnselectColor) || other.tabUnselectColor == tabUnselectColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,primary,secondary,textColor,tabSelectColor,tabUnselectColor);

@override
String toString() {
  return 'StyleColors(primary: $primary, secondary: $secondary, textColor: $textColor, tabSelectColor: $tabSelectColor, tabUnselectColor: $tabUnselectColor)';
}


}

/// @nodoc
abstract mixin class $StyleColorsCopyWith<$Res>  {
  factory $StyleColorsCopyWith(StyleColors value, $Res Function(StyleColors) _then) = _$StyleColorsCopyWithImpl;
@useResult
$Res call({
@ColorConverter() Color? primary,@ColorConverter() Color? secondary,@ColorConverter() Color? textColor,@ColorConverter() Color? tabSelectColor,@ColorConverter() Color? tabUnselectColor
});




}
/// @nodoc
class _$StyleColorsCopyWithImpl<$Res>
    implements $StyleColorsCopyWith<$Res> {
  _$StyleColorsCopyWithImpl(this._self, this._then);

  final StyleColors _self;
  final $Res Function(StyleColors) _then;

/// Create a copy of StyleColors
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? primary = freezed,Object? secondary = freezed,Object? textColor = freezed,Object? tabSelectColor = freezed,Object? tabUnselectColor = freezed,}) {
  return _then(_self.copyWith(
primary: freezed == primary ? _self.primary : primary // ignore: cast_nullable_to_non_nullable
as Color?,secondary: freezed == secondary ? _self.secondary : secondary // ignore: cast_nullable_to_non_nullable
as Color?,textColor: freezed == textColor ? _self.textColor : textColor // ignore: cast_nullable_to_non_nullable
as Color?,tabSelectColor: freezed == tabSelectColor ? _self.tabSelectColor : tabSelectColor // ignore: cast_nullable_to_non_nullable
as Color?,tabUnselectColor: freezed == tabUnselectColor ? _self.tabUnselectColor : tabUnselectColor // ignore: cast_nullable_to_non_nullable
as Color?,
  ));
}

}


/// Adds pattern-matching-related methods to [StyleColors].
extension StyleColorsPatterns on StyleColors {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StyleColors value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StyleColors() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StyleColors value)  $default,){
final _that = this;
switch (_that) {
case _StyleColors():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StyleColors value)?  $default,){
final _that = this;
switch (_that) {
case _StyleColors() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@ColorConverter()  Color? primary, @ColorConverter()  Color? secondary, @ColorConverter()  Color? textColor, @ColorConverter()  Color? tabSelectColor, @ColorConverter()  Color? tabUnselectColor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StyleColors() when $default != null:
return $default(_that.primary,_that.secondary,_that.textColor,_that.tabSelectColor,_that.tabUnselectColor);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@ColorConverter()  Color? primary, @ColorConverter()  Color? secondary, @ColorConverter()  Color? textColor, @ColorConverter()  Color? tabSelectColor, @ColorConverter()  Color? tabUnselectColor)  $default,) {final _that = this;
switch (_that) {
case _StyleColors():
return $default(_that.primary,_that.secondary,_that.textColor,_that.tabSelectColor,_that.tabUnselectColor);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@ColorConverter()  Color? primary, @ColorConverter()  Color? secondary, @ColorConverter()  Color? textColor, @ColorConverter()  Color? tabSelectColor, @ColorConverter()  Color? tabUnselectColor)?  $default,) {final _that = this;
switch (_that) {
case _StyleColors() when $default != null:
return $default(_that.primary,_that.secondary,_that.textColor,_that.tabSelectColor,_that.tabUnselectColor);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _StyleColors implements StyleColors {
  const _StyleColors({@ColorConverter() this.primary, @ColorConverter() this.secondary, @ColorConverter() this.textColor, @ColorConverter() this.tabSelectColor, @ColorConverter() this.tabUnselectColor});
  factory _StyleColors.fromJson(Map<String, dynamic> json) => _$StyleColorsFromJson(json);

@override@ColorConverter() final  Color? primary;
@override@ColorConverter() final  Color? secondary;
@override@ColorConverter() final  Color? textColor;
@override@ColorConverter() final  Color? tabSelectColor;
@override@ColorConverter() final  Color? tabUnselectColor;

/// Create a copy of StyleColors
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StyleColorsCopyWith<_StyleColors> get copyWith => __$StyleColorsCopyWithImpl<_StyleColors>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StyleColorsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StyleColors&&(identical(other.primary, primary) || other.primary == primary)&&(identical(other.secondary, secondary) || other.secondary == secondary)&&(identical(other.textColor, textColor) || other.textColor == textColor)&&(identical(other.tabSelectColor, tabSelectColor) || other.tabSelectColor == tabSelectColor)&&(identical(other.tabUnselectColor, tabUnselectColor) || other.tabUnselectColor == tabUnselectColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,primary,secondary,textColor,tabSelectColor,tabUnselectColor);

@override
String toString() {
  return 'StyleColors(primary: $primary, secondary: $secondary, textColor: $textColor, tabSelectColor: $tabSelectColor, tabUnselectColor: $tabUnselectColor)';
}


}

/// @nodoc
abstract mixin class _$StyleColorsCopyWith<$Res> implements $StyleColorsCopyWith<$Res> {
  factory _$StyleColorsCopyWith(_StyleColors value, $Res Function(_StyleColors) _then) = __$StyleColorsCopyWithImpl;
@override @useResult
$Res call({
@ColorConverter() Color? primary,@ColorConverter() Color? secondary,@ColorConverter() Color? textColor,@ColorConverter() Color? tabSelectColor,@ColorConverter() Color? tabUnselectColor
});




}
/// @nodoc
class __$StyleColorsCopyWithImpl<$Res>
    implements _$StyleColorsCopyWith<$Res> {
  __$StyleColorsCopyWithImpl(this._self, this._then);

  final _StyleColors _self;
  final $Res Function(_StyleColors) _then;

/// Create a copy of StyleColors
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? primary = freezed,Object? secondary = freezed,Object? textColor = freezed,Object? tabSelectColor = freezed,Object? tabUnselectColor = freezed,}) {
  return _then(_StyleColors(
primary: freezed == primary ? _self.primary : primary // ignore: cast_nullable_to_non_nullable
as Color?,secondary: freezed == secondary ? _self.secondary : secondary // ignore: cast_nullable_to_non_nullable
as Color?,textColor: freezed == textColor ? _self.textColor : textColor // ignore: cast_nullable_to_non_nullable
as Color?,tabSelectColor: freezed == tabSelectColor ? _self.tabSelectColor : tabSelectColor // ignore: cast_nullable_to_non_nullable
as Color?,tabUnselectColor: freezed == tabUnselectColor ? _self.tabUnselectColor : tabUnselectColor // ignore: cast_nullable_to_non_nullable
as Color?,
  ));
}


}


/// @nodoc
mixin _$Urls {

 String? get login; String? get signup; List<TabItem>? get tabs;
/// Create a copy of Urls
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UrlsCopyWith<Urls> get copyWith => _$UrlsCopyWithImpl<Urls>(this as Urls, _$identity);

  /// Serializes this Urls to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Urls&&(identical(other.login, login) || other.login == login)&&(identical(other.signup, signup) || other.signup == signup)&&const DeepCollectionEquality().equals(other.tabs, tabs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,login,signup,const DeepCollectionEquality().hash(tabs));

@override
String toString() {
  return 'Urls(login: $login, signup: $signup, tabs: $tabs)';
}


}

/// @nodoc
abstract mixin class $UrlsCopyWith<$Res>  {
  factory $UrlsCopyWith(Urls value, $Res Function(Urls) _then) = _$UrlsCopyWithImpl;
@useResult
$Res call({
 String? login, String? signup, List<TabItem>? tabs
});




}
/// @nodoc
class _$UrlsCopyWithImpl<$Res>
    implements $UrlsCopyWith<$Res> {
  _$UrlsCopyWithImpl(this._self, this._then);

  final Urls _self;
  final $Res Function(Urls) _then;

/// Create a copy of Urls
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? login = freezed,Object? signup = freezed,Object? tabs = freezed,}) {
  return _then(_self.copyWith(
login: freezed == login ? _self.login : login // ignore: cast_nullable_to_non_nullable
as String?,signup: freezed == signup ? _self.signup : signup // ignore: cast_nullable_to_non_nullable
as String?,tabs: freezed == tabs ? _self.tabs : tabs // ignore: cast_nullable_to_non_nullable
as List<TabItem>?,
  ));
}

}


/// Adds pattern-matching-related methods to [Urls].
extension UrlsPatterns on Urls {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Urls value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Urls() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Urls value)  $default,){
final _that = this;
switch (_that) {
case _Urls():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Urls value)?  $default,){
final _that = this;
switch (_that) {
case _Urls() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? login,  String? signup,  List<TabItem>? tabs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Urls() when $default != null:
return $default(_that.login,_that.signup,_that.tabs);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? login,  String? signup,  List<TabItem>? tabs)  $default,) {final _that = this;
switch (_that) {
case _Urls():
return $default(_that.login,_that.signup,_that.tabs);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? login,  String? signup,  List<TabItem>? tabs)?  $default,) {final _that = this;
switch (_that) {
case _Urls() when $default != null:
return $default(_that.login,_that.signup,_that.tabs);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _Urls implements Urls {
  const _Urls({this.login, this.signup, final  List<TabItem>? tabs}): _tabs = tabs;
  factory _Urls.fromJson(Map<String, dynamic> json) => _$UrlsFromJson(json);

@override final  String? login;
@override final  String? signup;
 final  List<TabItem>? _tabs;
@override List<TabItem>? get tabs {
  final value = _tabs;
  if (value == null) return null;
  if (_tabs is EqualUnmodifiableListView) return _tabs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of Urls
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UrlsCopyWith<_Urls> get copyWith => __$UrlsCopyWithImpl<_Urls>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UrlsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Urls&&(identical(other.login, login) || other.login == login)&&(identical(other.signup, signup) || other.signup == signup)&&const DeepCollectionEquality().equals(other._tabs, _tabs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,login,signup,const DeepCollectionEquality().hash(_tabs));

@override
String toString() {
  return 'Urls(login: $login, signup: $signup, tabs: $tabs)';
}


}

/// @nodoc
abstract mixin class _$UrlsCopyWith<$Res> implements $UrlsCopyWith<$Res> {
  factory _$UrlsCopyWith(_Urls value, $Res Function(_Urls) _then) = __$UrlsCopyWithImpl;
@override @useResult
$Res call({
 String? login, String? signup, List<TabItem>? tabs
});




}
/// @nodoc
class __$UrlsCopyWithImpl<$Res>
    implements _$UrlsCopyWith<$Res> {
  __$UrlsCopyWithImpl(this._self, this._then);

  final _Urls _self;
  final $Res Function(_Urls) _then;

/// Create a copy of Urls
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? login = freezed,Object? signup = freezed,Object? tabs = freezed,}) {
  return _then(_Urls(
login: freezed == login ? _self.login : login // ignore: cast_nullable_to_non_nullable
as String?,signup: freezed == signup ? _self.signup : signup // ignore: cast_nullable_to_non_nullable
as String?,tabs: freezed == tabs ? _self._tabs : tabs // ignore: cast_nullable_to_non_nullable
as List<TabItem>?,
  ));
}


}


/// @nodoc
mixin _$TabItem {

 String? get title; String? get url; String? get icon;
/// Create a copy of TabItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TabItemCopyWith<TabItem> get copyWith => _$TabItemCopyWithImpl<TabItem>(this as TabItem, _$identity);

  /// Serializes this TabItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TabItem&&(identical(other.title, title) || other.title == title)&&(identical(other.url, url) || other.url == url)&&(identical(other.icon, icon) || other.icon == icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,url,icon);

@override
String toString() {
  return 'TabItem(title: $title, url: $url, icon: $icon)';
}


}

/// @nodoc
abstract mixin class $TabItemCopyWith<$Res>  {
  factory $TabItemCopyWith(TabItem value, $Res Function(TabItem) _then) = _$TabItemCopyWithImpl;
@useResult
$Res call({
 String? title, String? url, String? icon
});




}
/// @nodoc
class _$TabItemCopyWithImpl<$Res>
    implements $TabItemCopyWith<$Res> {
  _$TabItemCopyWithImpl(this._self, this._then);

  final TabItem _self;
  final $Res Function(TabItem) _then;

/// Create a copy of TabItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? url = freezed,Object? icon = freezed,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TabItem].
extension TabItemPatterns on TabItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TabItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TabItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TabItem value)  $default,){
final _that = this;
switch (_that) {
case _TabItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TabItem value)?  $default,){
final _that = this;
switch (_that) {
case _TabItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title,  String? url,  String? icon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TabItem() when $default != null:
return $default(_that.title,_that.url,_that.icon);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title,  String? url,  String? icon)  $default,) {final _that = this;
switch (_that) {
case _TabItem():
return $default(_that.title,_that.url,_that.icon);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title,  String? url,  String? icon)?  $default,) {final _that = this;
switch (_that) {
case _TabItem() when $default != null:
return $default(_that.title,_that.url,_that.icon);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _TabItem implements TabItem {
  const _TabItem({this.title, this.url, this.icon});
  factory _TabItem.fromJson(Map<String, dynamic> json) => _$TabItemFromJson(json);

@override final  String? title;
@override final  String? url;
@override final  String? icon;

/// Create a copy of TabItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TabItemCopyWith<_TabItem> get copyWith => __$TabItemCopyWithImpl<_TabItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TabItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TabItem&&(identical(other.title, title) || other.title == title)&&(identical(other.url, url) || other.url == url)&&(identical(other.icon, icon) || other.icon == icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,url,icon);

@override
String toString() {
  return 'TabItem(title: $title, url: $url, icon: $icon)';
}


}

/// @nodoc
abstract mixin class _$TabItemCopyWith<$Res> implements $TabItemCopyWith<$Res> {
  factory _$TabItemCopyWith(_TabItem value, $Res Function(_TabItem) _then) = __$TabItemCopyWithImpl;
@override @useResult
$Res call({
 String? title, String? url, String? icon
});




}
/// @nodoc
class __$TabItemCopyWithImpl<$Res>
    implements _$TabItemCopyWith<$Res> {
  __$TabItemCopyWithImpl(this._self, this._then);

  final _TabItem _self;
  final $Res Function(_TabItem) _then;

/// Create a copy of TabItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? url = freezed,Object? icon = freezed,}) {
  return _then(_TabItem(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
