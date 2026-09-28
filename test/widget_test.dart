import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/services/task_storage.dart';

Future<TaskStorage> createStorage([Map<String, Object> values = const {}]) {
  SharedPreferences.setMockInitialValues(values);
  return TaskStorage.create();
}

void main() {
  testWidgets('App should display MainScaffold with bottom navigation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(TodoApp(storage: await createStorage()));

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
    await tester.pumpWidget(TodoApp(storage: await createStorage()));

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
    await tester.pumpWidget(TodoApp(storage: await createStorage()));

    // Tap FAB
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Verify modal is open by checking for Add New Task text
    expect(find.text('Add New Task'), findsOneWidget);
  });

  testWidgets('Adding a task shows it on Home and in Categories', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(TodoApp(storage: await createStorage()));

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '  Read a book  ');
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Learning').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save Task'));
    await tester.pumpAndSettle();

    expect(find.text('Read a book'), findsOneWidget);
    expect(find.text('Learning (1)'), findsOneWidget);

    await tester.tap(find.text('Category'));
    await tester.pumpAndSettle();
    // Counts come from real tasks: Work 4, Personal/Health/Learning 1 each.
    expect(find.text('4 tasks'), findsOneWidget);
    expect(find.text('1 task'), findsNWidgets(3));
  });

  testWidgets('Whitespace-only title does not create a task', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(TodoApp(storage: await createStorage()));

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '   ');
    await tester.tap(find.text('Save Task'));
    await tester.pumpAndSettle();

    expect(find.text('Add New Task'), findsOneWidget);
  });

  testWidgets('Calendar arrows move the visible week', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(TodoApp(storage: await createStorage()));
    await tester.tap(find.text('Calendar'));
    await tester.pumpAndSettle();

    final now = DateTime.now();
    final nextWeek = DateTime(now.year, now.month, now.day + 7);

    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pumpAndSettle();

    expect(find.text('${nextWeek.day}/${nextWeek.month}'), findsOneWidget);
    // The selected day (white text in the dark circle) is in the new strip.
    final selected = tester.widget<Text>(find.text('${nextWeek.day}').first);
    expect(selected.style?.color, Colors.white);
  });

  testWidgets('Appearance switch enables dark mode and remembers it', (
    WidgetTester tester,
  ) async {
    final storage = await createStorage();
    await tester.pumpWidget(TodoApp(storage: storage));

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byType(Switch));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    final context = tester.element(find.text('Alexandra'));
    expect(Theme.of(context).brightness, Brightness.dark);
    expect(storage.loadDarkMode(), isTrue);
  });

  testWidgets('Added and toggled tasks are saved to storage', (
    WidgetTester tester,
  ) async {
    final storage = await createStorage();
    await tester.pumpWidget(TodoApp(storage: storage));

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Buy milk');
    await tester.tap(find.text('Save Task'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Buy milk'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Buy milk'));
    await tester.pumpAndSettle();

    final saved = storage.loadTasks();
    final task = saved.firstWhere((t) => t.title == 'Buy milk');
    expect(task.isCompleted, isTrue);
    expect(saved.length, 7);
  });
}
