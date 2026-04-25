import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/src/core/network/connectivity_provider.dart';
import 'package:recipe_app/src/core/widgets/offline_banner.dart';

void main() {
  testWidgets('OfflineBanner shows when status is none', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          connectivityStatusProvider.overrideWith(
            (ref) => Stream.value(ConnectivityStatus.none),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: OfflineBanner(),
          ),
        ),
      ),
    );

    await tester.pump(); // Start animation
    await tester.pumpAndSettle();

    expect(find.text('You are offline. Showing saved recipes.'), findsOneWidget);
    expect(find.byIcon(Icons.wifi_off), findsOneWidget);
  });

  testWidgets('OfflineBanner hides when status is not none', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          connectivityStatusProvider.overrideWith(
            (ref) => Stream.value(ConnectivityStatus.wifi),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: OfflineBanner(),
          ),
        ),
      ),
    );

    await tester.pump(); // Start animation
    await tester.pumpAndSettle();

    expect(find.text('You are offline. Showing saved recipes.'), findsNothing);
  });
}
