import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/main.dart';

void main() {
  testWidgets('Hello Recipe App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.runAsync(() async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MyApp(),
        ),
      );
      // Wait for initial load but don't wait for infinite animations (Shimmers)
      await tester.pump(const Duration(seconds: 2));
    });

    // Verify that our app shows the welcome text.
    expect(find.text('DISCOVER'), findsOneWidget);
  });
}
