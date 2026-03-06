import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synq/main.dart';

void main() {
  testWidgets('Basic smoke test', (WidgetTester tester) async {
    // Build your app and trigger a frame.
    await tester.pumpWidget(const SynqApp());

    // Since your app uses Firebase and routing, we can't directly check a counter.
    // Instead, just check if your login screen is present (example):
    expect(
      find.text('Login'),
      findsOneWidget,
    ); // adjust to a widget/text on your login screen
  });
}
