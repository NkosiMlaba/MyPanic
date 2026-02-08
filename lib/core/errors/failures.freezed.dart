// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failures.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Failure {
  String get message => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, String? permissionType)
    permission,
    required TResult Function(String message, String? errorCode) location,
    required TResult Function(String message, List<String>? failedNumbers) sms,
    required TResult Function(String message, int? statusCode) network,
    required TResult Function(String message, Object? exception) unexpected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, String? permissionType)? permission,
    TResult? Function(String message, String? errorCode)? location,
    TResult? Function(String message, List<String>? failedNumbers)? sms,
    TResult? Function(String message, int? statusCode)? network,
    TResult? Function(String message, Object? exception)? unexpected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, String? permissionType)? permission,
    TResult Function(String message, String? errorCode)? location,
    TResult Function(String message, List<String>? failedNumbers)? sms,
    TResult Function(String message, int? statusCode)? network,
    TResult Function(String message, Object? exception)? unexpected,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(LocationFailure value) location,
    required TResult Function(SmsFailure value) sms,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(UnexpectedFailure value) unexpected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(LocationFailure value)? location,
    TResult? Function(SmsFailure value)? sms,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(UnexpectedFailure value)? unexpected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PermissionFailure value)? permission,
    TResult Function(LocationFailure value)? location,
    TResult Function(SmsFailure value)? sms,
    TResult Function(NetworkFailure value)? network,
    TResult Function(UnexpectedFailure value)? unexpected,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FailureCopyWith<Failure> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FailureCopyWith<$Res> {
  factory $FailureCopyWith(Failure value, $Res Function(Failure) then) =
      _$FailureCopyWithImpl<$Res, Failure>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$FailureCopyWithImpl<$Res, $Val extends Failure>
    implements $FailureCopyWith<$Res> {
  _$FailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _value.copyWith(
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PermissionFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$PermissionFailureImplCopyWith(
    _$PermissionFailureImpl value,
    $Res Function(_$PermissionFailureImpl) then,
  ) = __$$PermissionFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, String? permissionType});
}

/// @nodoc
class __$$PermissionFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$PermissionFailureImpl>
    implements _$$PermissionFailureImplCopyWith<$Res> {
  __$$PermissionFailureImplCopyWithImpl(
    _$PermissionFailureImpl _value,
    $Res Function(_$PermissionFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? permissionType = freezed}) {
    return _then(
      _$PermissionFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        permissionType: freezed == permissionType
            ? _value.permissionType
            : permissionType // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$PermissionFailureImpl implements PermissionFailure {
  const _$PermissionFailureImpl({required this.message, this.permissionType});

  @override
  final String message;
  @override
  final String? permissionType;

  @override
  String toString() {
    return 'Failure.permission(message: $message, permissionType: $permissionType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PermissionFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.permissionType, permissionType) ||
                other.permissionType == permissionType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, permissionType);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PermissionFailureImplCopyWith<_$PermissionFailureImpl> get copyWith =>
      __$$PermissionFailureImplCopyWithImpl<_$PermissionFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, String? permissionType)
    permission,
    required TResult Function(String message, String? errorCode) location,
    required TResult Function(String message, List<String>? failedNumbers) sms,
    required TResult Function(String message, int? statusCode) network,
    required TResult Function(String message, Object? exception) unexpected,
  }) {
    return permission(message, permissionType);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, String? permissionType)? permission,
    TResult? Function(String message, String? errorCode)? location,
    TResult? Function(String message, List<String>? failedNumbers)? sms,
    TResult? Function(String message, int? statusCode)? network,
    TResult? Function(String message, Object? exception)? unexpected,
  }) {
    return permission?.call(message, permissionType);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, String? permissionType)? permission,
    TResult Function(String message, String? errorCode)? location,
    TResult Function(String message, List<String>? failedNumbers)? sms,
    TResult Function(String message, int? statusCode)? network,
    TResult Function(String message, Object? exception)? unexpected,
    required TResult orElse(),
  }) {
    if (permission != null) {
      return permission(message, permissionType);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(LocationFailure value) location,
    required TResult Function(SmsFailure value) sms,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(UnexpectedFailure value) unexpected,
  }) {
    return permission(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(LocationFailure value)? location,
    TResult? Function(SmsFailure value)? sms,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(UnexpectedFailure value)? unexpected,
  }) {
    return permission?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PermissionFailure value)? permission,
    TResult Function(LocationFailure value)? location,
    TResult Function(SmsFailure value)? sms,
    TResult Function(NetworkFailure value)? network,
    TResult Function(UnexpectedFailure value)? unexpected,
    required TResult orElse(),
  }) {
    if (permission != null) {
      return permission(this);
    }
    return orElse();
  }
}

abstract class PermissionFailure implements Failure {
  const factory PermissionFailure({
    required final String message,
    final String? permissionType,
  }) = _$PermissionFailureImpl;

  @override
  String get message;
  String? get permissionType;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PermissionFailureImplCopyWith<_$PermissionFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LocationFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$LocationFailureImplCopyWith(
    _$LocationFailureImpl value,
    $Res Function(_$LocationFailureImpl) then,
  ) = __$$LocationFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, String? errorCode});
}

/// @nodoc
class __$$LocationFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$LocationFailureImpl>
    implements _$$LocationFailureImplCopyWith<$Res> {
  __$$LocationFailureImplCopyWithImpl(
    _$LocationFailureImpl _value,
    $Res Function(_$LocationFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? errorCode = freezed}) {
    return _then(
      _$LocationFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        errorCode: freezed == errorCode
            ? _value.errorCode
            : errorCode // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$LocationFailureImpl implements LocationFailure {
  const _$LocationFailureImpl({required this.message, this.errorCode});

  @override
  final String message;
  @override
  final String? errorCode;

  @override
  String toString() {
    return 'Failure.location(message: $message, errorCode: $errorCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.errorCode, errorCode) ||
                other.errorCode == errorCode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, errorCode);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationFailureImplCopyWith<_$LocationFailureImpl> get copyWith =>
      __$$LocationFailureImplCopyWithImpl<_$LocationFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, String? permissionType)
    permission,
    required TResult Function(String message, String? errorCode) location,
    required TResult Function(String message, List<String>? failedNumbers) sms,
    required TResult Function(String message, int? statusCode) network,
    required TResult Function(String message, Object? exception) unexpected,
  }) {
    return location(message, errorCode);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, String? permissionType)? permission,
    TResult? Function(String message, String? errorCode)? location,
    TResult? Function(String message, List<String>? failedNumbers)? sms,
    TResult? Function(String message, int? statusCode)? network,
    TResult? Function(String message, Object? exception)? unexpected,
  }) {
    return location?.call(message, errorCode);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, String? permissionType)? permission,
    TResult Function(String message, String? errorCode)? location,
    TResult Function(String message, List<String>? failedNumbers)? sms,
    TResult Function(String message, int? statusCode)? network,
    TResult Function(String message, Object? exception)? unexpected,
    required TResult orElse(),
  }) {
    if (location != null) {
      return location(message, errorCode);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(LocationFailure value) location,
    required TResult Function(SmsFailure value) sms,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(UnexpectedFailure value) unexpected,
  }) {
    return location(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(LocationFailure value)? location,
    TResult? Function(SmsFailure value)? sms,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(UnexpectedFailure value)? unexpected,
  }) {
    return location?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PermissionFailure value)? permission,
    TResult Function(LocationFailure value)? location,
    TResult Function(SmsFailure value)? sms,
    TResult Function(NetworkFailure value)? network,
    TResult Function(UnexpectedFailure value)? unexpected,
    required TResult orElse(),
  }) {
    if (location != null) {
      return location(this);
    }
    return orElse();
  }
}

abstract class LocationFailure implements Failure {
  const factory LocationFailure({
    required final String message,
    final String? errorCode,
  }) = _$LocationFailureImpl;

  @override
  String get message;
  String? get errorCode;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationFailureImplCopyWith<_$LocationFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SmsFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$SmsFailureImplCopyWith(
    _$SmsFailureImpl value,
    $Res Function(_$SmsFailureImpl) then,
  ) = __$$SmsFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, List<String>? failedNumbers});
}

/// @nodoc
class __$$SmsFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$SmsFailureImpl>
    implements _$$SmsFailureImplCopyWith<$Res> {
  __$$SmsFailureImplCopyWithImpl(
    _$SmsFailureImpl _value,
    $Res Function(_$SmsFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? failedNumbers = freezed}) {
    return _then(
      _$SmsFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        failedNumbers: freezed == failedNumbers
            ? _value._failedNumbers
            : failedNumbers // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
      ),
    );
  }
}

/// @nodoc

class _$SmsFailureImpl implements SmsFailure {
  const _$SmsFailureImpl({
    required this.message,
    final List<String>? failedNumbers,
  }) : _failedNumbers = failedNumbers;

  @override
  final String message;
  final List<String>? _failedNumbers;
  @override
  List<String>? get failedNumbers {
    final value = _failedNumbers;
    if (value == null) return null;
    if (_failedNumbers is EqualUnmodifiableListView) return _failedNumbers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Failure.sms(message: $message, failedNumbers: $failedNumbers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SmsFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(
              other._failedNumbers,
              _failedNumbers,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    const DeepCollectionEquality().hash(_failedNumbers),
  );

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SmsFailureImplCopyWith<_$SmsFailureImpl> get copyWith =>
      __$$SmsFailureImplCopyWithImpl<_$SmsFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, String? permissionType)
    permission,
    required TResult Function(String message, String? errorCode) location,
    required TResult Function(String message, List<String>? failedNumbers) sms,
    required TResult Function(String message, int? statusCode) network,
    required TResult Function(String message, Object? exception) unexpected,
  }) {
    return sms(message, failedNumbers);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, String? permissionType)? permission,
    TResult? Function(String message, String? errorCode)? location,
    TResult? Function(String message, List<String>? failedNumbers)? sms,
    TResult? Function(String message, int? statusCode)? network,
    TResult? Function(String message, Object? exception)? unexpected,
  }) {
    return sms?.call(message, failedNumbers);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, String? permissionType)? permission,
    TResult Function(String message, String? errorCode)? location,
    TResult Function(String message, List<String>? failedNumbers)? sms,
    TResult Function(String message, int? statusCode)? network,
    TResult Function(String message, Object? exception)? unexpected,
    required TResult orElse(),
  }) {
    if (sms != null) {
      return sms(message, failedNumbers);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(LocationFailure value) location,
    required TResult Function(SmsFailure value) sms,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(UnexpectedFailure value) unexpected,
  }) {
    return sms(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(LocationFailure value)? location,
    TResult? Function(SmsFailure value)? sms,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(UnexpectedFailure value)? unexpected,
  }) {
    return sms?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PermissionFailure value)? permission,
    TResult Function(LocationFailure value)? location,
    TResult Function(SmsFailure value)? sms,
    TResult Function(NetworkFailure value)? network,
    TResult Function(UnexpectedFailure value)? unexpected,
    required TResult orElse(),
  }) {
    if (sms != null) {
      return sms(this);
    }
    return orElse();
  }
}

abstract class SmsFailure implements Failure {
  const factory SmsFailure({
    required final String message,
    final List<String>? failedNumbers,
  }) = _$SmsFailureImpl;

  @override
  String get message;
  List<String>? get failedNumbers;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SmsFailureImplCopyWith<_$SmsFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NetworkFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$NetworkFailureImplCopyWith(
    _$NetworkFailureImpl value,
    $Res Function(_$NetworkFailureImpl) then,
  ) = __$$NetworkFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, int? statusCode});
}

/// @nodoc
class __$$NetworkFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$NetworkFailureImpl>
    implements _$$NetworkFailureImplCopyWith<$Res> {
  __$$NetworkFailureImplCopyWithImpl(
    _$NetworkFailureImpl _value,
    $Res Function(_$NetworkFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? statusCode = freezed}) {
    return _then(
      _$NetworkFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        statusCode: freezed == statusCode
            ? _value.statusCode
            : statusCode // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$NetworkFailureImpl implements NetworkFailure {
  const _$NetworkFailureImpl({required this.message, this.statusCode});

  @override
  final String message;
  @override
  final int? statusCode;

  @override
  String toString() {
    return 'Failure.network(message: $message, statusCode: $statusCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, statusCode);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkFailureImplCopyWith<_$NetworkFailureImpl> get copyWith =>
      __$$NetworkFailureImplCopyWithImpl<_$NetworkFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, String? permissionType)
    permission,
    required TResult Function(String message, String? errorCode) location,
    required TResult Function(String message, List<String>? failedNumbers) sms,
    required TResult Function(String message, int? statusCode) network,
    required TResult Function(String message, Object? exception) unexpected,
  }) {
    return network(message, statusCode);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, String? permissionType)? permission,
    TResult? Function(String message, String? errorCode)? location,
    TResult? Function(String message, List<String>? failedNumbers)? sms,
    TResult? Function(String message, int? statusCode)? network,
    TResult? Function(String message, Object? exception)? unexpected,
  }) {
    return network?.call(message, statusCode);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, String? permissionType)? permission,
    TResult Function(String message, String? errorCode)? location,
    TResult Function(String message, List<String>? failedNumbers)? sms,
    TResult Function(String message, int? statusCode)? network,
    TResult Function(String message, Object? exception)? unexpected,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(message, statusCode);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(LocationFailure value) location,
    required TResult Function(SmsFailure value) sms,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(UnexpectedFailure value) unexpected,
  }) {
    return network(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(LocationFailure value)? location,
    TResult? Function(SmsFailure value)? sms,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(UnexpectedFailure value)? unexpected,
  }) {
    return network?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PermissionFailure value)? permission,
    TResult Function(LocationFailure value)? location,
    TResult Function(SmsFailure value)? sms,
    TResult Function(NetworkFailure value)? network,
    TResult Function(UnexpectedFailure value)? unexpected,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(this);
    }
    return orElse();
  }
}

abstract class NetworkFailure implements Failure {
  const factory NetworkFailure({
    required final String message,
    final int? statusCode,
  }) = _$NetworkFailureImpl;

  @override
  String get message;
  int? get statusCode;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NetworkFailureImplCopyWith<_$NetworkFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnexpectedFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$UnexpectedFailureImplCopyWith(
    _$UnexpectedFailureImpl value,
    $Res Function(_$UnexpectedFailureImpl) then,
  ) = __$$UnexpectedFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, Object? exception});
}

/// @nodoc
class __$$UnexpectedFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$UnexpectedFailureImpl>
    implements _$$UnexpectedFailureImplCopyWith<$Res> {
  __$$UnexpectedFailureImplCopyWithImpl(
    _$UnexpectedFailureImpl _value,
    $Res Function(_$UnexpectedFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? exception = freezed}) {
    return _then(
      _$UnexpectedFailureImpl(
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

class _$UnexpectedFailureImpl implements UnexpectedFailure {
  const _$UnexpectedFailureImpl({required this.message, this.exception});

  @override
  final String message;
  @override
  final Object? exception;

  @override
  String toString() {
    return 'Failure.unexpected(message: $message, exception: $exception)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnexpectedFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other.exception, exception));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    const DeepCollectionEquality().hash(exception),
  );

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnexpectedFailureImplCopyWith<_$UnexpectedFailureImpl> get copyWith =>
      __$$UnexpectedFailureImplCopyWithImpl<_$UnexpectedFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, String? permissionType)
    permission,
    required TResult Function(String message, String? errorCode) location,
    required TResult Function(String message, List<String>? failedNumbers) sms,
    required TResult Function(String message, int? statusCode) network,
    required TResult Function(String message, Object? exception) unexpected,
  }) {
    return unexpected(message, exception);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, String? permissionType)? permission,
    TResult? Function(String message, String? errorCode)? location,
    TResult? Function(String message, List<String>? failedNumbers)? sms,
    TResult? Function(String message, int? statusCode)? network,
    TResult? Function(String message, Object? exception)? unexpected,
  }) {
    return unexpected?.call(message, exception);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, String? permissionType)? permission,
    TResult Function(String message, String? errorCode)? location,
    TResult Function(String message, List<String>? failedNumbers)? sms,
    TResult Function(String message, int? statusCode)? network,
    TResult Function(String message, Object? exception)? unexpected,
    required TResult orElse(),
  }) {
    if (unexpected != null) {
      return unexpected(message, exception);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(LocationFailure value) location,
    required TResult Function(SmsFailure value) sms,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(UnexpectedFailure value) unexpected,
  }) {
    return unexpected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(LocationFailure value)? location,
    TResult? Function(SmsFailure value)? sms,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(UnexpectedFailure value)? unexpected,
  }) {
    return unexpected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PermissionFailure value)? permission,
    TResult Function(LocationFailure value)? location,
    TResult Function(SmsFailure value)? sms,
    TResult Function(NetworkFailure value)? network,
    TResult Function(UnexpectedFailure value)? unexpected,
    required TResult orElse(),
  }) {
    if (unexpected != null) {
      return unexpected(this);
    }
    return orElse();
  }
}

abstract class UnexpectedFailure implements Failure {
  const factory UnexpectedFailure({
    required final String message,
    final Object? exception,
  }) = _$UnexpectedFailureImpl;

  @override
  String get message;
  Object? get exception;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnexpectedFailureImplCopyWith<_$UnexpectedFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
