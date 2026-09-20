// Smoke test for the Dart & Flutter quiz app.
//
// Verifies that the app boots into the home screen and shows its
// title and call-to-action button.

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_quiz_app/main.dart';

void main() {
  testWidgets('Home screen shows title and Start Quiz button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const QuizApp());

    expect(find.text('Dart & Flutter Quiz'), findsOneWidget);
    expect(find.text('Start Quiz'), findsOneWidget);
  });
}
