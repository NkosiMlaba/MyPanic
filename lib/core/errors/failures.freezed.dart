// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failures.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Failure {

 String get message;
/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FailureCopyWith<Failure> get copyWith => _$FailureCopyWithImpl<Failure>(this as Failure, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Failure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'Failure(message: $message)';
}


}

/// @nodoc
abstract mixin class $FailureCopyWith<$Res>  {
  factory $FailureCopyWith(Failure value, $Res Function(Failure) _then) = _$FailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$FailureCopyWithImpl<$Res>
    implements $FailureCopyWith<$Res> {
  _$FailureCopyWithImpl(this._self, this._then);

  final Failure _self;
  final $Res Function(Failure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Failure].
extension FailurePatterns on Failure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PermissionFailure value)?  permission,TResult Function( LocationFailure value)?  location,TResult Function( SmsFailure value)?  sms,TResult Function( NetworkFailure value)?  network,TResult Function( UnexpectedFailure value)?  unexpected,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PermissionFailure() when permission != null:
return permission(_that);case LocationFailure() when location != null:
return location(_that);case SmsFailure() when sms != null:
return sms(_that);case NetworkFailure() when network != null:
return network(_that);case UnexpectedFailure() when unexpected != null:
return unexpected(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PermissionFailure value)  permission,required TResult Function( LocationFailure value)  location,required TResult Function( SmsFailure value)  sms,required TResult Function( NetworkFailure value)  network,required TResult Function( UnexpectedFailure value)  unexpected,}){
final _that = this;
switch (_that) {
case PermissionFailure():
return permission(_that);case LocationFailure():
return location(_that);case SmsFailure():
return sms(_that);case NetworkFailure():
return network(_that);case UnexpectedFailure():
return unexpected(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PermissionFailure value)?  permission,TResult? Function( LocationFailure value)?  location,TResult? Function( SmsFailure value)?  sms,TResult? Function( NetworkFailure value)?  network,TResult? Function( UnexpectedFailure value)?  unexpected,}){
final _that = this;
switch (_that) {
case PermissionFailure() when permission != null:
return permission(_that);case LocationFailure() when location != null:
return location(_that);case SmsFailure() when sms != null:
return sms(_that);case NetworkFailure() when network != null:
return network(_that);case UnexpectedFailure() when unexpected != null:
return unexpected(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String message,  String? permissionType)?  permission,TResult Function( String message,  String? errorCode)?  location,TResult Function( String message,  List<String>? failedNumbers)?  sms,TResult Function( String message,  int? statusCode)?  network,TResult Function( String message,  Object? exception)?  unexpected,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PermissionFailure() when permission != null:
return permission(_that.message,_that.permissionType);case LocationFailure() when location != null:
return location(_that.message,_that.errorCode);case SmsFailure() when sms != null:
return sms(_that.message,_that.failedNumbers);case NetworkFailure() when network != null:
return network(_that.message,_that.statusCode);case UnexpectedFailure() when unexpected != null:
return unexpected(_that.message,_that.exception);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String message,  String? permissionType)  permission,required TResult Function( String message,  String? errorCode)  location,required TResult Function( String message,  List<String>? failedNumbers)  sms,required TResult Function( String message,  int? statusCode)  network,required TResult Function( String message,  Object? exception)  unexpected,}) {final _that = this;
switch (_that) {
case PermissionFailure():
return permission(_that.message,_that.permissionType);case LocationFailure():
return location(_that.message,_that.errorCode);case SmsFailure():
return sms(_that.message,_that.failedNumbers);case NetworkFailure():
return network(_that.message,_that.statusCode);case UnexpectedFailure():
return unexpected(_that.message,_that.exception);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String message,  String? permissionType)?  permission,TResult? Function( String message,  String? errorCode)?  location,TResult? Function( String message,  List<String>? failedNumbers)?  sms,TResult? Function( String message,  int? statusCode)?  network,TResult? Function( String message,  Object? exception)?  unexpected,}) {final _that = this;
switch (_that) {
case PermissionFailure() when permission != null:
return permission(_that.message,_that.permissionType);case LocationFailure() when location != null:
return location(_that.message,_that.errorCode);case SmsFailure() when sms != null:
return sms(_that.message,_that.failedNumbers);case NetworkFailure() when network != null:
return network(_that.message,_that.statusCode);case UnexpectedFailure() when unexpected != null:
return unexpected(_that.message,_that.exception);case _:
  return null;

}
}

}

/// @nodoc


class PermissionFailure implements Failure {
  const PermissionFailure({required this.message, this.permissionType});
  

@override final  String message;
 final  String? permissionType;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PermissionFailureCopyWith<PermissionFailure> get copyWith => _$PermissionFailureCopyWithImpl<PermissionFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PermissionFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.permissionType, permissionType) || other.permissionType == permissionType));
}


@override
int get hashCode => Object.hash(runtimeType,message,permissionType);

@override
String toString() {
  return 'Failure.permission(message: $message, permissionType: $permissionType)';
}


}

/// @nodoc
abstract mixin class $PermissionFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $PermissionFailureCopyWith(PermissionFailure value, $Res Function(PermissionFailure) _then) = _$PermissionFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? permissionType
});




}
/// @nodoc
class _$PermissionFailureCopyWithImpl<$Res>
    implements $PermissionFailureCopyWith<$Res> {
  _$PermissionFailureCopyWithImpl(this._self, this._then);

  final PermissionFailure _self;
  final $Res Function(PermissionFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? permissionType = freezed,}) {
  return _then(PermissionFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,permissionType: freezed == permissionType ? _self.permissionType : permissionType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class LocationFailure implements Failure {
  const LocationFailure({required this.message, this.errorCode});
  

@override final  String message;
 final  String? errorCode;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationFailureCopyWith<LocationFailure> get copyWith => _$LocationFailureCopyWithImpl<LocationFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocationFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode));
}


@override
int get hashCode => Object.hash(runtimeType,message,errorCode);

@override
String toString() {
  return 'Failure.location(message: $message, errorCode: $errorCode)';
}


}

/// @nodoc
abstract mixin class $LocationFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $LocationFailureCopyWith(LocationFailure value, $Res Function(LocationFailure) _then) = _$LocationFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, String? errorCode
});




}
/// @nodoc
class _$LocationFailureCopyWithImpl<$Res>
    implements $LocationFailureCopyWith<$Res> {
  _$LocationFailureCopyWithImpl(this._self, this._then);

  final LocationFailure _self;
  final $Res Function(LocationFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? errorCode = freezed,}) {
  return _then(LocationFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,errorCode: freezed == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class SmsFailure implements Failure {
  const SmsFailure({required this.message, final  List<String>? failedNumbers}): _failedNumbers = failedNumbers;
  

@override final  String message;
 final  List<String>? _failedNumbers;
 List<String>? get failedNumbers {
  final value = _failedNumbers;
  if (value == null) return null;
  if (_failedNumbers is EqualUnmodifiableListView) return _failedNumbers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SmsFailureCopyWith<SmsFailure> get copyWith => _$SmsFailureCopyWithImpl<SmsFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SmsFailure&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._failedNumbers, _failedNumbers));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(_failedNumbers));

@override
String toString() {
  return 'Failure.sms(message: $message, failedNumbers: $failedNumbers)';
}


}

/// @nodoc
abstract mixin class $SmsFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $SmsFailureCopyWith(SmsFailure value, $Res Function(SmsFailure) _then) = _$SmsFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, List<String>? failedNumbers
});




}
/// @nodoc
class _$SmsFailureCopyWithImpl<$Res>
    implements $SmsFailureCopyWith<$Res> {
  _$SmsFailureCopyWithImpl(this._self, this._then);

  final SmsFailure _self;
  final $Res Function(SmsFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? failedNumbers = freezed,}) {
  return _then(SmsFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,failedNumbers: freezed == failedNumbers ? _self._failedNumbers : failedNumbers // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

/// @nodoc


class NetworkFailure implements Failure {
  const NetworkFailure({required this.message, this.statusCode});
  

@override final  String message;
 final  int? statusCode;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkFailureCopyWith<NetworkFailure> get copyWith => _$NetworkFailureCopyWithImpl<NetworkFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode));
}


@override
int get hashCode => Object.hash(runtimeType,message,statusCode);

@override
String toString() {
  return 'Failure.network(message: $message, statusCode: $statusCode)';
}


}

/// @nodoc
abstract mixin class $NetworkFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $NetworkFailureCopyWith(NetworkFailure value, $Res Function(NetworkFailure) _then) = _$NetworkFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, int? statusCode
});




}
/// @nodoc
class _$NetworkFailureCopyWithImpl<$Res>
    implements $NetworkFailureCopyWith<$Res> {
  _$NetworkFailureCopyWithImpl(this._self, this._then);

  final NetworkFailure _self;
  final $Res Function(NetworkFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? statusCode = freezed,}) {
  return _then(NetworkFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class UnexpectedFailure implements Failure {
  const UnexpectedFailure({required this.message, this.exception});
  

@override final  String message;
 final  Object? exception;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnexpectedFailureCopyWith<UnexpectedFailure> get copyWith => _$UnexpectedFailureCopyWithImpl<UnexpectedFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnexpectedFailure&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.exception, exception));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(exception));

@override
String toString() {
  return 'Failure.unexpected(message: $message, exception: $exception)';
}


}

/// @nodoc
abstract mixin class $UnexpectedFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $UnexpectedFailureCopyWith(UnexpectedFailure value, $Res Function(UnexpectedFailure) _then) = _$UnexpectedFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, Object? exception
});




}
/// @nodoc
class _$UnexpectedFailureCopyWithImpl<$Res>
    implements $UnexpectedFailureCopyWith<$Res> {
  _$UnexpectedFailureCopyWithImpl(this._self, this._then);

  final UnexpectedFailure _self;
  final $Res Function(UnexpectedFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? exception = freezed,}) {
  return _then(UnexpectedFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,exception: freezed == exception ? _self.exception : exception ,
  ));
}


}

// dart format on
