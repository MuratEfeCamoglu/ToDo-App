import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/main.dart';

void main() {
  testWidgets('App should display MainScaffold with bottom navigation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TodoApp());

    // Verify bottom navigation items are present
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Calendar'), findsOneWidget);
    expect(find.text('Category'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // Verify FAB is present
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('Bottom navigation switches screens', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TodoApp());

    // Initially on Home screen
    expect(find.text('Welcome Back'), findsOneWidget);

    // Tap Calendar tab
    await tester.tap(find.text('Calendar'));
    await tester.pumpAndSettle();
    expect(find.text('To do list'), findsOneWidget);

    // Tap Category tab
    await tester.tap(find.text('Category'));
    await tester.pumpAndSettle();
    expect(find.text('Categories'), findsOneWidget);

    // Tap Profile tab
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Alexandra'), findsOneWidget);
  });

  testWidgets('FAB opens modal bottom sheet', (WidgetTester tester) async {
    await tester.pumpWidget(const TodoApp());

    // Tap FAB
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Verify modal is open by checking for Add New Task text
    expect(find.text('Add New Task'), findsOneWidget);
  });
}
