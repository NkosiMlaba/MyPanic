import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';

import 'package:my_panic/core/api/my_panic_api_client.dart';
import 'package:my_panic/features/panic/data/panic_repository.dart';
import 'package:my_panic/features/panic/domain/entities/alert_status.dart';

class _MockApi extends Mock implements MyPanicApiClient {}

Position _pos({double lat = -26.2041, double lng = 28.0473, double acc = 12}) {
  return Position(
    longitude: lng,
    latitude: lat,
    timestamp: DateTime.utc(2026, 5, 11, 12),
    accuracy: acc,
    altitude: 0,
    altitudeAccuracy: 0,
    heading: 0,
    headingAccuracy: 0,
    speed: 0,
    speedAccuracy: 0,
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  late _MockApi api;
  late PanicRepository repo;

  setUp(() {
    api = _MockApi();
    repo = PanicRepository(api);
  });

  group('PanicRepository', () {
    // ── Path 13: sendEmergencyAlert posts the correct payload ───────────
    test('POSTs /api/v1/alerts with lat/lng/accuracy/triggeredAt/key',
        () async {
      Map<String, dynamic>? captured;
      when(() => api.post('/api/v1/alerts', any())).thenAnswer((invocation) async {
        captured =
            invocation.positionalArguments[1] as Map<String, dynamic>;
        return {
          'alertId': 'alert-uuid-1',
          'status': 'Pending',
          'triggeredAt': '2026-05-11T12:00:00Z',
        };
      });

      final triggeredAt = DateTime.utc(2026, 5, 11, 12);
      final result = await repo.sendEmergencyAlert(
        location: _pos(),
        triggeredAt: triggeredAt,
      );

      expect(captured, isNotNull);
      expect(captured!['latitude'], -26.2041);
      expect(captured!['longitude'], 28.0473);
      expect(captured!['locationAccuracyM'], 12);
      expect(captured!['triggeredAt'], '2026-05-11T12:00:00.000Z');
      expect(captured!.containsKey('clientIdempotencyKey'), isTrue);

      expect(result, isA<AlertStatus>());
      expect(result.alertId, 'alert-uuid-1');
      expect(result.state, AlertState.pending);
      expect(result.latitude, -26.2041);
      expect(result.longitude, 28.0473);
    });

    // ── Path 14: clientIdempotencyKey is a real UUID v4 string ──────────
    test('clientIdempotencyKey looks like a UUID v4 (RFC 4122)', () async {
      Map<String, dynamic>? captured;
      when(() => api.post('/api/v1/alerts', any())).thenAnswer((invocation) async {
        captured =
            invocation.positionalArguments[1] as Map<String, dynamic>;
        return {
          'alertId': 'a',
          'status': 'Pending',
          'triggeredAt': '2026-05-11T12:00:00Z',
        };
      });

      await repo.sendEmergencyAlert(
        location: _pos(),
        triggeredAt: DateTime.utc(2026, 5, 11, 12),
      );

      // RFC 4122 v4 shape: 8-4-4-4-12 hex with version nibble = 4
      // and variant bits = 8/9/a/b in the first nibble of the 4th group.
      final key = captured!['clientIdempotencyKey'] as String;
      final v4 = RegExp(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
      );
      expect(v4.hasMatch(key), isTrue, reason: 'got: $key');
    });

    test('two consecutive sends produce different idempotency keys', () async {
      final keys = <String>[];
      when(() => api.post('/api/v1/alerts', any())).thenAnswer((invocation) async {
        final body =
            invocation.positionalArguments[1] as Map<String, dynamic>;
        keys.add(body['clientIdempotencyKey'] as String);
        return {
          'alertId': 'a',
          'status': 'Pending',
          'triggeredAt': '2026-05-11T12:00:00Z',
        };
      });

      await repo.sendEmergencyAlert(
        location: _pos(),
        triggeredAt: DateTime.utc(2026, 5, 11, 12),
      );
      await repo.sendEmergencyAlert(
        location: _pos(),
        triggeredAt: DateTime.utc(2026, 5, 11, 12, 0, 1),
      );
      expect(keys[0], isNot(equals(keys[1])));
    });
  });
}
