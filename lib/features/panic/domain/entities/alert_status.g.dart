// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AlertStatus _$AlertStatusFromJson(Map<String, dynamic> json) => _AlertStatus(
  alertId: json['alertId'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  state: $enumDecode(_$AlertStateEnumMap, json['state']),
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  notifiedContacts:
      (json['notifiedContacts'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  errorMessage: json['errorMessage'] as String?,
);

Map<String, dynamic> _$AlertStatusToJson(_AlertStatus instance) =>
    <String, dynamic>{
      'alertId': instance.alertId,
      'createdAt': instance.createdAt.toIso8601String(),
      'state': _$AlertStateEnumMap[instance.state]!,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'notifiedContacts': instance.notifiedContacts,
      'errorMessage': instance.errorMessage,
    };

const _$AlertStateEnumMap = {
  AlertState.pending: 'pending',
  AlertState.sending: 'sending',
  AlertState.sent: 'sent',
  AlertState.acknowledged: 'acknowledged',
  AlertState.resolved: 'resolved',
  AlertState.failed: 'failed',
};
