import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arjuna/main.dart';

void main() {
  testWidgets('MyApp initializes and renders correctly', (WidgetTester tester) async {
    // Build the widget tree and trigger a frame
    await tester.pumpWidget(MyApp());

    // Wait for any animations or transitions
    await tester.pumpAndSettle();

    // Verify if the MaterialApp widget is present
    expect(find.byType(MaterialApp), findsOneWidget);

  });
}
