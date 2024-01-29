import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:repit/src/feature/app/widget/app.dart';
import 'package:repit/src/feature/initialization/logic/initialization_processor.dart';
import 'package:repit/src/feature/initialization/model/environment_store.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('tap on the floating action button, verify counter',
        (tester) async {
      const environmentStore = EnvironmentStore();
      final initializationProcessor = InitializationProcessor(
        environmentStore: environmentStore,
      );
      final result = await initializationProcessor.initialize();
      await tester.pumpWidget(App(result: result));
      final textFinder = find.byIcon(Icons.add);
      expect(textFinder, findsOneWidget);
      await tester.tap(textFinder);
      await tester.pumpAndSettle();
      //await Future.delayed(const Duration(seconds: 5));
    });
  });
}
