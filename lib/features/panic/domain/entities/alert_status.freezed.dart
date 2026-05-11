// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alert_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AlertStatus {

 String get alertId; DateTime get createdAt; AlertState get state; double? get latitude; double? get longitude; List<String> get notifiedContacts; String? get errorMessage;
/// Create a copy of AlertStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlertStatusCopyWith<AlertStatus> get copyWith => _$AlertStatusCopyWithImpl<AlertStatus>(this as AlertStatus, _$identity);

  /// Serializes this AlertStatus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlertStatus&&(identical(other.alertId, alertId) || other.alertId == alertId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.state, state) || other.state == state)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&const DeepCollectionEquality().equals(other.notifiedContacts, notifiedContacts)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,alertId,createdAt,state,latitude,longitude,const DeepCollectionEquality().hash(notifiedContacts),errorMessage);

@override
String toString() {
  return 'AlertStatus(alertId: $alertId, createdAt: $createdAt, state: $state, latitude: $latitude, longitude: $longitude, notifiedContacts: $notifiedContacts, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $AlertStatusCopyWith<$Res>  {
  factory $AlertStatusCopyWith(AlertStatus value, $Res Function(AlertStatus) _then) = _$AlertStatusCopyWithImpl;
@useResult
$Res call({
 String alertId, DateTime createdAt, AlertState state, double? latitude, double? longitude, List<String> notifiedContacts, String? errorMessage
});




}
/// @nodoc
class _$AlertStatusCopyWithImpl<$Res>
    implements $AlertStatusCopyWith<$Res> {
  _$AlertStatusCopyWithImpl(this._self, this._then);

  final AlertStatus _self;
  final $Res Function(AlertStatus) _then;

/// Create a copy of AlertStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? alertId = null,Object? createdAt = null,Object? state = null,Object? latitude = freezed,Object? longitude = freezed,Object? notifiedContacts = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
alertId: null == alertId ? _self.alertId : alertId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as AlertState,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,notifiedContacts: null == notifiedContacts ? _self.notifiedContacts : notifiedContacts // ignore: cast_nullable_to_non_nullable
as List<String>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AlertStatus].
extension AlertStatusPatterns on AlertStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlertStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlertStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlertStatus value)  $default,){
final _that = this;
switch (_that) {
case _AlertStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlertStatus value)?  $default,){
final _that = this;
switch (_that) {
case _AlertStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String alertId,  DateTime createdAt,  AlertState state,  double? latitude,  double? longitude,  List<String> notifiedContacts,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlertStatus() when $default != null:
return $default(_that.alertId,_that.createdAt,_that.state,_that.latitude,_that.longitude,_that.notifiedContacts,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String alertId,  DateTime createdAt,  AlertState state,  double? latitude,  double? longitude,  List<String> notifiedContacts,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _AlertStatus():
return $default(_that.alertId,_that.createdAt,_that.state,_that.latitude,_that.longitude,_that.notifiedContacts,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String alertId,  DateTime createdAt,  AlertState state,  double? latitude,  double? longitude,  List<String> notifiedContacts,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _AlertStatus() when $default != null:
return $default(_that.alertId,_that.createdAt,_that.state,_that.latitude,_that.longitude,_that.notifiedContacts,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AlertStatus implements AlertStatus {
  const _AlertStatus({required this.alertId, required this.createdAt, required this.state, this.latitude, this.longitude, final  List<String> notifiedContacts = const [], this.errorMessage}): _notifiedContacts = notifiedContacts;
  factory _AlertStatus.fromJson(Map<String, dynamic> json) => _$AlertStatusFromJson(json);

@override final  String alertId;
@override final  DateTime createdAt;
@override final  AlertState state;
@override final  double? latitude;
@override final  double? longitude;
 final  List<String> _notifiedContacts;
@override@JsonKey() List<String> get notifiedContacts {
  if (_notifiedContacts is EqualUnmodifiableListView) return _notifiedContacts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notifiedContacts);
}

@override final  String? errorMessage;

/// Create a copy of AlertStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlertStatusCopyWith<_AlertStatus> get copyWith => __$AlertStatusCopyWithImpl<_AlertStatus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlertStatusToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlertStatus&&(identical(other.alertId, alertId) || other.alertId == alertId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.state, state) || other.state == state)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&const DeepCollectionEquality().equals(other._notifiedContacts, _notifiedContacts)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,alertId,createdAt,state,latitude,longitude,const DeepCollectionEquality().hash(_notifiedContacts),errorMessage);

@override
String toString() {
  return 'AlertStatus(alertId: $alertId, createdAt: $createdAt, state: $state, latitude: $latitude, longitude: $longitude, notifiedContacts: $notifiedContacts, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$AlertStatusCopyWith<$Res> implements $AlertStatusCopyWith<$Res> {
  factory _$AlertStatusCopyWith(_AlertStatus value, $Res Function(_AlertStatus) _then) = __$AlertStatusCopyWithImpl;
@override @useResult
$Res call({
 String alertId, DateTime createdAt, AlertState state, double? latitude, double? longitude, List<String> notifiedContacts, String? errorMessage
});




}
/// @nodoc
class __$AlertStatusCopyWithImpl<$Res>
    implements _$AlertStatusCopyWith<$Res> {
  __$AlertStatusCopyWithImpl(this._self, this._then);

  final _AlertStatus _self;
  final $Res Function(_AlertStatus) _then;

/// Create a copy of AlertStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? alertId = null,Object? createdAt = null,Object? state = null,Object? latitude = freezed,Object? longitude = freezed,Object? notifiedContacts = null,Object? errorMessage = freezed,}) {
  return _then(_AlertStatus(
alertId: null == alertId ? _self.alertId : alertId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as AlertState,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,notifiedContacts: null == notifiedContacts ? _self._notifiedContacts : notifiedContacts // ignore: cast_nullable_to_non_nullable
as List<String>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
