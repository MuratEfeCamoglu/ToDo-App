import 'package:flutter/material.dart';
import '../models/task_model.dart';

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
  late List<Map<String, dynamic>> _weekDays;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _generateWeekDays();
  }

  void _generateWeekDays() {
    final now = DateTime.now();
    // Start from 2 days ago
    final startDate = now.subtract(const Duration(days: 2));
    _weekDays = List.generate(7, (index) {
      final date = startDate.add(Duration(days: index));
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

  List<Task> get _morningTasks =>
      _tasksForSelectedDate.where((t) => !t.isCompleted).toList();
  List<Task> get _afternoonTasks =>
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
          const Text(
            'To do list',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3436),
            ),
          ),
          const SizedBox(height: 24),

          if (_tasksForSelectedDate.isEmpty) ...[
            _buildEmptyState(),
          ] else ...[
            if (_morningTasks.isNotEmpty) ...[
              _buildTimeSection('Morning:'),
              const SizedBox(height: 12),
              ..._morningTasks.map(
                (task) => _buildTaskTile(task, const Color(0xFFE8F5E9)),
              ),
            ],
            if (_afternoonTasks.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildTimeSection('Completed:'),
              const SizedBox(height: 12),
              ..._afternoonTasks.map(
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
            Icon(Icons.event_available, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'No tasks for this date',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap + to add a new task',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
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
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.calendar_today_outlined,
            color: Color(0xFF2D3436),
            size: 22,
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, color: Color(0xFF2D3436)),
              onPressed: () {
                setState(() {
                  _selectedDate = _selectedDate.subtract(
                    const Duration(days: 7),
                  );
                  _generateWeekDays();
                });
              },
            ),
            Text(
              _isToday(_selectedDate)
                  ? 'Today'
                  : '${_selectedDate.day}/${_selectedDate.month}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3436),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: Color(0xFF2D3436)),
              onPressed: () {
                setState(() {
                  _selectedDate = _selectedDate.add(const Duration(days: 7));
                  _generateWeekDays();
                });
              },
            ),
          ],
        ),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.more_horiz,
            color: Color(0xFF2D3436),
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
                      ? const Color(0xFF2D3436)
                      : Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? const Color(0xFF2D3436)
                      : Colors.transparent,
                ),
                child: Center(
                  child: Text(
                    '${dayData['date']}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF2D3436),
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
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2D3436),
      ),
    );
  }

  Widget _buildTaskTile(Task task, Color color) {
    return GestureDetector(
      onTap: () => widget.onToggleTask(task.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: task.isCompleted
                    ? const Color(0xFF4CAF50)
                    : Colors.transparent,
                border: Border.all(
                  color: task.isCompleted
                      ? const Color(0xFF4CAF50)
                      : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: task.isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                task.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2D3436),
                  decoration: task.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
