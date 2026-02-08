// Basic widget test for MYPanic app.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_panic/main.dart';

void main() {
  testWidgets('MYPanic app starts successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MyPanicApp(),
      ),
    );

    // Verify that the home screen loads with the MYPanic title
    expect(find.text('MYPanic'), findsOneWidget);
    expect(find.text('Student Safety'), findsOneWidget);

    // Verify the panic button is present
    expect(find.text('PANIC'), findsOneWidget);
  });
}
