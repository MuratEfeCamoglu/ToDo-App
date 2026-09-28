import 'package:flutter/material.dart';
import 'screens/main_scaffold.dart';
import 'services/task_storage.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await TaskStorage.create();
  runApp(TodoApp(storage: storage));
}

class TodoApp extends StatefulWidget {
  final TaskStorage storage;

  const TodoApp({super.key, required this.storage});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.storage.loadDarkMode();
  }

  void _setDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
    widget.storage.saveDarkMode(value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(Brightness.light),
      darkTheme: buildAppTheme(Brightness.dark),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: MainScaffold(
        storage: widget.storage,
        isDarkMode: _isDarkMode,
        onDarkModeChanged: _setDarkMode,
      ),
    );
  }
}
