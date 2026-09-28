import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  final List<Task> tasks;
  final Function(String) onToggleTask;

  const HomeScreen({
    super.key,
    required this.tasks,
    required this.onToggleTask,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedFilter = 'All';

  // Pastel colors for cards
  final List<Color> _pastelColors = const [
    Color(0xFFE8D4F8), // Pastel Purple
    Color(0xFFFCE4EC), // Pastel Pink
    Color(0xFFFFF9C4), // Pastel Yellow
    Color(0xFFE3F2FD), // Pastel Blue
    Color(0xFFE8F5E9), // Pastel Green
    Color(0xFFFBE9E7), // Pastel Peach
  ];

  List<Task> get _todayTasks {
    final now = DateTime.now();
    return widget.tasks
        .where(
          (t) =>
              t.date.year == now.year &&
              t.date.month == now.month &&
              t.date.day == now.day,
        )
        .toList();
  }

  List<Task> get _filteredTasks {
    if (_selectedFilter == 'All') {
      return _todayTasks;
    }
    return _todayTasks.where((t) => t.category == _selectedFilter).toList();
  }

  int _getTaskCountForCategory(String category) {
    if (category == 'All') {
      return _todayTasks.length;
    }
    return _todayTasks.where((t) => t.category == category).length;
  }

  int get _completedCount => _todayTasks.where((t) => t.isCompleted).length;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildFilterChips(),
          const SizedBox(height: 24),
          _buildProgressCard(),
          const SizedBox(height: 28),
          _buildTasksHeader(),
          const SizedBox(height: 16),
          _buildTaskList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hey 👋',
              style: TextStyle(
                fontSize: 16,
                color: context.colors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Welcome Back',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: context.colors.textPrimary,
              ),
            ),
          ],
        ),
        Row(
          children: [
            _buildIconButton(
              Icons.emoji_events_outlined,
              const Color(0xFFE17055),
            ),
            const SizedBox(width: 8),
            _buildIconButton(Icons.filter_list, context.colors.textSecondary),
            const SizedBox(width: 8),
            _buildIconButton(Icons.search, context.colors.textSecondary),
          ],
        ),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: context.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Work', 'Personal', 'Health', 'Learning'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = _selectedFilter == filter;
          final count = _getTaskCountForCategory(filter);
          final label = filter == 'All' ? 'All ($count)' : '$filter ($count)';

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = filter),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? context.colors.textPrimary
                      : context.colors.background,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? context.colors.textPrimary
                        : context.colors.border,
                  ),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected
                        ? context.colors.background
                        : context.colors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProgressCard() {
    final totalCount = _todayTasks.length;
    final progress = totalCount == 0 ? 0.0 : _completedCount / totalCount;
    final percentage = (progress * 100).round();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: context.colors.border,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      kPrimaryGreen,
                    ),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$percentage%',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: context.colors.textPrimary,
                        ),
                      ),
                      Text(
                        'completed',
                        style: TextStyle(
                          fontSize: 10,
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Progress',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$_completedCount of $totalCount tasks done',
                  style: TextStyle(
                    fontSize: 14,
                    color: context.colors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Text('🔥', style: TextStyle(fontSize: 16)),
                    SizedBox(width: 4),
                    Text(
                      '7 day streak!',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE17055),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Today's Tasks",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: context.colors.textPrimary,
          ),
        ),
        Text(
          '${_filteredTasks.length} tasks',
          style: TextStyle(fontSize: 14, color: context.colors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildTaskList() {
    if (_filteredTasks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              Icon(Icons.task_alt, size: 64, color: context.colors.border),
              const SizedBox(height: 16),
              Text(
                'No tasks for today',
                style: TextStyle(fontSize: 16, color: context.colors.textMuted),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: _filteredTasks.asMap().entries.map((entry) {
        final index = entry.key;
        final task = entry.value;
        final color = _pastelColors[index % _pastelColors.length];
        return _buildPastelTaskCard(task, color);
      }).toList(),
    );
  }

  Widget _buildPastelTaskCard(Task task, Color color) {
    return GestureDetector(
      onTap: () => widget.onToggleTask(task.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with checkbox
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kOnPastel,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: task.isCompleted ? kPrimaryGreen : Colors.white,
                    border: Border.all(
                      color: task.isCompleted
                          ? kPrimaryGreen
                          : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  child: task.isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Description
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey.shade500),
                  ),
                ),
                Expanded(
                  child: Text(
                    task.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Footer: Date, Icons, Tags
            Row(
              children: [
                // Date
                Icon(Icons.schedule, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  '${task.date.day} ${_getMonthName(task.date.month)} ${task.date.year.toString().substring(2)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(width: 12),

                // Attachments
                if (task.attachments > 0) ...[
                  Icon(
                    Icons.attach_file,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${task.attachments}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(width: 8),
                ],

                // Comments
                if (task.comments > 0) ...[
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${task.comments}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(width: 8),
                ],

                const Spacer(),
              ],
            ),

            // Tags
            if (task.tags.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: task.tags
                    .map(
                      (tag) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: kOnPastel,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
