// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserProfile {

 String get uid; String get email; String get firstName; String get lastName; String get phoneNumber; MedicalProfile get medicalProfile; bool get isProfileComplete; int get countdownDuration;
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.medicalProfile, medicalProfile) || other.medicalProfile == medicalProfile)&&(identical(other.isProfileComplete, isProfileComplete) || other.isProfileComplete == isProfileComplete)&&(identical(other.countdownDuration, countdownDuration) || other.countdownDuration == countdownDuration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,email,firstName,lastName,phoneNumber,medicalProfile,isProfileComplete,countdownDuration);

@override
String toString() {
  return 'UserProfile(uid: $uid, email: $email, firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber, medicalProfile: $medicalProfile, isProfileComplete: $isProfileComplete, countdownDuration: $countdownDuration)';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res>  {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@useResult
$Res call({
 String uid, String email, String firstName, String lastName, String phoneNumber, MedicalProfile medicalProfile, bool isProfileComplete, int countdownDuration
});




}
/// @nodoc
class _$UserProfileCopyWithImpl<$Res>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? email = null,Object? firstName = null,Object? lastName = null,Object? phoneNumber = null,Object? medicalProfile = null,Object? isProfileComplete = null,Object? countdownDuration = null,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,medicalProfile: null == medicalProfile ? _self.medicalProfile : medicalProfile // ignore: cast_nullable_to_non_nullable
as MedicalProfile,isProfileComplete: null == isProfileComplete ? _self.isProfileComplete : isProfileComplete // ignore: cast_nullable_to_non_nullable
as bool,countdownDuration: null == countdownDuration ? _self.countdownDuration : countdownDuration // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfile].
extension UserProfilePatterns on UserProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfile value)  $default,){
final _that = this;
switch (_that) {
case _UserProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfile value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String email,  String firstName,  String lastName,  String phoneNumber,  MedicalProfile medicalProfile,  bool isProfileComplete,  int countdownDuration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.uid,_that.email,_that.firstName,_that.lastName,_that.phoneNumber,_that.medicalProfile,_that.isProfileComplete,_that.countdownDuration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String email,  String firstName,  String lastName,  String phoneNumber,  MedicalProfile medicalProfile,  bool isProfileComplete,  int countdownDuration)  $default,) {final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that.uid,_that.email,_that.firstName,_that.lastName,_that.phoneNumber,_that.medicalProfile,_that.isProfileComplete,_that.countdownDuration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String email,  String firstName,  String lastName,  String phoneNumber,  MedicalProfile medicalProfile,  bool isProfileComplete,  int countdownDuration)?  $default,) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.uid,_that.email,_that.firstName,_that.lastName,_that.phoneNumber,_that.medicalProfile,_that.isProfileComplete,_that.countdownDuration);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserProfile implements UserProfile {
  const _UserProfile({required this.uid, required this.email, required this.firstName, required this.lastName, required this.phoneNumber, required this.medicalProfile, this.isProfileComplete = false, this.countdownDuration = 30});
  factory _UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);

@override final  String uid;
@override final  String email;
@override final  String firstName;
@override final  String lastName;
@override final  String phoneNumber;
@override final  MedicalProfile medicalProfile;
@override@JsonKey() final  bool isProfileComplete;
@override@JsonKey() final  int countdownDuration;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileCopyWith<_UserProfile> get copyWith => __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfile&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.medicalProfile, medicalProfile) || other.medicalProfile == medicalProfile)&&(identical(other.isProfileComplete, isProfileComplete) || other.isProfileComplete == isProfileComplete)&&(identical(other.countdownDuration, countdownDuration) || other.countdownDuration == countdownDuration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,email,firstName,lastName,phoneNumber,medicalProfile,isProfileComplete,countdownDuration);

@override
String toString() {
  return 'UserProfile(uid: $uid, email: $email, firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber, medicalProfile: $medicalProfile, isProfileComplete: $isProfileComplete, countdownDuration: $countdownDuration)';
}


}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res> implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(_UserProfile value, $Res Function(_UserProfile) _then) = __$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 String uid, String email, String firstName, String lastName, String phoneNumber, MedicalProfile medicalProfile, bool isProfileComplete, int countdownDuration
});




}
/// @nodoc
class __$UserProfileCopyWithImpl<$Res>
    implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? email = null,Object? firstName = null,Object? lastName = null,Object? phoneNumber = null,Object? medicalProfile = null,Object? isProfileComplete = null,Object? countdownDuration = null,}) {
  return _then(_UserProfile(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,medicalProfile: null == medicalProfile ? _self.medicalProfile : medicalProfile // ignore: cast_nullable_to_non_nullable
as MedicalProfile,isProfileComplete: null == isProfileComplete ? _self.isProfileComplete : isProfileComplete // ignore: cast_nullable_to_non_nullable
as bool,countdownDuration: null == countdownDuration ? _self.countdownDuration : countdownDuration // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
