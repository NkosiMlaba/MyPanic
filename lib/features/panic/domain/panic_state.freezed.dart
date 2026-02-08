// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'panic_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PanicState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() armed,
    required TResult Function(int secondsRemaining, DateTime triggeredAt)
    countingDown,
    required TResult Function(DateTime activatedAt, String? alertId) active,
    required TResult Function(DateTime cancelledAt) cancelled,
    required TResult Function(String message, Object? exception) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? armed,
    TResult? Function(int secondsRemaining, DateTime triggeredAt)? countingDown,
    TResult? Function(DateTime activatedAt, String? alertId)? active,
    TResult? Function(DateTime cancelledAt)? cancelled,
    TResult? Function(String message, Object? exception)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? armed,
    TResult Function(int secondsRemaining, DateTime triggeredAt)? countingDown,
    TResult Function(DateTime activatedAt, String? alertId)? active,
    TResult Function(DateTime cancelledAt)? cancelled,
    TResult Function(String message, Object? exception)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PanicStateIdle value) idle,
    required TResult Function(PanicStateArmed value) armed,
    required TResult Function(PanicStateCountingDown value) countingDown,
    required TResult Function(PanicStateActive value) active,
    required TResult Function(PanicStateCancelled value) cancelled,
    required TResult Function(PanicStateError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PanicStateIdle value)? idle,
    TResult? Function(PanicStateArmed value)? armed,
    TResult? Function(PanicStateCountingDown value)? countingDown,
    TResult? Function(PanicStateActive value)? active,
    TResult? Function(PanicStateCancelled value)? cancelled,
    TResult? Function(PanicStateError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PanicStateIdle value)? idle,
    TResult Function(PanicStateArmed value)? armed,
    TResult Function(PanicStateCountingDown value)? countingDown,
    TResult Function(PanicStateActive value)? active,
    TResult Function(PanicStateCancelled value)? cancelled,
    TResult Function(PanicStateError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PanicStateCopyWith<$Res> {
  factory $PanicStateCopyWith(
    PanicState value,
    $Res Function(PanicState) then,
  ) = _$PanicStateCopyWithImpl<$Res, PanicState>;
}

/// @nodoc
class _$PanicStateCopyWithImpl<$Res, $Val extends PanicState>
    implements $PanicStateCopyWith<$Res> {
  _$PanicStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PanicState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$PanicStateIdleImplCopyWith<$Res> {
  factory _$$PanicStateIdleImplCopyWith(
    _$PanicStateIdleImpl value,
    $Res Function(_$PanicStateIdleImpl) then,
  ) = __$$PanicStateIdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PanicStateIdleImplCopyWithImpl<$Res>
    extends _$PanicStateCopyWithImpl<$Res, _$PanicStateIdleImpl>
    implements _$$PanicStateIdleImplCopyWith<$Res> {
  __$$PanicStateIdleImplCopyWithImpl(
    _$PanicStateIdleImpl _value,
    $Res Function(_$PanicStateIdleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PanicState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PanicStateIdleImpl implements PanicStateIdle {
  const _$PanicStateIdleImpl();

  @override
  String toString() {
    return 'PanicState.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PanicStateIdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() armed,
    required TResult Function(int secondsRemaining, DateTime triggeredAt)
    countingDown,
    required TResult Function(DateTime activatedAt, String? alertId) active,
    required TResult Function(DateTime cancelledAt) cancelled,
    required TResult Function(String message, Object? exception) error,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? armed,
    TResult? Function(int secondsRemaining, DateTime triggeredAt)? countingDown,
    TResult? Function(DateTime activatedAt, String? alertId)? active,
    TResult? Function(DateTime cancelledAt)? cancelled,
    TResult? Function(String message, Object? exception)? error,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? armed,
    TResult Function(int secondsRemaining, DateTime triggeredAt)? countingDown,
    TResult Function(DateTime activatedAt, String? alertId)? active,
    TResult Function(DateTime cancelledAt)? cancelled,
    TResult Function(String message, Object? exception)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PanicStateIdle value) idle,
    required TResult Function(PanicStateArmed value) armed,
    required TResult Function(PanicStateCountingDown value) countingDown,
    required TResult Function(PanicStateActive value) active,
    required TResult Function(PanicStateCancelled value) cancelled,
    required TResult Function(PanicStateError value) error,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PanicStateIdle value)? idle,
    TResult? Function(PanicStateArmed value)? armed,
    TResult? Function(PanicStateCountingDown value)? countingDown,
    TResult? Function(PanicStateActive value)? active,
    TResult? Function(PanicStateCancelled value)? cancelled,
    TResult? Function(PanicStateError value)? error,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PanicStateIdle value)? idle,
    TResult Function(PanicStateArmed value)? armed,
    TResult Function(PanicStateCountingDown value)? countingDown,
    TResult Function(PanicStateActive value)? active,
    TResult Function(PanicStateCancelled value)? cancelled,
    TResult Function(PanicStateError value)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class PanicStateIdle implements PanicState {
  const factory PanicStateIdle() = _$PanicStateIdleImpl;
}

/// @nodoc
abstract class _$$PanicStateArmedImplCopyWith<$Res> {
  factory _$$PanicStateArmedImplCopyWith(
    _$PanicStateArmedImpl value,
    $Res Function(_$PanicStateArmedImpl) then,
  ) = __$$PanicStateArmedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PanicStateArmedImplCopyWithImpl<$Res>
    extends _$PanicStateCopyWithImpl<$Res, _$PanicStateArmedImpl>
    implements _$$PanicStateArmedImplCopyWith<$Res> {
  __$$PanicStateArmedImplCopyWithImpl(
    _$PanicStateArmedImpl _value,
    $Res Function(_$PanicStateArmedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PanicState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PanicStateArmedImpl implements PanicStateArmed {
  const _$PanicStateArmedImpl();

  @override
  String toString() {
    return 'PanicState.armed()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PanicStateArmedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() armed,
    required TResult Function(int secondsRemaining, DateTime triggeredAt)
    countingDown,
    required TResult Function(DateTime activatedAt, String? alertId) active,
    required TResult Function(DateTime cancelledAt) cancelled,
    required TResult Function(String message, Object? exception) error,
  }) {
    return armed();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? armed,
    TResult? Function(int secondsRemaining, DateTime triggeredAt)? countingDown,
    TResult? Function(DateTime activatedAt, String? alertId)? active,
    TResult? Function(DateTime cancelledAt)? cancelled,
    TResult? Function(String message, Object? exception)? error,
  }) {
    return armed?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? armed,
    TResult Function(int secondsRemaining, DateTime triggeredAt)? countingDown,
    TResult Function(DateTime activatedAt, String? alertId)? active,
    TResult Function(DateTime cancelledAt)? cancelled,
    TResult Function(String message, Object? exception)? error,
    required TResult orElse(),
  }) {
    if (armed != null) {
      return armed();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PanicStateIdle value) idle,
    required TResult Function(PanicStateArmed value) armed,
    required TResult Function(PanicStateCountingDown value) countingDown,
    required TResult Function(PanicStateActive value) active,
    required TResult Function(PanicStateCancelled value) cancelled,
    required TResult Function(PanicStateError value) error,
  }) {
    return armed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PanicStateIdle value)? idle,
    TResult? Function(PanicStateArmed value)? armed,
    TResult? Function(PanicStateCountingDown value)? countingDown,
    TResult? Function(PanicStateActive value)? active,
    TResult? Function(PanicStateCancelled value)? cancelled,
    TResult? Function(PanicStateError value)? error,
  }) {
    return armed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PanicStateIdle value)? idle,
    TResult Function(PanicStateArmed value)? armed,
    TResult Function(PanicStateCountingDown value)? countingDown,
    TResult Function(PanicStateActive value)? active,
    TResult Function(PanicStateCancelled value)? cancelled,
    TResult Function(PanicStateError value)? error,
    required TResult orElse(),
  }) {
    if (armed != null) {
      return armed(this);
    }
    return orElse();
  }
}

abstract class PanicStateArmed implements PanicState {
  const factory PanicStateArmed() = _$PanicStateArmedImpl;
}

/// @nodoc
abstract class _$$PanicStateCountingDownImplCopyWith<$Res> {
  factory _$$PanicStateCountingDownImplCopyWith(
    _$PanicStateCountingDownImpl value,
    $Res Function(_$PanicStateCountingDownImpl) then,
  ) = __$$PanicStateCountingDownImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int secondsRemaining, DateTime triggeredAt});
}

/// @nodoc
class __$$PanicStateCountingDownImplCopyWithImpl<$Res>
    extends _$PanicStateCopyWithImpl<$Res, _$PanicStateCountingDownImpl>
    implements _$$PanicStateCountingDownImplCopyWith<$Res> {
  __$$PanicStateCountingDownImplCopyWithImpl(
    _$PanicStateCountingDownImpl _value,
    $Res Function(_$PanicStateCountingDownImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PanicState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? secondsRemaining = null, Object? triggeredAt = null}) {
    return _then(
      _$PanicStateCountingDownImpl(
        secondsRemaining: null == secondsRemaining
            ? _value.secondsRemaining
            : secondsRemaining // ignore: cast_nullable_to_non_nullable
                  as int,
        triggeredAt: null == triggeredAt
            ? _value.triggeredAt
            : triggeredAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$PanicStateCountingDownImpl implements PanicStateCountingDown {
  const _$PanicStateCountingDownImpl({
    required this.secondsRemaining,
    required this.triggeredAt,
  });

  @override
  final int secondsRemaining;
  @override
  final DateTime triggeredAt;

  @override
  String toString() {
    return 'PanicState.countingDown(secondsRemaining: $secondsRemaining, triggeredAt: $triggeredAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PanicStateCountingDownImpl &&
            (identical(other.secondsRemaining, secondsRemaining) ||
                other.secondsRemaining == secondsRemaining) &&
            (identical(other.triggeredAt, triggeredAt) ||
                other.triggeredAt == triggeredAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, secondsRemaining, triggeredAt);

  /// Create a copy of PanicState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PanicStateCountingDownImplCopyWith<_$PanicStateCountingDownImpl>
  get copyWith =>
      __$$PanicStateCountingDownImplCopyWithImpl<_$PanicStateCountingDownImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() armed,
    required TResult Function(int secondsRemaining, DateTime triggeredAt)
    countingDown,
    required TResult Function(DateTime activatedAt, String? alertId) active,
    required TResult Function(DateTime cancelledAt) cancelled,
    required TResult Function(String message, Object? exception) error,
  }) {
    return countingDown(secondsRemaining, triggeredAt);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? armed,
    TResult? Function(int secondsRemaining, DateTime triggeredAt)? countingDown,
    TResult? Function(DateTime activatedAt, String? alertId)? active,
    TResult? Function(DateTime cancelledAt)? cancelled,
    TResult? Function(String message, Object? exception)? error,
  }) {
    return countingDown?.call(secondsRemaining, triggeredAt);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? armed,
    TResult Function(int secondsRemaining, DateTime triggeredAt)? countingDown,
    TResult Function(DateTime activatedAt, String? alertId)? active,
    TResult Function(DateTime cancelledAt)? cancelled,
    TResult Function(String message, Object? exception)? error,
    required TResult orElse(),
  }) {
    if (countingDown != null) {
      return countingDown(secondsRemaining, triggeredAt);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PanicStateIdle value) idle,
    required TResult Function(PanicStateArmed value) armed,
    required TResult Function(PanicStateCountingDown value) countingDown,
    required TResult Function(PanicStateActive value) active,
    required TResult Function(PanicStateCancelled value) cancelled,
    required TResult Function(PanicStateError value) error,
  }) {
    return countingDown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PanicStateIdle value)? idle,
    TResult? Function(PanicStateArmed value)? armed,
    TResult? Function(PanicStateCountingDown value)? countingDown,
    TResult? Function(PanicStateActive value)? active,
    TResult? Function(PanicStateCancelled value)? cancelled,
    TResult? Function(PanicStateError value)? error,
  }) {
    return countingDown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PanicStateIdle value)? idle,
    TResult Function(PanicStateArmed value)? armed,
    TResult Function(PanicStateCountingDown value)? countingDown,
    TResult Function(PanicStateActive value)? active,
    TResult Function(PanicStateCancelled value)? cancelled,
    TResult Function(PanicStateError value)? error,
    required TResult orElse(),
  }) {
    if (countingDown != null) {
      return countingDown(this);
    }
    return orElse();
  }
}

abstract class PanicStateCountingDown implements PanicState {
  const factory PanicStateCountingDown({
    required final int secondsRemaining,
    required final DateTime triggeredAt,
  }) = _$PanicStateCountingDownImpl;

  int get secondsRemaining;
  DateTime get triggeredAt;

  /// Create a copy of PanicState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PanicStateCountingDownImplCopyWith<_$PanicStateCountingDownImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PanicStateActiveImplCopyWith<$Res> {
  factory _$$PanicStateActiveImplCopyWith(
    _$PanicStateActiveImpl value,
    $Res Function(_$PanicStateActiveImpl) then,
  ) = __$$PanicStateActiveImplCopyWithImpl<$Res>;
  @useResult
  $Res call({DateTime activatedAt, String? alertId});
}

/// @nodoc
class __$$PanicStateActiveImplCopyWithImpl<$Res>
    extends _$PanicStateCopyWithImpl<$Res, _$PanicStateActiveImpl>
    implements _$$PanicStateActiveImplCopyWith<$Res> {
  __$$PanicStateActiveImplCopyWithImpl(
    _$PanicStateActiveImpl _value,
    $Res Function(_$PanicStateActiveImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PanicState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? activatedAt = null, Object? alertId = freezed}) {
    return _then(
      _$PanicStateActiveImpl(
        activatedAt: null == activatedAt
            ? _value.activatedAt
            : activatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        alertId: freezed == alertId
            ? _value.alertId
            : alertId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$PanicStateActiveImpl implements PanicStateActive {
  const _$PanicStateActiveImpl({required this.activatedAt, this.alertId});

  @override
  final DateTime activatedAt;
  @override
  final String? alertId;

  @override
  String toString() {
    return 'PanicState.active(activatedAt: $activatedAt, alertId: $alertId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PanicStateActiveImpl &&
            (identical(other.activatedAt, activatedAt) ||
                other.activatedAt == activatedAt) &&
            (identical(other.alertId, alertId) || other.alertId == alertId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, activatedAt, alertId);

  /// Create a copy of PanicState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PanicStateActiveImplCopyWith<_$PanicStateActiveImpl> get copyWith =>
      __$$PanicStateActiveImplCopyWithImpl<_$PanicStateActiveImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() armed,
    required TResult Function(int secondsRemaining, DateTime triggeredAt)
    countingDown,
    required TResult Function(DateTime activatedAt, String? alertId) active,
    required TResult Function(DateTime cancelledAt) cancelled,
    required TResult Function(String message, Object? exception) error,
  }) {
    return active(activatedAt, alertId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? armed,
    TResult? Function(int secondsRemaining, DateTime triggeredAt)? countingDown,
    TResult? Function(DateTime activatedAt, String? alertId)? active,
    TResult? Function(DateTime cancelledAt)? cancelled,
    TResult? Function(String message, Object? exception)? error,
  }) {
    return active?.call(activatedAt, alertId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? armed,
    TResult Function(int secondsRemaining, DateTime triggeredAt)? countingDown,
    TResult Function(DateTime activatedAt, String? alertId)? active,
    TResult Function(DateTime cancelledAt)? cancelled,
    TResult Function(String message, Object? exception)? error,
    required TResult orElse(),
  }) {
    if (active != null) {
      return active(activatedAt, alertId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PanicStateIdle value) idle,
    required TResult Function(PanicStateArmed value) armed,
    required TResult Function(PanicStateCountingDown value) countingDown,
    required TResult Function(PanicStateActive value) active,
    required TResult Function(PanicStateCancelled value) cancelled,
    required TResult Function(PanicStateError value) error,
  }) {
    return active(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PanicStateIdle value)? idle,
    TResult? Function(PanicStateArmed value)? armed,
    TResult? Function(PanicStateCountingDown value)? countingDown,
    TResult? Function(PanicStateActive value)? active,
    TResult? Function(PanicStateCancelled value)? cancelled,
    TResult? Function(PanicStateError value)? error,
  }) {
    return active?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PanicStateIdle value)? idle,
    TResult Function(PanicStateArmed value)? armed,
    TResult Function(PanicStateCountingDown value)? countingDown,
    TResult Function(PanicStateActive value)? active,
    TResult Function(PanicStateCancelled value)? cancelled,
    TResult Function(PanicStateError value)? error,
    required TResult orElse(),
  }) {
    if (active != null) {
      return active(this);
    }
    return orElse();
  }
}

abstract class PanicStateActive implements PanicState {
  const factory PanicStateActive({
    required final DateTime activatedAt,
    final String? alertId,
  }) = _$PanicStateActiveImpl;

  DateTime get activatedAt;
  String? get alertId;

  /// Create a copy of PanicState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PanicStateActiveImplCopyWith<_$PanicStateActiveImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PanicStateCancelledImplCopyWith<$Res> {
  factory _$$PanicStateCancelledImplCopyWith(
    _$PanicStateCancelledImpl value,
    $Res Function(_$PanicStateCancelledImpl) then,
  ) = __$$PanicStateCancelledImplCopyWithImpl<$Res>;
  @useResult
  $Res call({DateTime cancelledAt});
}

/// @nodoc
class __$$PanicStateCancelledImplCopyWithImpl<$Res>
    extends _$PanicStateCopyWithImpl<$Res, _$PanicStateCancelledImpl>
    implements _$$PanicStateCancelledImplCopyWith<$Res> {
  __$$PanicStateCancelledImplCopyWithImpl(
    _$PanicStateCancelledImpl _value,
    $Res Function(_$PanicStateCancelledImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PanicState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? cancelledAt = null}) {
    return _then(
      _$PanicStateCancelledImpl(
        cancelledAt: null == cancelledAt
            ? _value.cancelledAt
            : cancelledAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$PanicStateCancelledImpl implements PanicStateCancelled {
  const _$PanicStateCancelledImpl({required this.cancelledAt});

  @override
  final DateTime cancelledAt;

  @override
  String toString() {
    return 'PanicState.cancelled(cancelledAt: $cancelledAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PanicStateCancelledImpl &&
            (identical(other.cancelledAt, cancelledAt) ||
                other.cancelledAt == cancelledAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, cancelledAt);

  /// Create a copy of PanicState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PanicStateCancelledImplCopyWith<_$PanicStateCancelledImpl> get copyWith =>
      __$$PanicStateCancelledImplCopyWithImpl<_$PanicStateCancelledImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() armed,
    required TResult Function(int secondsRemaining, DateTime triggeredAt)
    countingDown,
    required TResult Function(DateTime activatedAt, String? alertId) active,
    required TResult Function(DateTime cancelledAt) cancelled,
    required TResult Function(String message, Object? exception) error,
  }) {
    return cancelled(cancelledAt);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? armed,
    TResult? Function(int secondsRemaining, DateTime triggeredAt)? countingDown,
    TResult? Function(DateTime activatedAt, String? alertId)? active,
    TResult? Function(DateTime cancelledAt)? cancelled,
    TResult? Function(String message, Object? exception)? error,
  }) {
    return cancelled?.call(cancelledAt);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? armed,
    TResult Function(int secondsRemaining, DateTime triggeredAt)? countingDown,
    TResult Function(DateTime activatedAt, String? alertId)? active,
    TResult Function(DateTime cancelledAt)? cancelled,
    TResult Function(String message, Object? exception)? error,
    required TResult orElse(),
  }) {
    if (cancelled != null) {
      return cancelled(cancelledAt);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PanicStateIdle value) idle,
    required TResult Function(PanicStateArmed value) armed,
    required TResult Function(PanicStateCountingDown value) countingDown,
    required TResult Function(PanicStateActive value) active,
    required TResult Function(PanicStateCancelled value) cancelled,
    required TResult Function(PanicStateError value) error,
  }) {
    return cancelled(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PanicStateIdle value)? idle,
    TResult? Function(PanicStateArmed value)? armed,
    TResult? Function(PanicStateCountingDown value)? countingDown,
    TResult? Function(PanicStateActive value)? active,
    TResult? Function(PanicStateCancelled value)? cancelled,
    TResult? Function(PanicStateError value)? error,
  }) {
    return cancelled?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PanicStateIdle value)? idle,
    TResult Function(PanicStateArmed value)? armed,
    TResult Function(PanicStateCountingDown value)? countingDown,
    TResult Function(PanicStateActive value)? active,
    TResult Function(PanicStateCancelled value)? cancelled,
    TResult Function(PanicStateError value)? error,
    required TResult orElse(),
  }) {
    if (cancelled != null) {
      return cancelled(this);
    }
    return orElse();
  }
}

abstract class PanicStateCancelled implements PanicState {
  const factory PanicStateCancelled({required final DateTime cancelledAt}) =
      _$PanicStateCancelledImpl;

  DateTime get cancelledAt;

  /// Create a copy of PanicState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PanicStateCancelledImplCopyWith<_$PanicStateCancelledImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PanicStateErrorImplCopyWith<$Res> {
  factory _$$PanicStateErrorImplCopyWith(
    _$PanicStateErrorImpl value,
    $Res Function(_$PanicStateErrorImpl) then,
  ) = __$$PanicStateErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, Object? exception});
}

/// @nodoc
class __$$PanicStateErrorImplCopyWithImpl<$Res>
    extends _$PanicStateCopyWithImpl<$Res, _$PanicStateErrorImpl>
    implements _$$PanicStateErrorImplCopyWith<$Res> {
  __$$PanicStateErrorImplCopyWithImpl(
    _$PanicStateErrorImpl _value,
    $Res Function(_$PanicStateErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PanicState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? exception = freezed}) {
    return _then(
      _$PanicStateErrorImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        exception: freezed == exception ? _value.exception : exception,
      ),
    );
  }
}

/// @nodoc

class _$PanicStateErrorImpl implements PanicStateError {
  const _$PanicStateErrorImpl({required this.message, this.exception});

  @override
  final String message;
  @override
  final Object? exception;

  @override
  String toString() {
    return 'PanicState.error(message: $message, exception: $exception)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PanicStateErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other.exception, exception));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    const DeepCollectionEquality().hash(exception),
  );

  /// Create a copy of PanicState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PanicStateErrorImplCopyWith<_$PanicStateErrorImpl> get copyWith =>
      __$$PanicStateErrorImplCopyWithImpl<_$PanicStateErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() armed,
    required TResult Function(int secondsRemaining, DateTime triggeredAt)
    countingDown,
    required TResult Function(DateTime activatedAt, String? alertId) active,
    required TResult Function(DateTime cancelledAt) cancelled,
    required TResult Function(String message, Object? exception) error,
  }) {
    return error(message, exception);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? armed,
    TResult? Function(int secondsRemaining, DateTime triggeredAt)? countingDown,
    TResult? Function(DateTime activatedAt, String? alertId)? active,
    TResult? Function(DateTime cancelledAt)? cancelled,
    TResult? Function(String message, Object? exception)? error,
  }) {
    return error?.call(message, exception);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? armed,
    TResult Function(int secondsRemaining, DateTime triggeredAt)? countingDown,
    TResult Function(DateTime activatedAt, String? alertId)? active,
    TResult Function(DateTime cancelledAt)? cancelled,
    TResult Function(String message, Object? exception)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message, exception);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PanicStateIdle value) idle,
    required TResult Function(PanicStateArmed value) armed,
    required TResult Function(PanicStateCountingDown value) countingDown,
    required TResult Function(PanicStateActive value) active,
    required TResult Function(PanicStateCancelled value) cancelled,
    required TResult Function(PanicStateError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PanicStateIdle value)? idle,
    TResult? Function(PanicStateArmed value)? armed,
    TResult? Function(PanicStateCountingDown value)? countingDown,
    TResult? Function(PanicStateActive value)? active,
    TResult? Function(PanicStateCancelled value)? cancelled,
    TResult? Function(PanicStateError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PanicStateIdle value)? idle,
    TResult Function(PanicStateArmed value)? armed,
    TResult Function(PanicStateCountingDown value)? countingDown,
    TResult Function(PanicStateActive value)? active,
    TResult Function(PanicStateCancelled value)? cancelled,
    TResult Function(PanicStateError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class PanicStateError implements PanicState {
  const factory PanicStateError({
    required final String message,
    final Object? exception,
  }) = _$PanicStateErrorImpl;

  String get message;
  Object? get exception;

  /// Create a copy of PanicState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PanicStateErrorImplCopyWith<_$PanicStateErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
