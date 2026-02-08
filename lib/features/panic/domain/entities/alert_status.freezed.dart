// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alert_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AlertStatus _$AlertStatusFromJson(Map<String, dynamic> json) {
  return _AlertStatus.fromJson(json);
}

/// @nodoc
mixin _$AlertStatus {
  String get alertId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  AlertState get state => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  List<String> get notifiedContacts => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Serializes this AlertStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AlertStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlertStatusCopyWith<AlertStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlertStatusCopyWith<$Res> {
  factory $AlertStatusCopyWith(
    AlertStatus value,
    $Res Function(AlertStatus) then,
  ) = _$AlertStatusCopyWithImpl<$Res, AlertStatus>;
  @useResult
  $Res call({
    String alertId,
    DateTime createdAt,
    AlertState state,
    double? latitude,
    double? longitude,
    List<String> notifiedContacts,
    String? errorMessage,
  });
}

/// @nodoc
class _$AlertStatusCopyWithImpl<$Res, $Val extends AlertStatus>
    implements $AlertStatusCopyWith<$Res> {
  _$AlertStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AlertStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? alertId = null,
    Object? createdAt = null,
    Object? state = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? notifiedContacts = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            alertId: null == alertId
                ? _value.alertId
                : alertId // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            state: null == state
                ? _value.state
                : state // ignore: cast_nullable_to_non_nullable
                      as AlertState,
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            notifiedContacts: null == notifiedContacts
                ? _value.notifiedContacts
                : notifiedContacts // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AlertStatusImplCopyWith<$Res>
    implements $AlertStatusCopyWith<$Res> {
  factory _$$AlertStatusImplCopyWith(
    _$AlertStatusImpl value,
    $Res Function(_$AlertStatusImpl) then,
  ) = __$$AlertStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String alertId,
    DateTime createdAt,
    AlertState state,
    double? latitude,
    double? longitude,
    List<String> notifiedContacts,
    String? errorMessage,
  });
}

/// @nodoc
class __$$AlertStatusImplCopyWithImpl<$Res>
    extends _$AlertStatusCopyWithImpl<$Res, _$AlertStatusImpl>
    implements _$$AlertStatusImplCopyWith<$Res> {
  __$$AlertStatusImplCopyWithImpl(
    _$AlertStatusImpl _value,
    $Res Function(_$AlertStatusImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AlertStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? alertId = null,
    Object? createdAt = null,
    Object? state = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? notifiedContacts = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$AlertStatusImpl(
        alertId: null == alertId
            ? _value.alertId
            : alertId // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        state: null == state
            ? _value.state
            : state // ignore: cast_nullable_to_non_nullable
                  as AlertState,
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        notifiedContacts: null == notifiedContacts
            ? _value._notifiedContacts
            : notifiedContacts // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AlertStatusImpl implements _AlertStatus {
  const _$AlertStatusImpl({
    required this.alertId,
    required this.createdAt,
    required this.state,
    this.latitude,
    this.longitude,
    final List<String> notifiedContacts = const [],
    this.errorMessage,
  }) : _notifiedContacts = notifiedContacts;

  factory _$AlertStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlertStatusImplFromJson(json);

  @override
  final String alertId;
  @override
  final DateTime createdAt;
  @override
  final AlertState state;
  @override
  final double? latitude;
  @override
  final double? longitude;
  final List<String> _notifiedContacts;
  @override
  @JsonKey()
  List<String> get notifiedContacts {
    if (_notifiedContacts is EqualUnmodifiableListView)
      return _notifiedContacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notifiedContacts);
  }

  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'AlertStatus(alertId: $alertId, createdAt: $createdAt, state: $state, latitude: $latitude, longitude: $longitude, notifiedContacts: $notifiedContacts, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlertStatusImpl &&
            (identical(other.alertId, alertId) || other.alertId == alertId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            const DeepCollectionEquality().equals(
              other._notifiedContacts,
              _notifiedContacts,
            ) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    alertId,
    createdAt,
    state,
    latitude,
    longitude,
    const DeepCollectionEquality().hash(_notifiedContacts),
    errorMessage,
  );

  /// Create a copy of AlertStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlertStatusImplCopyWith<_$AlertStatusImpl> get copyWith =>
      __$$AlertStatusImplCopyWithImpl<_$AlertStatusImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlertStatusImplToJson(this);
  }
}

abstract class _AlertStatus implements AlertStatus {
  const factory _AlertStatus({
    required final String alertId,
    required final DateTime createdAt,
    required final AlertState state,
    final double? latitude,
    final double? longitude,
    final List<String> notifiedContacts,
    final String? errorMessage,
  }) = _$AlertStatusImpl;

  factory _AlertStatus.fromJson(Map<String, dynamic> json) =
      _$AlertStatusImpl.fromJson;

  @override
  String get alertId;
  @override
  DateTime get createdAt;
  @override
  AlertState get state;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  List<String> get notifiedContacts;
  @override
  String? get errorMessage;

  /// Create a copy of AlertStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlertStatusImplCopyWith<_$AlertStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
