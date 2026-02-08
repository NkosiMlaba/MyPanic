// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medical_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MedicalProfile _$MedicalProfileFromJson(Map<String, dynamic> json) {
  return _MedicalProfile.fromJson(json);
}

/// @nodoc
mixin _$MedicalProfile {
  String? get bloodType => throw _privateConstructorUsedError;
  List<String> get allergies => throw _privateConstructorUsedError;
  List<String> get medications => throw _privateConstructorUsedError;
  List<String> get conditions => throw _privateConstructorUsedError;
  String? get emergencyNotes => throw _privateConstructorUsedError;
  String? get doctorName => throw _privateConstructorUsedError;
  String? get doctorPhone => throw _privateConstructorUsedError;

  /// Serializes this MedicalProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MedicalProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MedicalProfileCopyWith<MedicalProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicalProfileCopyWith<$Res> {
  factory $MedicalProfileCopyWith(
    MedicalProfile value,
    $Res Function(MedicalProfile) then,
  ) = _$MedicalProfileCopyWithImpl<$Res, MedicalProfile>;
  @useResult
  $Res call({
    String? bloodType,
    List<String> allergies,
    List<String> medications,
    List<String> conditions,
    String? emergencyNotes,
    String? doctorName,
    String? doctorPhone,
  });
}

/// @nodoc
class _$MedicalProfileCopyWithImpl<$Res, $Val extends MedicalProfile>
    implements $MedicalProfileCopyWith<$Res> {
  _$MedicalProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MedicalProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bloodType = freezed,
    Object? allergies = null,
    Object? medications = null,
    Object? conditions = null,
    Object? emergencyNotes = freezed,
    Object? doctorName = freezed,
    Object? doctorPhone = freezed,
  }) {
    return _then(
      _value.copyWith(
            bloodType: freezed == bloodType
                ? _value.bloodType
                : bloodType // ignore: cast_nullable_to_non_nullable
                      as String?,
            allergies: null == allergies
                ? _value.allergies
                : allergies // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            medications: null == medications
                ? _value.medications
                : medications // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            conditions: null == conditions
                ? _value.conditions
                : conditions // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            emergencyNotes: freezed == emergencyNotes
                ? _value.emergencyNotes
                : emergencyNotes // ignore: cast_nullable_to_non_nullable
                      as String?,
            doctorName: freezed == doctorName
                ? _value.doctorName
                : doctorName // ignore: cast_nullable_to_non_nullable
                      as String?,
            doctorPhone: freezed == doctorPhone
                ? _value.doctorPhone
                : doctorPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MedicalProfileImplCopyWith<$Res>
    implements $MedicalProfileCopyWith<$Res> {
  factory _$$MedicalProfileImplCopyWith(
    _$MedicalProfileImpl value,
    $Res Function(_$MedicalProfileImpl) then,
  ) = __$$MedicalProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? bloodType,
    List<String> allergies,
    List<String> medications,
    List<String> conditions,
    String? emergencyNotes,
    String? doctorName,
    String? doctorPhone,
  });
}

/// @nodoc
class __$$MedicalProfileImplCopyWithImpl<$Res>
    extends _$MedicalProfileCopyWithImpl<$Res, _$MedicalProfileImpl>
    implements _$$MedicalProfileImplCopyWith<$Res> {
  __$$MedicalProfileImplCopyWithImpl(
    _$MedicalProfileImpl _value,
    $Res Function(_$MedicalProfileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MedicalProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bloodType = freezed,
    Object? allergies = null,
    Object? medications = null,
    Object? conditions = null,
    Object? emergencyNotes = freezed,
    Object? doctorName = freezed,
    Object? doctorPhone = freezed,
  }) {
    return _then(
      _$MedicalProfileImpl(
        bloodType: freezed == bloodType
            ? _value.bloodType
            : bloodType // ignore: cast_nullable_to_non_nullable
                  as String?,
        allergies: null == allergies
            ? _value._allergies
            : allergies // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        medications: null == medications
            ? _value._medications
            : medications // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        conditions: null == conditions
            ? _value._conditions
            : conditions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        emergencyNotes: freezed == emergencyNotes
            ? _value.emergencyNotes
            : emergencyNotes // ignore: cast_nullable_to_non_nullable
                  as String?,
        doctorName: freezed == doctorName
            ? _value.doctorName
            : doctorName // ignore: cast_nullable_to_non_nullable
                  as String?,
        doctorPhone: freezed == doctorPhone
            ? _value.doctorPhone
            : doctorPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MedicalProfileImpl implements _MedicalProfile {
  const _$MedicalProfileImpl({
    this.bloodType,
    final List<String> allergies = const [],
    final List<String> medications = const [],
    final List<String> conditions = const [],
    this.emergencyNotes,
    this.doctorName,
    this.doctorPhone,
  }) : _allergies = allergies,
       _medications = medications,
       _conditions = conditions;

  factory _$MedicalProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$MedicalProfileImplFromJson(json);

  @override
  final String? bloodType;
  final List<String> _allergies;
  @override
  @JsonKey()
  List<String> get allergies {
    if (_allergies is EqualUnmodifiableListView) return _allergies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allergies);
  }

  final List<String> _medications;
  @override
  @JsonKey()
  List<String> get medications {
    if (_medications is EqualUnmodifiableListView) return _medications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_medications);
  }

  final List<String> _conditions;
  @override
  @JsonKey()
  List<String> get conditions {
    if (_conditions is EqualUnmodifiableListView) return _conditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_conditions);
  }

  @override
  final String? emergencyNotes;
  @override
  final String? doctorName;
  @override
  final String? doctorPhone;

  @override
  String toString() {
    return 'MedicalProfile(bloodType: $bloodType, allergies: $allergies, medications: $medications, conditions: $conditions, emergencyNotes: $emergencyNotes, doctorName: $doctorName, doctorPhone: $doctorPhone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicalProfileImpl &&
            (identical(other.bloodType, bloodType) ||
                other.bloodType == bloodType) &&
            const DeepCollectionEquality().equals(
              other._allergies,
              _allergies,
            ) &&
            const DeepCollectionEquality().equals(
              other._medications,
              _medications,
            ) &&
            const DeepCollectionEquality().equals(
              other._conditions,
              _conditions,
            ) &&
            (identical(other.emergencyNotes, emergencyNotes) ||
                other.emergencyNotes == emergencyNotes) &&
            (identical(other.doctorName, doctorName) ||
                other.doctorName == doctorName) &&
            (identical(other.doctorPhone, doctorPhone) ||
                other.doctorPhone == doctorPhone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    bloodType,
    const DeepCollectionEquality().hash(_allergies),
    const DeepCollectionEquality().hash(_medications),
    const DeepCollectionEquality().hash(_conditions),
    emergencyNotes,
    doctorName,
    doctorPhone,
  );

  /// Create a copy of MedicalProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MedicalProfileImplCopyWith<_$MedicalProfileImpl> get copyWith =>
      __$$MedicalProfileImplCopyWithImpl<_$MedicalProfileImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MedicalProfileImplToJson(this);
  }
}

abstract class _MedicalProfile implements MedicalProfile {
  const factory _MedicalProfile({
    final String? bloodType,
    final List<String> allergies,
    final List<String> medications,
    final List<String> conditions,
    final String? emergencyNotes,
    final String? doctorName,
    final String? doctorPhone,
  }) = _$MedicalProfileImpl;

  factory _MedicalProfile.fromJson(Map<String, dynamic> json) =
      _$MedicalProfileImpl.fromJson;

  @override
  String? get bloodType;
  @override
  List<String> get allergies;
  @override
  List<String> get medications;
  @override
  List<String> get conditions;
  @override
  String? get emergencyNotes;
  @override
  String? get doctorName;
  @override
  String? get doctorPhone;

  /// Create a copy of MedicalProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedicalProfileImplCopyWith<_$MedicalProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
