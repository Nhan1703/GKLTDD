// Basic smoke test — app builds after API module init.

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/core/di/api_module.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    ApiModule.instance.initialize(enableLogging: false);
  });

  testWidgets('Fellow4U app builds', (WidgetTester tester) async {
    await tester.pumpWidget(const Fellow4UApp());
    await tester.pump();
    expect(find.byType(Fellow4UApp), findsOneWidget);
  });
}
