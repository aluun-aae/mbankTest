import 'package:flutter_test/flutter_test.dart';
import 'package:test_work_mbank/features/manufacturers/presentation/screens/manufaturer_main_screen.dart';

import 'package:test_work_mbank/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('tap on card in mainScreen', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.byType(MainScreen), findsOneWidget);
    });
  });
}
