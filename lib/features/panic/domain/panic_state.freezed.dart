// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'panic_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PanicState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PanicState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PanicState()';
}


}

/// @nodoc
class $PanicStateCopyWith<$Res>  {
$PanicStateCopyWith(PanicState _, $Res Function(PanicState) __);
}


/// Adds pattern-matching-related methods to [PanicState].
extension PanicStatePatterns on PanicState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PanicStateIdle value)?  idle,TResult Function( PanicStateArmed value)?  armed,TResult Function( PanicStateCountingDown value)?  countingDown,TResult Function( PanicStateActive value)?  active,TResult Function( PanicStateCancelled value)?  cancelled,TResult Function( PanicStateError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PanicStateIdle() when idle != null:
return idle(_that);case PanicStateArmed() when armed != null:
return armed(_that);case PanicStateCountingDown() when countingDown != null:
return countingDown(_that);case PanicStateActive() when active != null:
return active(_that);case PanicStateCancelled() when cancelled != null:
return cancelled(_that);case PanicStateError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PanicStateIdle value)  idle,required TResult Function( PanicStateArmed value)  armed,required TResult Function( PanicStateCountingDown value)  countingDown,required TResult Function( PanicStateActive value)  active,required TResult Function( PanicStateCancelled value)  cancelled,required TResult Function( PanicStateError value)  error,}){
final _that = this;
switch (_that) {
case PanicStateIdle():
return idle(_that);case PanicStateArmed():
return armed(_that);case PanicStateCountingDown():
return countingDown(_that);case PanicStateActive():
return active(_that);case PanicStateCancelled():
return cancelled(_that);case PanicStateError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PanicStateIdle value)?  idle,TResult? Function( PanicStateArmed value)?  armed,TResult? Function( PanicStateCountingDown value)?  countingDown,TResult? Function( PanicStateActive value)?  active,TResult? Function( PanicStateCancelled value)?  cancelled,TResult? Function( PanicStateError value)?  error,}){
final _that = this;
switch (_that) {
case PanicStateIdle() when idle != null:
return idle(_that);case PanicStateArmed() when armed != null:
return armed(_that);case PanicStateCountingDown() when countingDown != null:
return countingDown(_that);case PanicStateActive() when active != null:
return active(_that);case PanicStateCancelled() when cancelled != null:
return cancelled(_that);case PanicStateError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  armed,TResult Function( int secondsRemaining,  DateTime triggeredAt)?  countingDown,TResult Function( DateTime activatedAt,  String? alertId)?  active,TResult Function( DateTime cancelledAt)?  cancelled,TResult Function( String message,  Object? exception)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PanicStateIdle() when idle != null:
return idle();case PanicStateArmed() when armed != null:
return armed();case PanicStateCountingDown() when countingDown != null:
return countingDown(_that.secondsRemaining,_that.triggeredAt);case PanicStateActive() when active != null:
return active(_that.activatedAt,_that.alertId);case PanicStateCancelled() when cancelled != null:
return cancelled(_that.cancelledAt);case PanicStateError() when error != null:
return error(_that.message,_that.exception);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  armed,required TResult Function( int secondsRemaining,  DateTime triggeredAt)  countingDown,required TResult Function( DateTime activatedAt,  String? alertId)  active,required TResult Function( DateTime cancelledAt)  cancelled,required TResult Function( String message,  Object? exception)  error,}) {final _that = this;
switch (_that) {
case PanicStateIdle():
return idle();case PanicStateArmed():
return armed();case PanicStateCountingDown():
return countingDown(_that.secondsRemaining,_that.triggeredAt);case PanicStateActive():
return active(_that.activatedAt,_that.alertId);case PanicStateCancelled():
return cancelled(_that.cancelledAt);case PanicStateError():
return error(_that.message,_that.exception);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  armed,TResult? Function( int secondsRemaining,  DateTime triggeredAt)?  countingDown,TResult? Function( DateTime activatedAt,  String? alertId)?  active,TResult? Function( DateTime cancelledAt)?  cancelled,TResult? Function( String message,  Object? exception)?  error,}) {final _that = this;
switch (_that) {
case PanicStateIdle() when idle != null:
return idle();case PanicStateArmed() when armed != null:
return armed();case PanicStateCountingDown() when countingDown != null:
return countingDown(_that.secondsRemaining,_that.triggeredAt);case PanicStateActive() when active != null:
return active(_that.activatedAt,_that.alertId);case PanicStateCancelled() when cancelled != null:
return cancelled(_that.cancelledAt);case PanicStateError() when error != null:
return error(_that.message,_that.exception);case _:
  return null;

}
}

}

/// @nodoc


class PanicStateIdle implements PanicState {
  const PanicStateIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PanicStateIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PanicState.idle()';
}


}




/// @nodoc


class PanicStateArmed implements PanicState {
  const PanicStateArmed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PanicStateArmed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PanicState.armed()';
}


}




/// @nodoc


class PanicStateCountingDown implements PanicState {
  const PanicStateCountingDown({required this.secondsRemaining, required this.triggeredAt});
  

 final  int secondsRemaining;
 final  DateTime triggeredAt;

/// Create a copy of PanicState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PanicStateCountingDownCopyWith<PanicStateCountingDown> get copyWith => _$PanicStateCountingDownCopyWithImpl<PanicStateCountingDown>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PanicStateCountingDown&&(identical(other.secondsRemaining, secondsRemaining) || other.secondsRemaining == secondsRemaining)&&(identical(other.triggeredAt, triggeredAt) || other.triggeredAt == triggeredAt));
}


@override
int get hashCode => Object.hash(runtimeType,secondsRemaining,triggeredAt);

@override
String toString() {
  return 'PanicState.countingDown(secondsRemaining: $secondsRemaining, triggeredAt: $triggeredAt)';
}


}

/// @nodoc
abstract mixin class $PanicStateCountingDownCopyWith<$Res> implements $PanicStateCopyWith<$Res> {
  factory $PanicStateCountingDownCopyWith(PanicStateCountingDown value, $Res Function(PanicStateCountingDown) _then) = _$PanicStateCountingDownCopyWithImpl;
@useResult
$Res call({
 int secondsRemaining, DateTime triggeredAt
});




}
/// @nodoc
class _$PanicStateCountingDownCopyWithImpl<$Res>
    implements $PanicStateCountingDownCopyWith<$Res> {
  _$PanicStateCountingDownCopyWithImpl(this._self, this._then);

  final PanicStateCountingDown _self;
  final $Res Function(PanicStateCountingDown) _then;

/// Create a copy of PanicState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? secondsRemaining = null,Object? triggeredAt = null,}) {
  return _then(PanicStateCountingDown(
secondsRemaining: null == secondsRemaining ? _self.secondsRemaining : secondsRemaining // ignore: cast_nullable_to_non_nullable
as int,triggeredAt: null == triggeredAt ? _self.triggeredAt : triggeredAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc


class PanicStateActive implements PanicState {
  const PanicStateActive({required this.activatedAt, this.alertId});
  

 final  DateTime activatedAt;
 final  String? alertId;

/// Create a copy of PanicState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PanicStateActiveCopyWith<PanicStateActive> get copyWith => _$PanicStateActiveCopyWithImpl<PanicStateActive>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PanicStateActive&&(identical(other.activatedAt, activatedAt) || other.activatedAt == activatedAt)&&(identical(other.alertId, alertId) || other.alertId == alertId));
}


@override
int get hashCode => Object.hash(runtimeType,activatedAt,alertId);

@override
String toString() {
  return 'PanicState.active(activatedAt: $activatedAt, alertId: $alertId)';
}


}

/// @nodoc
abstract mixin class $PanicStateActiveCopyWith<$Res> implements $PanicStateCopyWith<$Res> {
  factory $PanicStateActiveCopyWith(PanicStateActive value, $Res Function(PanicStateActive) _then) = _$PanicStateActiveCopyWithImpl;
@useResult
$Res call({
 DateTime activatedAt, String? alertId
});




}
/// @nodoc
class _$PanicStateActiveCopyWithImpl<$Res>
    implements $PanicStateActiveCopyWith<$Res> {
  _$PanicStateActiveCopyWithImpl(this._self, this._then);

  final PanicStateActive _self;
  final $Res Function(PanicStateActive) _then;

/// Create a copy of PanicState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? activatedAt = null,Object? alertId = freezed,}) {
  return _then(PanicStateActive(
activatedAt: null == activatedAt ? _self.activatedAt : activatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,alertId: freezed == alertId ? _self.alertId : alertId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class PanicStateCancelled implements PanicState {
  const PanicStateCancelled({required this.cancelledAt});
  

 final  DateTime cancelledAt;

/// Create a copy of PanicState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PanicStateCancelledCopyWith<PanicStateCancelled> get copyWith => _$PanicStateCancelledCopyWithImpl<PanicStateCancelled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PanicStateCancelled&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt));
}


@override
int get hashCode => Object.hash(runtimeType,cancelledAt);

@override
String toString() {
  return 'PanicState.cancelled(cancelledAt: $cancelledAt)';
}


}

/// @nodoc
abstract mixin class $PanicStateCancelledCopyWith<$Res> implements $PanicStateCopyWith<$Res> {
  factory $PanicStateCancelledCopyWith(PanicStateCancelled value, $Res Function(PanicStateCancelled) _then) = _$PanicStateCancelledCopyWithImpl;
@useResult
$Res call({
 DateTime cancelledAt
});




}
/// @nodoc
class _$PanicStateCancelledCopyWithImpl<$Res>
    implements $PanicStateCancelledCopyWith<$Res> {
  _$PanicStateCancelledCopyWithImpl(this._self, this._then);

  final PanicStateCancelled _self;
  final $Res Function(PanicStateCancelled) _then;

/// Create a copy of PanicState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? cancelledAt = null,}) {
  return _then(PanicStateCancelled(
cancelledAt: null == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc


class PanicStateError implements PanicState {
  const PanicStateError({required this.message, this.exception});
  

 final  String message;
 final  Object? exception;

/// Create a copy of PanicState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PanicStateErrorCopyWith<PanicStateError> get copyWith => _$PanicStateErrorCopyWithImpl<PanicStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PanicStateError&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.exception, exception));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(exception));

@override
String toString() {
  return 'PanicState.error(message: $message, exception: $exception)';
}


}

/// @nodoc
abstract mixin class $PanicStateErrorCopyWith<$Res> implements $PanicStateCopyWith<$Res> {
  factory $PanicStateErrorCopyWith(PanicStateError value, $Res Function(PanicStateError) _then) = _$PanicStateErrorCopyWithImpl;
@useResult
$Res call({
 String message, Object? exception
});




}
/// @nodoc
class _$PanicStateErrorCopyWithImpl<$Res>
    implements $PanicStateErrorCopyWith<$Res> {
  _$PanicStateErrorCopyWithImpl(this._self, this._then);

  final PanicStateError _self;
  final $Res Function(PanicStateError) _then;

/// Create a copy of PanicState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? exception = freezed,}) {
  return _then(PanicStateError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,exception: freezed == exception ? _self.exception : exception ,
  ));
}


}

// dart format on
