// Basic smoke test verifying the app boots to the splash screen.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:real_estate/main.dart';

void main() {
  testWidgets('App boots and shows the splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const EstateHubApp());
    await tester.pump();

    expect(find.text('EstateHub'), findsOneWidget);
    expect(find.byIcon(Icons.home_work_rounded), findsOneWidget);
  });
}
