import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';
import '../widgets/task_tile.dart';

class CalendarScreen extends StatefulWidget {
  final List<Task> tasks;
  final Function(String) onToggleTask;

  const CalendarScreen({
    super.key,
    required this.tasks,
    required this.onToggleTask,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedDate;
  late DateTime _weekStart;
  late List<Map<String, dynamic>> _weekDays;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    // Start from 2 days ago
    _weekStart = DateTime(now.year, now.month, now.day - 2);
    _generateWeekDays();
  }

  void _shiftWeek(int days) {
    setState(() {
      _weekStart = DateTime(
        _weekStart.year,
        _weekStart.month,
        _weekStart.day + days,
      );
      _selectedDate = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day + days,
      );
      _generateWeekDays();
    });
  }

  void _generateWeekDays() {
    _weekDays = List.generate(7, (index) {
      final date = DateTime(
        _weekStart.year,
        _weekStart.month,
        _weekStart.day + index,
      );
      return {
        'day': _getDayName(date.weekday),
        'date': date.day,
        'fullDate': date,
      };
    });
  }

  String _getDayName(int weekday) {
    const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return days[weekday - 1];
  }

  List<Task> get _tasksForSelectedDate {
    return widget.tasks.where((task) {
      return task.date.year == _selectedDate.year &&
          task.date.month == _selectedDate.month &&
          task.date.day == _selectedDate.day;
    }).toList();
  }

  List<Task> get _pendingTasks =>
      _tasksForSelectedDate.where((t) => !t.isCompleted).toList();
  List<Task> get _completedTasks =>
      _tasksForSelectedDate.where((t) => t.isCompleted).toList();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCalendarHeader(),
          const SizedBox(height: 24),
          _buildDatePicker(),
          const SizedBox(height: 32),
          Text(
            'To do list',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),

          if (_tasksForSelectedDate.isEmpty) ...[
            _buildEmptyState(),
          ] else ...[
            if (_pendingTasks.isNotEmpty) ...[
              _buildTimeSection('Pending:'),
              const SizedBox(height: 12),
              ..._pendingTasks.map(
                (task) => _buildTaskTile(task, const Color(0xFFE8F5E9)),
              ),
            ],
            if (_completedTasks.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildTimeSection('Completed:'),
              const SizedBox(height: 12),
              ..._completedTasks.map(
                (task) => _buildTaskTile(task, const Color(0xFFEDE7F6)),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(Icons.event_available, size: 64, color: context.colors.border),
            const SizedBox(height: 16),
            Text(
              'No tasks for this date',
              style: TextStyle(fontSize: 16, color: context.colors.textMuted),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap + to add a new task',
              style: TextStyle(fontSize: 14, color: context.colors.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: context.colors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.calendar_today_outlined,
            color: context.colors.textPrimary,
            size: 22,
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.chevron_left, color: context.colors.textPrimary),
              onPressed: () => _shiftWeek(-7),
            ),
            Text(
              _isToday(_selectedDate)
                  ? 'Today'
                  : '${_selectedDate.day}/${_selectedDate.month}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: context.colors.textPrimary,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.chevron_right,
                color: context.colors.textPrimary,
              ),
              onPressed: () => _shiftWeek(7),
            ),
          ],
        ),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: context.colors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.more_horiz,
            color: context.colors.textPrimary,
            size: 22,
          ),
        ),
      ],
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  Widget _buildDatePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _weekDays.map((dayData) {
        final fullDate = dayData['fullDate'] as DateTime;
        final isSelected =
            fullDate.year == _selectedDate.year &&
            fullDate.month == _selectedDate.month &&
            fullDate.day == _selectedDate.day;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = fullDate;
            });
          },
          child: Column(
            children: [
              Text(
                dayData['day'],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? context.colors.textPrimary
                      : context.colors.textMuted,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? context.colors.textPrimary
                      : Colors.transparent,
                ),
                child: Center(
                  child: Text(
                    '${dayData['date']}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? context.colors.background
                          : context.colors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTimeSection(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: context.colors.textPrimary,
      ),
    );
  }

  Widget _buildTaskTile(Task task, Color color) {
    return TaskTile(
      title: task.title,
      isCompleted: task.isCompleted,
      backgroundColor: color,
      onToggle: () => widget.onToggleTask(task.id),
    );
  }
}
