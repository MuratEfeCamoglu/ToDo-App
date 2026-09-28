import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/task_storage.dart';
import '../theme/app_theme.dart';
import '../widgets/add_task_sheet.dart';
import 'home_screen.dart';
import 'calendar_screen.dart';
import 'category_screen.dart';
import 'profile_screen.dart';

class MainScaffold extends StatefulWidget {
  final TaskStorage storage;
  final bool isDarkMode;
  final ValueChanged<bool> onDarkModeChanged;

  const MainScaffold({
    super.key,
    required this.storage,
    required this.isDarkMode,
    required this.onDarkModeChanged,
  });

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;
  List<Task> _tasks = [];

  final List<String> _categories = ['Work', 'Personal', 'Health', 'Learning'];

  @override
  void initState() {
    super.initState();
    _tasks = widget.storage.loadTasks();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _toggleTask(String taskId) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == taskId);
      if (index != -1) {
        _tasks[index].isCompleted = !_tasks[index].isCompleted;
      }
    });
    widget.storage.saveTasks(_tasks);
  }

  void _addTask(Task task) {
    setState(() {
      _tasks.add(task);
    });
    widget.storage.saveTasks(_tasks);
  }

  void _showAddTaskModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          AddTaskSheet(categories: _categories, onSave: _addTask),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final screens = [
      HomeScreen(tasks: _tasks, onToggleTask: _toggleTask),
      CalendarScreen(tasks: _tasks, onToggleTask: _toggleTask),
      CategoryScreen(tasks: _tasks),
      ProfileScreen(
        isDarkMode: widget.isDarkMode,
        onDarkModeChanged: widget.onDarkModeChanged,
      ),
    ];

    return Scaffold(
      body: SafeArea(child: screens[_currentIndex]),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskModal,
        backgroundColor: kPrimaryGreen,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colors.background,
          boxShadow: [
            BoxShadow(
              color: colors.divider,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: colors.background,
          selectedItemColor: kPrimaryGreen,
          unselectedItemColor: colors.textMuted,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              activeIcon: Icon(Icons.calendar_today),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined),
              activeIcon: Icon(Icons.grid_view),
              label: 'Category',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
