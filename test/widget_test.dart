import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/main.dart';

void main() {
  testWidgets('Hello Recipe App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Verify that our app shows the welcome text.
    expect(find.text('Hello Recipe App'), findsOneWidget);
    expect(find.text('Recipe Discovery'), findsOneWidget);
  });
}
