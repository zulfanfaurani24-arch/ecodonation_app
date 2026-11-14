import 'package:flutter_test/flutter_test.dart';
import 'package:ecodonation_app/main.dart';

void main() {
  testWidgets('EcoDonationApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const EcoDonationApp());

    // Verify splash screen appears with app name
    expect(find.text('EcoDonation'), findsOneWidget);
  });
}
