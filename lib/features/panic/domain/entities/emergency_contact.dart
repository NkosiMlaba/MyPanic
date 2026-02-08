/// Emergency contact entity.
///
/// Represents a contact who should be notified during an emergency.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'emergency_contact.freezed.dart';
part 'emergency_contact.g.dart';

/// An emergency contact that will be notified during a panic alert.
@freezed
class EmergencyContact with _$EmergencyContact {
  const factory EmergencyContact({
    required String id,
    required String name,
    required String phone,
    String? email,
    String? relationship,
    @Default(true) bool isActive,
    @Default(1) int priority, // 1 = highest priority
  }) = _EmergencyContact;

  factory EmergencyContact.fromJson(Map<String, dynamic> json) =>
      _$EmergencyContactFromJson(json);
}
