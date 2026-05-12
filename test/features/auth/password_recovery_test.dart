import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_panic/features/auth/presentation/providers/auth_notifier.dart';

void main() {
  group('PasswordRecovery notifier', () {
    test('starts in the cleared state (false)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(passwordRecoveryProvider), isFalse);
    });

    test('mark() flips state to true', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(passwordRecoveryProvider.notifier).mark();

      expect(container.read(passwordRecoveryProvider), isTrue);
    });

    test('clear() flips state back to false', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(passwordRecoveryProvider.notifier).mark();
      container.read(passwordRecoveryProvider.notifier).clear();

      expect(container.read(passwordRecoveryProvider), isFalse);
    });

    test('auto-expires after the recovery window so a stale flag cannot trap'
        ' the user', () {
      fakeAsync((async) {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        container.read(passwordRecoveryProvider.notifier).mark();
        expect(container.read(passwordRecoveryProvider), isTrue);

        // Just before the window — still active.
        async.elapse(const Duration(minutes: 4, seconds: 59));
        expect(container.read(passwordRecoveryProvider), isTrue,
            reason: 'flag should still be set just before the timer fires');

        // Just after — auto-cleared.
        async.elapse(const Duration(seconds: 2));
        expect(container.read(passwordRecoveryProvider), isFalse,
            reason: 'flag must auto-clear past the recovery window');
      });
    });

    test('a second mark() resets the timer', () {
      fakeAsync((async) {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        container.read(passwordRecoveryProvider.notifier).mark();

        async.elapse(const Duration(minutes: 4));
        // Re-mark just before the original timer would have fired.
        container.read(passwordRecoveryProvider.notifier).mark();
        expect(container.read(passwordRecoveryProvider), isTrue);

        // Original timer would have fired here (5 min from first mark) —
        // but the second mark cancelled it, so flag is still set.
        async.elapse(const Duration(minutes: 2));
        expect(container.read(passwordRecoveryProvider), isTrue,
            reason: 'second mark() must cancel and restart the expiry timer');

        // 5 min after the second mark — now it expires.
        async.elapse(const Duration(minutes: 4));
        expect(container.read(passwordRecoveryProvider), isFalse);
      });
    });
  });
}
